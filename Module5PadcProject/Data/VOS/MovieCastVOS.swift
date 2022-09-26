//
//  MovieCastVOS.swift
//  Module5PadcProject
//
//  Created by Alvin  on 20/04/2022.
//

import Foundation
import RealmSwift

struct MovieCasts: Codable {
    let id: Int?
    let cast, crew: [Cast]?
}

// MARK: - Cast
struct Cast: Codable
{
    let adult: Bool?
    let gender, id: Int?
    let knownForDepartment, name, originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character, creditID: String?
    let order: Int?
    let department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    func toActorObject(realM:Realm,movieObject:MovieObject)-> ActorObject
    {
        let actorObject = ActorObject()
        
        actorObject.adult = adult ?? false
        actorObject.gender = gender ?? 0
        actorObject.id = id ?? 0
        actorObject.knownForDepartment = knownForDepartment ?? ""
        actorObject.name = name ?? ""
        actorObject.originalName = originalName ?? ""
        actorObject.popularity = popularity ?? 0.0
        actorObject.profilePath = profilePath ?? ""
        actorObject.castID = castID ?? Int()
        actorObject.character = character ?? String()
        actorObject.creditID = creditID ?? String()
        actorObject.order = order ?? Int()
        actorObject.department = department ?? ""
        actorObject.job = job ?? ""
        actorObject.movie = movieObject
        
        return actorObject
    }
    
}
