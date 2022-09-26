//
//  CardCredentialsVOS.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation

struct CardCredentials:Codable
{
    let cardNumber:String?
    let cardHolder:String?
    let expirationDate:String?
    let cvc:String
    
    enum CodingKeys:String,CodingKey
    {
        case cardNumber = "card_number"
        case cardHolder = "card_holder"
        case expirationDate = "expiration_date"
        case cvc
    }
}
