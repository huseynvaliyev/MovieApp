//
//  MovieDetailViewController.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 16.07.2021.
//

import UIKit
import Kingfisher
import CoreData

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
    
    var movie: Movie!
    var favouriteMovies: [Int]!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = movie.title
        populateView()
    }
    
    private func populateView() {
        movieImage.kf.setImage(with: movie.formattedImagePoster)
        movieTitleLabel.text = movie.title
        movieRatingLabel.text = movie.formattedRating
        movieDescriptionLabel.text = movie.description
        movieDateLabel.text = movie.date
        if favouriteMovies.contains(movie.id!) {
            favouriteButton.image = UIImage(systemName: "star.fill")
        }
    }
    
    @IBAction func addFavourite(_ sender: Any) {
        if favouriteMovies.contains(movie.id!) {
            let index = favouriteMovies.firstIndex{$0 == movie.id!}
            let alert = UIAlertController(title: "Remove From Favourites", message: "Are you sure about remove from favourites?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in }))
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Favourites")
                fetchRequest.predicate = NSPredicate(format: "id = %@", "\(self.movie.id!)")
                self.favouriteButton.image = UIImage(systemName: "star")
                self.favouriteMovies.remove(at: index!)
                do {
                    let fetchedResults =  try context.fetch(fetchRequest) as? [NSManagedObject]
                    for entity in fetchedResults! {
                        context.delete(entity)
                    }
                    try context.save()
                } catch {
                    print("Error happening delete")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let newFavouriteMovie = NSEntityDescription.insertNewObject(forEntityName: "Favourites", into: context)
            newFavouriteMovie.setValue(movie.id, forKey: "id")
            favouriteButton.image = UIImage(systemName: "star.fill")
            favouriteMovies.append(movie.id!)
            do {
                try context.save()
            } catch  {
                print("Error happening while adding favourite")
            }
        }
    }
    
}
