//
//  Helper.swift
//  Module5PadcProject
//
//  Created by Alvin  on 28/04/2022.
//

import Foundation
class HelperClass
{
    static var tokenAvailable:Bool
    {
      let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "token")
        {
          return true
        } else {
            return false
        }
    }
}

class uniqueCustomSeat
{
    let id:Int?
    let type:String?
    let seatName:String?
    let symbol:String?
    let price:Int?
    
    init(id:Int,type:String,seatName:String,symbol:String,price:Int)
    {
        self.id = id
        self.type = type
        self.seatName = seatName
        self.symbol = symbol
        self.price = price
    }
    
}

class CustomSuperSeat
{
    var id:Int?
    var type:String?
    var seatName:String?
    var symbol:String?
    var price:Int?
    var uniqueID:String?
    
    init(id:Int,type:String,seatName:String,symbol:String,price:Int,uniqueID:String)
    {
        self.id = id
        self.type = type
        self.seatName = seatName
        self.symbol = symbol
        self.price = price
        self.uniqueID = uniqueID
    }
    
    func toCinemaSeatObject() -> CinemaSeatPlanObject
    {
       let cinemaSeatObject = CinemaSeatPlanObject()
       
        cinemaSeatObject.price = price ?? 0
        cinemaSeatObject.seatName = seatName ?? ""
        cinemaSeatObject.id = uniqueID ?? ""
        cinemaSeatObject.symbol = symbol ?? ""
        cinemaSeatObject.type = type ?? ""
        
        return cinemaSeatObject
    }
    
}

