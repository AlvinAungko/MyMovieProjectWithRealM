//
//  VisaCardGeminiCollectionViewCell.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 19/02/2022.
//

import UIKit
import Gemini

class VisaCardGeminiCollectionViewCell: GeminiCell
{
    
    @IBOutlet weak var viewOfCard: UIView!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var cardHolderNameLabel: UILabel!
    @IBOutlet weak var cardIDLabel: UILabel!
    
    var customCard:CardDetailForCardResponse?
    var onTabCard:(Int)->Void = {_ in}
    
    {
      didSet
        {
          if let data = customCard
        {
              self.expireDateLabel.text = data.expirationDate ?? ""
              self.cardHolderNameLabel.text = data.cardHolder ?? ""
              let lastFourDigits = data.cardNumber ?? "123456"
              self.cardIDLabel.text = String(lastFourDigits.suffix(4))
//              print(last4)
        }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addGesture()
    }

}

extension VisaCardGeminiCollectionViewCell
{
    func addGesture()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(onTabCell))
        self.viewOfCard.isUserInteractionEnabled = true
        self.viewOfCard.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func onTabCell()
    {
        debugPrint("\(customCard?.id ?? 0) >> cardID")
        onTabCard(customCard?.id ?? 0)
    }
}
