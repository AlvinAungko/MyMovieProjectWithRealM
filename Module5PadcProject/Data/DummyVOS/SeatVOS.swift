//
//  DummyMovieSeat.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 16/02/2022.
//

import Foundation


class DummyMovieSeat
{
    var title:String
    var type:String
    
    init(title:String,type:String)
    {
        self.title = title
        self.type = type
    }
    
    func isText()->Bool
    {
        return type == SEAT_TYPE_TEXT
    }
    
    func isEmpty() -> Bool
    {
        return type == SEAT_TYPE_EMPTY
    }
    
    func isAvailable() -> Bool
    {
        return type == SEAT_TYPE_AVAILABLE
    }
    
    func isReserved() -> Bool
    {
        return type == SEAT_TYPE_RESERVE
    }
    
    func isSelected() -> Bool
    {
        return type == SEAT_TYPE_SELECTED
    }
    
   
}
