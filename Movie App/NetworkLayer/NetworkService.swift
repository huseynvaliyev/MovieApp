//
//  NetworkService.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 17.07.2021.
//

import Foundation

struct NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchPopularMovies(apiKey: String, page: Int, completion: @escaping(Result<Root, Error>) -> Void){
        let params = ["api_key": apiKey, "page": page] as [String : Any]
        request(route: .fetchPopularMovies, method: .get, parameters: params, completion: completion)
    }
    
    
    private func request<T: Decodable>(route: Route, method: Methods, parameters: [String: Any]? = nil, completion: @escaping(Result<T, Error>) -> Void) {
        
        guard let request = createRequest(route: route, method: method, parameters: parameters) else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            var result: Result<Data, Error>?
            if let data = data {
                result = .success(data)
//                let responseString = String(data: data, encoding: .utf8) ?? "Could not stringify our data"
//                print("The response is:\n \(responseString)")
            } else if let error = error {
                result = .failure(error)
                print("The error is: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion)
            }
            
        }.resume()
        
    }
    
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> Void) {
        
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(Root.self, from: data) else {
                completion(.failure(AppError.errorDecoding))
                return
            }
            //print("Response:\(response.results)")
            completion(.success(response as! T))
            
        case .failure(let error):
            completion(.failure(error))
        }
        
    }
    
    
    private func createRequest(route: Route, method: Methods, parameters: [String: Any]? = nil) -> URLRequest? {
        let urlString = Route.baseURL + route.description
        guard let url = URL(string: urlString) else { return nil}
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponnet = URLComponents(string: urlString)
                urlComponnet?.queryItems = params.map {URLQueryItem(name: $0, value: "\($1)")}
                urlRequest.url = urlComponnet?.url
            case .post, .delete, .patch:
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        return urlRequest
    }
    
}
