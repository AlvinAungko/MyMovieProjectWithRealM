//
//  NowShowingMovieCollectionViewCell.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 18/02/2022.
//

import UIKit
import SDWebImage

class NowShowingMovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    var onTabMovie:(Int)->Void = {_ in}
    
    var movieData:Movie?
    {
        didSet
        {
            if let movieData = movieData
            {
                self.movieTitle.text = movieData.title ?? ""
                movieImage.sd_setImage(with: URL(string: "\(EasyConstants.urlImage)\(movieData.backdropPath ?? "")"))
            }
        }
    }
    
    
    var movie:DummyMovie?
    {
        didSet
        {
            if let data = movie
            {
                self.movieTitle.text = data.movieTitle
                self.movieGenre.text = data.movieGenre
                self.movieImage.image = UIImage(named: data.movieImage)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addTapGesture()
    }

}

extension NowShowingMovieCollectionViewCell
{
    func addTapGesture()
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTab))
        
        movieImage.addGestureRecognizer(tapGestureRecognizer)
        
        movieImage.isUserInteractionEnabled = true
        
    }
    
    @objc func onTab()
    {
        onTabMovie(movieData?.id ?? 0)
    }
}
