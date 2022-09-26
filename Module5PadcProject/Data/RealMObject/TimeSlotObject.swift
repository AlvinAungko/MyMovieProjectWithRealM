//
//  TimeSlotObject.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

class TimeSlotObject:Object
{
    @Persisted(primaryKey:true)
    var dayTimeSlotID:Int
    
    @Persisted
    var startTime:String
    
    @Persisted
    var cinema:CinemaDayObject?
    
    func toTimeSlot() -> TimeSlot
    {
        return TimeSlot(cinemaDayTimeSlotID: dayTimeSlotID, startTime: startTime)
    }
}
