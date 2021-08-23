//
//  MoviePortraitCollectionViewCell.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 16.07.2021.
//

import UIKit
import Kingfisher

class MoviePortraitCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: MoviePortraitCollectionViewCell.self)
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    
    func setup(movie: Movie) {
        movieImage.kf.setImage(with: movie.formattedImagePoster)
        movieTitleLabel.text = movie.title
    }
}
