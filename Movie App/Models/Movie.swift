//
//  Film.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 15.07.2021.
//

import Foundation

struct Movie: Decodable {
    
    let adult: Bool?
    let backdrop: String?
    let genres: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let description: String?
    let popularity: Double?
    let moviePoster: String?
    let date: String?
    let title: String?
    let video: Bool?
    let rating: Double?
    let voteCount: Int?
    
    var formattedRating: String {
        return "Rating: \(rating ?? 0)"
    }
    
    var formattedImagePoster: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w300\(moviePoster ?? "")")
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdrop = "backdrop_path"
        case genres = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case description = "overview"
        case popularity
        case moviePoster = "poster_path"
        case date = "release_date"
        case title
        case video
        case rating = "vote_average"
        case voteCount = "vote_count"
    }
    
}
