//
//  RatingStarStackView.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 18/02/2022.
//

import UIKit

class RatingStarStackView: UIStackView {
    

    var rating:Int = 3
    
    
    var starSize:CGSize = CGSize(width: 24, height: 24)
    
    
    var starCount:Int = 5
    
    
    var buttonList = Array<UIButton>()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setUpButtons()
        updateButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
        updateButtons()
    }
    
    private func setUpButtons()
    {
       
            
        for _ in 0..<starCount
        {
            let button = UIButton()
            button.widthAnchor.constraint(equalToConstant: self.starSize.width ).isActive = true
            button.heightAnchor.constraint(equalToConstant: self.starSize.height ).isActive = true
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.setImage(UIImage(named: "emptyStar"), for: .normal)
            button.setImage(UIImage(named: "fullStar"), for: .selected)
            
            buttonList.append(button)
            addArrangedSubview(button)
        }
        
       
        
    }
    
    private func updateButtons()
    {
        for (index,value) in buttonList.enumerated()
        {
            if index<rating
            {
                value.isSelected = true
            }
        }
    }
    
    private func emptyTheButtons()
    {
        for button in self.buttonList
        {
            removeArrangedSubview(button)
        }
        
        self.buttonList.removeAll()
    }
    

}
