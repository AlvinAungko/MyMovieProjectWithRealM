//
//  PaymentCardCollectionViewCell.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 19/02/2022.
//

import UIKit

class PaymentCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardDecriptionLabel: UILabel!
    
    @IBOutlet weak var cardNameLabel: UILabel!
    
    var customCard:PaymentCard?
    {
      didSet
        {
          if let data = customCard
            {
              self.cardNameLabel.text = data.name ?? ""
              self.cardDecriptionLabel.text = data.description ?? ""
              
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
