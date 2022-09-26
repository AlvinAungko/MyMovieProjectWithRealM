//
//  UserProfileRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 04/05/2022.
//

import Foundation
import RealmSwift

protocol ProfileRepoProtocol
{
    func save(data:Account)
    
    func getTheUserCards(userID:Int,completion:@escaping(CompletionHandler<Account>)->Void)
}

class ProfileRepoImpl:BaseRealM
{
    private override init() {
        super.init()
    }
    static let shared = ProfileRepoImpl()
}

extension ProfileRepoImpl:ProfileRepoProtocol
{
    func save(data: Account)
    {
        let userProfile = data.toUserProfileObject(realM: realM)
        
        do {
            try realM.write {
                 realM.add(userProfile, update: .modified)
             }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func getTheUserCards(userID: Int, completion: @escaping (CompletionHandler<Account>) -> Void)
    {
        debugPrint("user id >> \(userID)")
        guard let userProfile = realM.object(ofType: UserProfileObject.self, forPrimaryKey: userID) else {
            debugPrint("No id for user")
            return}
        completion(.success(userProfile.toAccount()))
    }
    

}
