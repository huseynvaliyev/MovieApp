//
//  MovieLandscapeCollectionViewCell.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 15.07.2021.
//

import UIKit
import Kingfisher
//import CoreData

class MovieLandscapeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MovieLandscapeCollectionViewCell.self)
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDetailLabel: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var starIcon: UIImageView!
    
    func setup(movie: Movie, favouriteMovies: [Int]) {
        movieTitle.text = movie.title
        movieRating.text = movie.formattedRating
        movieImage.kf.setImage(with: movie.formattedImagePoster)
        movieDetailLabel.text = movie.description
        if favouriteMovies.contains(movie.id!) {
            starIcon.isHidden = false
        } else {
            starIcon.isHidden = true
        }
    }
    
}
