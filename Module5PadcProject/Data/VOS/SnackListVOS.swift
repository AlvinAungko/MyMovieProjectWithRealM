//
//  SnackListVOS.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

struct Snacks:Codable
{
    let code:Int?
    let message:String?
    let data:Array<Snack>?
    
    enum CodingKeys:CodingKey
    {
        case code,message,data
    }
}

struct Snack:Codable
{
    let id:Int?
    let name:String?
    let description:String?
    let price:Int?
    let image:String?
    
    enum CodingKeys:CodingKey
    {
        case id,name,description,price,image
    }
    
    func toSnackObject() -> SnackObject
    {
        let snackObject = SnackObject()
        
        snackObject.id = id ?? 0
        snackObject.name = name ?? ""
        snackObject.snackDescription = description ?? ""
        snackObject.price = price ?? 0
        snackObject.image = image ?? ""
        
       return snackObject
        
    }
    
}
