//
//  PaymentCardVOS.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

struct PaymentCards:Codable
{
    let code:Int?
    let message:String?
    let data:Array<PaymentCard>?
    
    enum CodingKeys:CodingKey
    {
        case code,message,data
    }
}

struct PaymentCard:Codable
{
    let id:Int?
    let name:String?
    let description:String?
    
    enum CodingKeys:CodingKey
    {
        case id,name,description
    }
    
    func toPaymentObject() -> PaymentObject
    {
        let paymentCardObject = PaymentObject()
        
        paymentCardObject.id = id ?? 0
        paymentCardObject.name = name ?? ""
        paymentCardObject.paymentCardDescription = description ?? ""
        
        return paymentCardObject
        
    }
    
}
