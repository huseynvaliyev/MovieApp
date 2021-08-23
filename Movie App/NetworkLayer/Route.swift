//
//  Route.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 17.07.2021.
//

import Foundation

enum Route {
    static let baseURL = "https://api.themoviedb.org/3"
    
    case fetchPopularMovies
    
    var description: String {
        switch self {
        case .fetchPopularMovies:
            return "/movie/popular"
        }
    }
    
}
