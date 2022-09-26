//
//  UserProfileObjects.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 04/05/2022.
//

import Foundation
import RealmSwift

class UserProfileObject:Object
{
    @Persisted(primaryKey: true)
    var id:Int
    
    @Persisted
    var name:String?
    
    @Persisted
    var cards:List<CardObject>
    
    @Persisted
    var email:String?
    
    @Persisted
    var phoneNumber:String?
    
    @Persisted
    var totalExpense:Int?
    
    @Persisted
    var profileImage:String?
    
    func toAccount() -> Account
    {
        let listOfCards:Array<CardDetailForCardResponse> = cards.map {
            $0.toCardDetail()
        }
        
        return Account(id: id, name: name ?? "", cards: listOfCards, email: email ?? "", phoneNumber: phoneNumber ?? "", totalExpense: totalExpense ?? 0, profileImage: profileImage ?? "")
    }
}
