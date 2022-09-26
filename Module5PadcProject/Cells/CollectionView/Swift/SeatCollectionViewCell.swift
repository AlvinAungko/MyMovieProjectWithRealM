//
//  SeatCollectionViewCell.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 16/02/2022.
//

import UIKit

class SeatCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewToCurveTheUpperCorners: UIView!
    
    @IBOutlet weak var seatLabel: UILabel!
    var Seat:DummyMovieSeat?
    {
        didSet
        {
            if let data = Seat
            {
                if data.isAvailable()
                {
                    viewToCurveTheUpperCorners.backgroundColor = UIColor(named: available_color)
                    seatLabel.isHidden = true
                }
                else if data.isReserved()
                {
                    viewToCurveTheUpperCorners.backgroundColor = UIColor(named: color_reserved)
                    seatLabel.isHidden = true
                    viewToCurveTheUpperCorners.isUserInteractionEnabled = false
                }
                else if data.isText()
                {
                    seatLabel.text = data.title
                    viewToCurveTheUpperCorners.backgroundColor = UIColor.clear
                    viewToCurveTheUpperCorners.isUserInteractionEnabled = false
                }
                else if data.isSelected()
                {
                    seatLabel.isHidden = true
                    viewToCurveTheUpperCorners.backgroundColor = UIColor(named: "primary_color")
                }
                
                else
                {
                    seatLabel.text = data.title
                    viewToCurveTheUpperCorners.backgroundColor = UIColor.clear
                    viewToCurveTheUpperCorners.isUserInteractionEnabled = false
                }
                
            }
        }
    }
    
    var customSeat:CustomCinemaSeat?
    {
        didSet
        {
            if let data = customSeat
            {
                if data.isText()
                {
                    seatLabel.text = data.symbol
                    seatLabel.isHidden = false
                    viewToCurveTheUpperCorners.backgroundColor = UIColor.clear
                    viewToCurveTheUpperCorners.isUserInteractionEnabled = false
                    
                } else if data.isAvailable()
                {
                    viewToCurveTheUpperCorners.backgroundColor = UIColor(named: available_color)
                    seatLabel.isHidden = true
                    viewToCurveTheUpperCorners.isUserInteractionEnabled = true
                    
                } else if data.isTaken()
                {
                    seatLabel.isHidden = true
                    viewToCurveTheUpperCorners.backgroundColor = UIColor(named: color_reserved)
                    viewToCurveTheUpperCorners.isUserInteractionEnabled = false
                    
                }
                else if data.isReserved()
                {
                    seatLabel.isHidden = true
                    viewToCurveTheUpperCorners.backgroundColor = UIColor(named: "primary_color")
                    viewToCurveTheUpperCorners.isUserInteractionEnabled = true
                }
                else {
                    seatLabel.text = data.seatName ?? ""
                    viewToCurveTheUpperCorners.backgroundColor = UIColor.clear
                    viewToCurveTheUpperCorners.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    var onTabSeat:(String) -> Void = {_ in }
    
    var onTabCustomSeat:(String,String)->Void = {_,_ in}
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        addGesture()
        curveTheCorners()
    }

}

extension SeatCollectionViewCell
{
    private func curveTheCorners()
    {
        viewToCurveTheUpperCorners.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewToCurveTheUpperCorners.layer.cornerRadius = 7.5
    }
}

extension SeatCollectionViewCell
{
    private func addGesture()
    {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTabMovieSeat))
        viewToCurveTheUpperCorners.addGestureRecognizer(gestureRecognizer)
        viewToCurveTheUpperCorners.isUserInteractionEnabled = true
    }
    
    @objc func onTabMovieSeat()
    {
        onTabCustomSeat(customSeat?.seatName ?? "",customSeat?.type ?? "")
    }
}
