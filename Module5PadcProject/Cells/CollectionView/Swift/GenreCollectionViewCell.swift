//
//  GenreCollectionViewCell.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 18/02/2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genreContainerView: UIView!
    @IBOutlet weak var genreTitle: UILabel!
    var genre:GenreTitle?
    {
        didSet
        {
            if let data = genre
            {
                genreTitle.text = data.genreTitle
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundTheCorners()
    }

}

extension GenreCollectionViewCell
{
    private func roundTheCorners()
    {
        genreContainerView.layer.borderWidth = 0.5
        genreContainerView.clipsToBounds = true
        genreContainerView.layer.cornerRadius = 7.5
    }
}
