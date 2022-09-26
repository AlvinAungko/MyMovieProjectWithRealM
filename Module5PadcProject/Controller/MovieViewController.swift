//
//  MovieViewController.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 14/02/2022.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var heightOfComingSoonCollectionView: NSLayoutConstraint!
    @IBOutlet weak var heightOfNowShowingCollectionView: NSLayoutConstraint!
    @IBOutlet weak var comingSoonMovieListCollectionView: UICollectionView!
    @IBOutlet weak var nowShowingMovieListCollectionView: UICollectionView!
    
    @IBOutlet weak var profileUserName: UILabel!
    var userName = String()
   
    
    var movieAppDelegate:MovieAppDelegate?
    
    var dummyNowShowingMovieList = Array<DummyMovie>()
    
    var dummyUpcomingMovieList = Array<DummyMovie>()
    
    let movieModelShared = MovieModelLayer.shared
    
    var comingSoonMovies:Array<Movie>?
    {
        didSet
        {
            if let _ = comingSoonMovies
            {
                self.comingSoonMovieListCollectionView.reloadData()
            }
        }
    }
    
    var nowShowingMovies:Array<Movie>?
    {
        didSet
        {
            if let _ = nowShowingMovies
            {
                self.nowShowingMovieListCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        bindMovieToNowShow()
//        bindMovieToUpShow()
        setHeightForCollectionViews()
        registerCells()
        setDataSourceDelegate()
        setDelegate()
        bindTheNameToTheUser()
        fetchTheNowShowingMovies()
        fetchTheComingSoonMovies()
        

        // Do any additional setup after loading the view.
    }
    
}

extension MovieViewController
{
    private func bindMovieToNowShow()
    {
        dummyNowShowingMovieList = [
            DummyMovie(image: "firstMovieImage", title: "Naruto and the lost sons of Odin", genre: "Horror,Adventure,Comedy"),
            DummyMovie(image: "secondMovieImage", title: "Naruto and the lost sons of Odin", genre: "Anime,Comedy and Dark"),
            DummyMovie(image: "thirdMovieImage", title: "Jigen: The Worst Villain with a moon", genre: "Anime,Horror,Blood"),
            DummyMovie(image: "forthMovieImage", title: "Demon Hunter And Dragon Ball Z Kai", genre: "Horror, Blood, Nowhere"),
            DummyMovie(image: "fifthMovieImage", title: "This is the last anime movie", genre: "Horror, Blood, Humiliation")
        ]
    }
    
    private func bindMovieToUpShow()
    {
        dummyUpcomingMovieList = [
            DummyMovie(image: "sixthMovieImage", title: "Naruto and the lost sons of Odin", genre: "Horror,Adventure,Comedy"),
            DummyMovie(image: "seventhMovieImage", title: "Naruto and the lost sons of Odin", genre: "Anime,Comedy and Dark"),
            DummyMovie(image: "eighthMovieImage", title: "Jigen: The Worst Villain with a moon", genre: "Anime,Horror,Blood"),
            DummyMovie(image: "ninthMovieImage", title: "Demon Hunter And Dragon Ball Z Kai", genre: "Horror, Blood, Nowhere"),
            DummyMovie(image: "tenthMovieImage", title: "This is the last anime movie", genre: "Horror, Blood, Humiliation")
        ]
    }
}

extension MovieViewController
{
    private func setDataSourceDelegate()
    {
        nowShowingMovieListCollectionView.dataSource = self
        nowShowingMovieListCollectionView.delegate = self
        
        comingSoonMovieListCollectionView.dataSource = self
        comingSoonMovieListCollectionView.delegate = self
    }
    
    private func registerCells()
    {
        nowShowingMovieListCollectionView.registerCustomCells(identifier: NowShowingMovieCollectionViewCell.identifier)
        comingSoonMovieListCollectionView.registerCustomCells(identifier: NowShowingMovieCollectionViewCell.identifier)
    }
    
    private func setHeightForCollectionViews()
    {
        heightOfComingSoonCollectionView.constant = 353
        heightOfNowShowingCollectionView.constant = 353
        self.comingSoonMovieListCollectionView.layoutIfNeeded()
        self.nowShowingMovieListCollectionView.layoutIfNeeded()
    }
}

//MARK: Fetch The Data From The Mode Layer

extension MovieViewController
{
    func bindTheNameToTheUser()
    {
        let defaults = UserDefaults.standard
        guard let userName = defaults.string(forKey: "userName") else {return}
        profileUserName.text = userName
    }
    
    func fetchTheNowShowingMovies()
    {
        movieModelShared.fetchNowPlayingMovies {
            switch $0
            {
            case.success(let listOfMovies):
                self.nowShowingMovies = listOfMovies
            case.failure(let errorMessage):debugPrint(errorMessage)
            }
        }
    }
    
    func fetchTheComingSoonMovies()
    {
        movieModelShared.fetchComingSoonMovies {
            switch $0
            {
            case.success(let listOfMovies):
                self.comingSoonMovies = listOfMovies
            case.failure(let errorMessage):debugPrint(errorMessage)
            }
        }
    }
}

extension MovieViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == nowShowingMovieListCollectionView
        {
            return nowShowingMovies?.count ?? 0
        } else
        {
            return comingSoonMovies?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == nowShowingMovieListCollectionView
        {
            let cell = nowShowingMovieListCollectionView.bindCustomCellToTheChambers(identifier: NowShowingMovieCollectionViewCell.identifier, indexPath: indexPath) as NowShowingMovieCollectionViewCell
            
            cell.movieData = nowShowingMovies?[indexPath.row]
            
            cell.onTabMovie = {
                movieID in
                
                self.setUpTheMovieIDForUserDefault(movieID: movieID)
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
                    return
                }
                vc.movieID = movieID
                
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            }
            
            
            return cell
        } else
        {
            let cell = comingSoonMovieListCollectionView.bindCustomCellToTheChambers(identifier: NowShowingMovieCollectionViewCell.identifier, indexPath: indexPath) as NowShowingMovieCollectionViewCell
            
            cell.movieData = comingSoonMovies?[indexPath.row]
            
            cell.onTabMovie = {
                movieID in
                
                self.setUpTheMovieIDForUserDefault(movieID: movieID)
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
                    return
                }
                vc.movieID = movieID
                
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == nowShowingMovieListCollectionView
        {
            return CGSize(width: nowShowingMovieListCollectionView.bounds.width/1.9, height: heightOfNowShowingCollectionView.constant)
        }
        else
        {
            return CGSize(width: nowShowingMovieListCollectionView.bounds.width/1.8, height: heightOfNowShowingCollectionView.constant)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == nowShowingMovieListCollectionView
        {
            movieAppDelegate?.navigateToMovieList()
        }
        else
        {
            movieAppDelegate?.navigateToMovieList()
        }
    }
}

extension MovieViewController:MovieAppDelegate
{
    func navigateToMovieList() {
        navigateToViewController(identifier: MOVIE_DETAIL_VIEW_CONTROLLER)
    }
    
    func setUpTheMovieIDForUserDefault(movieID:Int)
    {
        let defaults = UserDefaults.standard
        defaults.set(movieID, forKey: "movieID")
    }
}

extension MovieViewController
{
    private func setDelegate()
    {
        self.movieAppDelegate = self
    }
}

