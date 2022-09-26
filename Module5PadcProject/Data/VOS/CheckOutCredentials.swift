//
//  CheckOutCredentials.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation

struct CheckOutCredentials:Codable
{
    let timeSlotID:Int?
    let row:String?
    let seatNumber:String?
    let bookingDate:String?
    let totalPrice:Int?
    let movieID:Int?
    let cardID:Int?
    let cinemaID:Int?
    let snacks:[SnacksForCheckoutCredentials]?
    
    enum CodingKeys:String,CodingKey
    {
        case timeSlotID = "cinema_day_timeslot_id"
        case row
        case seatNumber = "seat_number"
        case bookingDate = "booking_date"
        case totalPrice = "total_price"
        case movieID = "movie_id"
        case cardID = "card_id"
        case cinemaID = "cinema_id"
        case snacks
    }
    
}

struct SnacksForCheckoutCredentials:Codable
{
    let id:Int?
    let quantity:Int?
    
    enum CodingKeys:CodingKey
    {
        case id,quantity
    }
}
