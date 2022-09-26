//
//  ActorObject.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 21/04/2022.
//

import Foundation
import RealmSwift

class ActorObject:Object
{
    
    @Persisted
    var adult:Bool?
    
    @Persisted
    var gender:Int?
    
    @Persisted(primaryKey: true)
    var id:Int
    
    @Persisted
    var knownForDepartment:String?
    
    @Persisted
    var name:String?
    
    @Persisted
    var originalName:String?
    
    @Persisted
    var popularity:Double?
    
    @Persisted
    var profilePath:String?
    
    @Persisted
    var castID:Int?
    
    @Persisted
    var character:String?
    
    @Persisted
    var creditID:String?
    
    @Persisted
    var order:Int?
    
    @Persisted
    var department:String?
    
    @Persisted
    var job:String?
    
    @Persisted
    var movie:MovieObject?
    
    func toCast() -> Cast
    {
        return Cast(adult: adult ?? false, gender: gender ?? 0, id: id, knownForDepartment: knownForDepartment ?? "", name: name ?? "", originalName: originalName ?? "", popularity: popularity ?? 0.0, profilePath: profilePath ?? "", castID: castID ?? Int(), character: character ?? "", creditID: creditID ?? String(), order: order ?? Int(), department: department ?? String(), job: job ?? String())
    }
    
    
}
