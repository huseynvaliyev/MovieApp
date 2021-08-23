//
//  AppError.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 17.07.2021.
//

import Foundation

enum AppError: LocalizedError {
    
    case errorDecoding
    case unknownError
    case invalidUrl
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .errorDecoding:
            return "Response could not be decoded"
        case .unknownError:
            return "I dont have any idea what go on"
        case .invalidUrl:
            return "Give me a valid url"
        case .serverError(let error):
            return error
        }
    }
}
