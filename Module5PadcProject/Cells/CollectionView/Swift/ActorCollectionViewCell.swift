//
//  ActorCollectionViewCell.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 18/02/2022.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {

    
    var actor:Cast?
    {
        didSet
        {
            if let data = actor
            {
                actorImage.sd_setImage(with: URL(string: "\(EasyConstants.urlImage)\(data.profilePath ?? "")"))
            }
        }
    }
    
    var actorDetail:Actor?
    {
        didSet
        {
            if let data = actorDetail
            {
                self.actorImage.image = UIImage(named: data.imageName)
            }
        }
    }
    
    @IBOutlet weak var actorImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
