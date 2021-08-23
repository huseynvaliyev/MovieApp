//
//  ApiResponse.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 17.07.2021.
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?
}
