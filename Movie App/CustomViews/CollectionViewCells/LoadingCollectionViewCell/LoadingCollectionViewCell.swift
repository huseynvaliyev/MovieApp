//
//  LoadingCollectionViewCell.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 17.07.2021.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: LoadingCollectionViewCell.self)
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
}
