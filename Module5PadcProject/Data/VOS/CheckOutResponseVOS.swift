//
//  CheckOutResponseVOS.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation

struct CheckOutResponse:Codable
{
    let code:Int?
    let message:String?
    let data:CheckOutList?
    
    enum CodingKeys:CodingKey
    {
        case code,message,data
    }
    
}

struct CheckOutList:Codable
{
    let id:Int?
    let bookingNumber:String?
    let bookingDate:String?
    let row:String?
    let seat:String?
    let totalSeat:Int?
    let total:String?
    let movieID:Int?
    let cinemaID:Int?
    let userName:String?
    let timeSlot:TimeSlotForCheckOut?
    let snacks:Array<SnackForCheckOut>?
    let qrCode:String?
    
    enum CodingKeys:String,CodingKey
    {
        case id
        case bookingNumber = "booking_no"
        case bookingDate = "booking_date"
        case row,seat
        case totalSeat = "total_seat"
        case total
        case movieID = "movie_id"
        case cinemaID = "cinema_id"
        case userName = "username"
        case timeSlot = "timeslot"
        case snacks
        case qrCode = "qr_code"
    }
    
}

struct TimeSlotForCheckOut:Codable
{
    let timeslotID:Int?
    let startTime:String?
    
    enum CodingKeys:String,CodingKey
    {
        case timeslotID = "cinema_day_timeslot_id"
        case startTime = "start_time"
    }
    
}

struct SnackForCheckOut:Codable
{
    let id:Int?
    let name:String?
    let description:String?
    let image:String?
    let price:Int?
    let unitPrice:Int?
    let quantity:Int?
    let totalPrice:Int?
    
    enum CodingKeys:String,CodingKey
    {
        case id,name,description,image,price
        case unitPrice = "unit_price"
        case quantity
        case totalPrice = "total_price"
    }
    
}
