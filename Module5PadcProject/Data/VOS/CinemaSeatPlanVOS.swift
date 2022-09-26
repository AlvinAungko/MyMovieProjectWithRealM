//
//  CinemaSeatPlanVOS.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

struct CinemaSeats:Codable
{
    let code:Int?
    let message:String?
    let data:[Array<CinemaSeat>]?
    
    enum CodingKeys:CodingKey
    {
        case code,message,data
    }
    
    func toTotalCinemaSeat() -> TotalCinemaSeatObjects
    {
        let totalSeatObject = TotalCinemaSeatObjects()
        
        return totalSeatObject
    }
    
    
    
}

struct CinemaSeat:Codable
{
    let id:Int?
    let type:String?
    let seatName:String?
    let symbol:String?
    let price:Int?
    
    enum CodingKeys:String,CodingKey
    {
        case id,type,symbol,price
        case seatName = "seat_name"
    }
    
//    func toCinemaSeatObjet(realM:Realm) -> CinemaSeatPlanObject
//    {
//        let cinemaSeatObject = CinemaSeatPlanObject()
//        
//        cinemaSeatObject.id = id ?? 0
//        cinemaSeatObject.type = type ?? ""
//        cinemaSeatObject.seatName = seatName ?? ""
//        cinemaSeatObject.symbol = symbol ?? ""
//        cinemaSeatObject.price = price ?? 0
//        
//        return cinemaSeatObject
//    }
    
    func tocustomSuperSeat() -> CustomSuperSeat
    {
        return CustomSuperSeat(id: id ?? 0, type: type ?? "", seatName: seatName ?? "", symbol: symbol ?? "", price: price ?? 0, uniqueID: "\(symbol ?? "") - \(id ?? 0)")
    }
    
    func isText() -> Bool
    {
        return type == TEXT_SEAT
    }
    
    func isAvailable() -> Bool
    {
        return type == AVAILABLE_SEAT
    }
    
    func isTaken() -> Bool
    {
        return type == TAKEN_SEAT
    }
    
    func isSpace() -> Bool
    {
        return type == SPACE_SEAT
    }
    
    func toCustomCinemaSeat() -> CustomCinemaSeat
    {
        return CustomCinemaSeat(id: id ?? 0, type: type ?? "", seatName: seatName ?? "", symbol: symbol ?? "", price: price ?? 0)
    }
    
}

class CustomCinemaSeat
{
    var id:Int?
    var type:String?
    var seatName:String?
    var symbol:String?
    var price:Int?
    
    init(id:Int,type:String,seatName:String,symbol:String,price:Int)
    {
        self.id = id
        self.type = type
        self.seatName = seatName
        self.symbol = symbol
        self.price = price
    }
    
    func isText() -> Bool
    {
        return type == TEXT_SEAT
    }
    
    func isAvailable() -> Bool
    {
        return type == AVAILABLE_SEAT
    }
    
    func isTaken() -> Bool
    {
        return type == TAKEN_SEAT
    }
    
    func isSpace() -> Bool
    {
        return type == SPACE_SEAT
    }
    
    func isReserved() -> Bool
    {
        return type == SEAT_TYPE_RESERVE
    }
}
