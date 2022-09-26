//
//  ContentTypeObject.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 21/04/2022.
//

import Foundation
import RealmSwift

class ContentTypeObject:Object
{
    @Persisted(primaryKey: true)
    var name:String
    
    @Persisted(originProperty: "contentObject")
    var movies:LinkingObjects<MovieObject>
}
