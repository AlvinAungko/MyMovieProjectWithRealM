//
//  CardObject.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

class CardObject:Object
{
    @Persisted(primaryKey: true)
    var id:Int
    
    @Persisted
    var cardHolder:String?
    
    @Persisted
    var cardNumber:String?
    
    @Persisted
    var expirationDate:String?
    
    @Persisted
    var cardType:String?
    
    func toCardDetail() -> CardDetailForCardResponse
    {
        return CardDetailForCardResponse(id: id, cardHolder: cardHolder ?? "", cardNumber: cardNumber ?? "", expirationDate: expirationDate ?? "", cardType: cardType ?? "")
    }
}
