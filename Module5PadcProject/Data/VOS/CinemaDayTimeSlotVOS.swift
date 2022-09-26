//
//  CinemaDayTimeSlotVOS.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

struct CinemTimeSlots:Codable
{
    let code:Int?
    let message:String
    let data:Array<CinemaTimeSlot>?
    
    enum CodingKeys:CodingKey
    {
        case code,message,data
    }
}

struct CinemaTimeSlot:Codable
{
    let cinemaID:Int?
    let cinema:String?
    let timeSlots:Array<TimeSlot>?
    
    enum CodingKeys:String,CodingKey
    {
        case cinemaID = "cinema_id"
        case cinema
        case timeSlots = "timeslots"
    }
    
    func toCinemaDayObject(realM:Realm) -> CinemaDayObject
    {
        let cinemaObject = CinemaDayObject()
        
        cinemaObject.cinemaID = cinemaID ?? 0
        cinemaObject.cinema = cinema ?? ""
        cinemaObject.slots.append(objectsIn: (timeSlots?.map({ $0.toTimeSlotObject()
        }))!)
        
        do {
           try realM.write {
                realM.add(cinemaObject.slots, update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    
        return cinemaObject
    }
    
}

struct TimeSlot:Codable
{
    let cinemaDayTimeSlotID:Int?
    let startTime:String?
    
    enum CodingKeys:String,CodingKey
    {
        case cinemaDayTimeSlotID = "cinema_day_timeslot_id"
        case startTime = "start_time"
    }
    
    func toTimeSlotObject() -> TimeSlotObject
    {
        let timeslotObject = TimeSlotObject()
        timeslotObject.dayTimeSlotID = cinemaDayTimeSlotID ?? 0
        timeslotObject.startTime = startTime ?? ""
        return timeslotObject
    }
    
    func toCustomTimeSlot() -> CustomTimeSlot
    {
        return CustomTimeSlot(timeSlotID: cinemaDayTimeSlotID ?? 0, startTime: startTime ?? "", isSelected: false)
    }
}
