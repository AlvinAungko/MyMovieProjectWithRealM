//
//  DayCollectionViewCell.swift
//  Module5PadcProject
//
//  Created by Alvin  on 15/02/2022.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var customDayCalendar:CustomTicketDate?
    {
      didSet
        {
          if let data = customDayCalendar
          {
              self.bindDataToTheDateCell(dateVOS: data)
          }
        }
    }
    
    var dayCalender:DummyDay?
    {
        didSet{
            if let data = dayCalender
            {
                self.bindDataToTheCell(dayVOS: data)
            }
        }
    }
    var onTabDayDate:(String,String)->Void = {_,_ in}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addGesture()
    }

}

extension DayCollectionViewCell
{
    func bindDataToTheDateCell(dateVOS:CustomTicketDate)
    {
        if dateVOS.isSelected == true
        {
            dayLabel.textColor = UIColor.white
            dateLabel.textColor = UIColor.white
        } else
        {
            dayLabel.textColor = UIColor(named: color_reserved)
            dateLabel.textColor = UIColor(named: color_reserved)
        }
        
        dayLabel.text = dateVOS.dayLabel ?? ""
        dateLabel.text = dateVOS.day ?? ""
        
        
    }
    
    func bindDataToTheCell(dayVOS:DummyDay)
    {
        if dayVOS.isSelected == true
        {
            dayLabel.textColor = UIColor.white
            dateLabel.textColor = UIColor.white
        } else
        {
            dayLabel.textColor = UIColor(named: color_reserved)
            dateLabel.textColor = UIColor(named: color_reserved)
        }
        
        dayLabel.text = dayVOS.day
        dateLabel.text = dayVOS.date
    }
}

extension DayCollectionViewCell
{
    private func addGesture()
    {
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(onTabDate))
        dayLabel.isUserInteractionEnabled = true
        dayLabel.addGestureRecognizer(gestureRecog)
    }
    
    @objc func onTabDate()
    {
        onTabDayDate("\(customDayCalendar?.year ?? "")-\(customDayCalendar?.month ?? "")-\(customDayCalendar?.day ?? "")",customDayCalendar?.day ?? "")
    }
}
