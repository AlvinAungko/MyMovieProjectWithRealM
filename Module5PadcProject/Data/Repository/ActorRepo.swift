//
//  ActorRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 21/04/2022.
//

import Foundation
import RealmSwift

protocol ActorRepo
{
    func saveActors(data:Array<Cast>,movieObject:MovieObject)
}

class ActorRepoImpl:BaseRealM
{
    static let shared = ActorRepoImpl()
    
    private override init() {
        super.init()
    }
}

extension ActorRepoImpl:ActorRepo
{
    func saveActors(data: Array<Cast>, movieObject: MovieObject)
    {
        let listOfActors = data.map {
            $0.toActorObject(realM: realM, movieObject: movieObject)
        }
        
        do {
            try realM.write {
                realM.add(listOfActors, update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    
}
