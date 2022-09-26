//
//  CinemaDayObject.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

class CinemaDayObject:Object
{
    @Persisted(primaryKey: true)
    var cinemaID:Int
    
    @Persisted
    var cinema:String?
    
    @Persisted
    var slots:List<TimeSlotObject>
    
    @Persisted(originProperty: "cinema")
    var timeslots:LinkingObjects<TimeSlotObject>
    
    func toCinemaTimeSlot() -> CinemaTimeSlot
    {
        return CinemaTimeSlot(cinemaID: cinemaID, cinema: cinema, timeSlots: slots.map({
            $0.toTimeSlot()
        }))
    }
}
