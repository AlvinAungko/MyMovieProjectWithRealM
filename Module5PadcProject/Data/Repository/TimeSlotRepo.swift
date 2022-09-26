//
//  TimeSlotRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 23/04/2022.
//

import Foundation
import RealmSwift

protocol TimeSlotRepo
{
    func save(cinemaID:Int,timeSlot:TimeSlot) -> TimeSlotObject?
}

class TimeSlotRepoImpl:BaseRealM
{
    static let shared = TimeSlotRepoImpl()
    let temporaryRepoShared = TemporaryRepoImpl.shared
    
    private override init()
    {
        super.init()
    }
}

extension TimeSlotRepoImpl:TimeSlotRepo
{
    func save(cinemaID: Int, timeSlot: TimeSlot) -> TimeSlotObject?
    {
        guard let cinemaObject = realM.object(ofType: CinemaDayObject.self, forPrimaryKey: cinemaID) else {
            return nil
        }
        
        let timeSlotObject = TimeSlotObject()
        
        timeSlotObject.cinema = cinemaObject
        timeSlotObject.dayTimeSlotID = timeSlot.cinemaDayTimeSlotID ?? 0
        timeSlotObject.startTime = timeSlot.startTime ?? ""
        return timeSlotObject
    }
    
}
