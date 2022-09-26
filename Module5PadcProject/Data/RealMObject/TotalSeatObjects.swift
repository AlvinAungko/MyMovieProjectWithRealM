//
//  TotalSeatObjects.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 30/04/2022.
//

import Foundation
import RealmSwift

class TotalCinemaSeatObjects:Object
{
    @Persisted(primaryKey: true)
    var id:Int
    
    @Persisted
    var seatPlans:List<CinemaSeatPlanObject>
}
