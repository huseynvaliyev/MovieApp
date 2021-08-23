//
//  Root.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 17.07.2021.
//

import Foundation

struct Root: Decodable {
    let page: Int?
    let results: [Movie]?
    let totalPage: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPage = "total_pages"
    }
}
