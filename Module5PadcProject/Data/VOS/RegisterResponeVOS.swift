//
//  RegisterResponeVOS.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 21/04/2022.
//

import Foundation
import RealmSwift

struct RegisterResponse:Codable
{
    let code:Int?
    let message:String?
    let data:Account?
    let token:String?
}

struct Account:Codable
{
    let id:Int?
    let name:String?
    let cards:Array<CardDetailForCardResponse>?
    let email:String?
    let phoneNumber:String?
    let totalExpense:Int?
    let profileImage:String?
    
    enum CodingKeys:String,CodingKey
    {
        case id,name,email
        case cards
        case phoneNumber = "phone"
        case totalExpense = "total_expense"
        case profileImage = "profile_image"
    }
    
    func toUserProfileObject(realM:Realm)->UserProfileObject
    {
        let userProfileObj = UserProfileObject()
        
        userProfileObj.id = id ?? 0
        userProfileObj.name = name ?? ""
        userProfileObj.email = email ?? ""
        userProfileObj.phoneNumber = phoneNumber ?? ""
        userProfileObj.totalExpense = totalExpense ?? 0
        userProfileObj.profileImage = profileImage ?? ""
        
        userProfileObj.cards.append(objectsIn: (cards?.map({
            $0.toCardObject()
        }))!)
        
        do {
            
            try realM.write {
                 realM.add(userProfileObj.cards, update: .modified)
             }
            
        } catch {
            debugPrint(error.localizedDescription)
        }
        
       
        
        return userProfileObj
    }
}
