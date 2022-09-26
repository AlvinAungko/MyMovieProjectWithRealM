//
//  CardResponseVOS.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

struct CardRepsonse:Codable
{
    let code:Int?
    let message:String?
    let data:Array<CardDetailForCardResponse>?
    
    enum CodingKeys:String,CodingKey
    {
        case code,message,data
    }
    
}

struct CardDetailForCardResponse:Codable,Equatable
{
    let id:Int?
    let cardHolder:String?
    let cardNumber:String?
    let expirationDate:String?
    let cardType:String?
    
    enum CodingKeys:String,CodingKey
    {
        case id
        case cardHolder = "card_holder"
        case cardNumber = "card_number"
        case expirationDate = "expiration_date"
        case cardType = "card_type"
    }
    
    func toCardObject() -> CardObject
    {
        let cardObject = CardObject()
        
        cardObject.id = id ?? 0
        cardObject.cardHolder = cardHolder ?? ""
        cardObject.cardNumber = cardNumber ?? ""
        cardObject.expirationDate = expirationDate ?? ""
        cardObject.cardType = cardType ?? ""
        
       return cardObject
    }
    
}
