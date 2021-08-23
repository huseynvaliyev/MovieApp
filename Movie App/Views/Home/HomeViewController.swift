//
//  HomeViewController.swift
//  Movie App
//
//  Created by Huseyn Valiyev on 15.07.2021.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var swichLayoutBarButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var layoutType = "list"
    var searching = false
    var searchedMovies = [Movie]()
    var currentPage = 1
    var totalPage = 1
    let apiKey = "0996e4b514153d193461ebdeb5005492"
    
    var movies: [Movie] = []
    var favouriteMovies = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFavouriteMovies()
        registerCell()
        NetworkService.shared.fetchPopularMovies(apiKey: apiKey, page: currentPage) { [weak self] (result) in
            switch result {
            case .success(let allMovies):
                self?.movies = allMovies.results ?? []
                self?.totalPage = allMovies.totalPage ?? 1
                self?.collectionView.reloadData()
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFavouriteMovies()
        collectionView.reloadData()
    }
    
    private func getFavouriteMovies() {
        favouriteMovies.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourites")
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    guard let id = result.value(forKey: "id") as? Int else { return }
                    favouriteMovies.append(id)
                }
            }
        } catch {
            print("Error happening get Favourites")
        }
    }
    
    private func registerCell() {
        collectionView.register(UINib(nibName: MovieLandscapeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieLandscapeCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: MoviePortraitCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MoviePortraitCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: LoadingCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: LoadingCollectionViewCell.identifier)
    }
    
    @IBAction func switchLayout(_ sender: Any) {
        if layoutType == "list" {
            swichLayoutBarButton.image? = UIImage(systemName: "rectangle.grid.1x2") ?? UIImage()
            layoutType = "grid"
            collectionView.reloadData()
        } else {
            swichLayoutBarButton.image? = UIImage(systemName: "square.grid.2x2") ?? UIImage()
            layoutType = "list"
            collectionView.reloadData()
        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            if searchedMovies.count == 0 {
                collectionView.setEmptyView(title: "Sorry, the movie was not found.", message: "Try searching for another movie")
            }
            return searchedMovies.count
        } else {
            return movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let movie: Movie
    
        if searching {
            movie = searchedMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        
        if layoutType == "list" {
            if currentPage < totalPage && indexPath.row == movies.count - 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.identifier, for: indexPath) as! LoadingCollectionViewCell
                cell.spinner.startAnimating()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieLandscapeCollectionViewCell.identifier, for: indexPath) as! MovieLandscapeCollectionViewCell
                cell.setup(movie: movie, favouriteMovies: favouriteMovies)
                    return cell
            }
        } else {
            if currentPage < totalPage && indexPath.row == movies.count - 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.identifier, for: indexPath) as! LoadingCollectionViewCell
                cell.spinner.startAnimating()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePortraitCollectionViewCell.identifier, for: indexPath) as! MoviePortraitCollectionViewCell
                cell.setup(movie: movie)
                    return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layoutType == "list" {
            return CGSize(width: view.frame.width - 20, height: 200)
        } else {
            let noOfCellsInRow = 2
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: 400)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
        if searching {
            controller.movie = searchedMovies[indexPath.row]
        } else {
            controller.movie = movies[indexPath.row]
        }
        controller.favouriteMovies = favouriteMovies
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPage && indexPath.row == movies.count - 1 {
            currentPage += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                NetworkService.shared.fetchPopularMovies(apiKey: self.apiKey, page: self.currentPage) { [weak self] (result) in
                    switch result {
                    case .success(let newMovies):
                        self?.movies += newMovies.results!
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print("New fetch eor\(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView.restore()
        searchedMovies = movies.filter({ (movie: Movie) -> Bool in
            return movie.title?.lowercased().contains(searchText.lowercased()) ?? false
        })
        searching = true
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        collectionView.reloadData()
        collectionView.restore()
    }
}
