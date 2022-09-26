//
//  CinemaSeatPlanObject.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift
import SwiftUI

class CinemaSeatPlanObject:Object
{
    @Persisted(primaryKey: true)
    var id:String
    
    @Persisted
    var type:String?
    
    @Persisted
    var seatName:String?
    
    @Persisted
    var symbol:String?
    
    @Persisted
    var price:Int?
    
    func toCinemaSeat() -> CustomCinemaSeat
    {
        return CustomCinemaSeat(id: 0, type: type ?? "", seatName: seatName ?? "", symbol: symbol ?? "", price: price ?? 0)
    }
    
   
}


