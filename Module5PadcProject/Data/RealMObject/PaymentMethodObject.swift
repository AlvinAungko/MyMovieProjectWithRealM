//
//  PaymentMethodObject.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

class PaymentObject:Object
{
    @Persisted(primaryKey: true)
    var id:Int
    
    @Persisted
    var name:String?
    
    @Persisted
    var paymentCardDescription:String?
    
    func toPaymentCard() -> PaymentCard
    {
        return PaymentCard(id: id, name: name ?? "", description: paymentCardDescription ?? "")
    }
}
