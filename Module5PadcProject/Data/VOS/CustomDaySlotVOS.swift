//
//  CustomDaySlotVOS.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 28/04/2022.
//

import Foundation

class CustomTimeSlot
{
    let cinemaTimeSlotID:Int?
    let startTime:String?
    var isSelected:Bool?
    
    init(timeSlotID:Int,startTime:String,isSelected:Bool)
    {
        self.cinemaTimeSlotID = timeSlotID
        self.startTime = startTime
        self.isSelected = isSelected
    }
}
