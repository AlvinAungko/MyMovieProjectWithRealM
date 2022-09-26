//
//  SnackObject.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

class SnackObject:Object
{
    @Persisted(primaryKey: true)
    var id:Int
    
    @Persisted
    var name:String?
    
    @Persisted
    var snackDescription:String?
    
    @Persisted
    var price:Int?
    
    @Persisted
    var image:String?
    
    func toSnack() -> Snack
    {
        return Snack(id: id, name: name ?? "", description: snackDescription ?? "", price: price ?? 0, image: image ?? "")
    }
}
