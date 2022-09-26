//
//  SnackRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

protocol SnackRepo
{
    func saveSnacks(snacks:Array<Snack>)
    
    func getSnacks(completion:@escaping(CompletionHandler<Array<Snack>>)->Void)
}

class SnackRepoImpl:BaseRealM
{
    static let shared = SnackRepoImpl()
    
    private override init() {
        super.init()
    }
}

extension SnackRepoImpl:SnackRepo
{
    func saveSnacks(snacks: Array<Snack>)
    {
        let listOfSnacks = snacks.map {
            $0.toSnackObject()
        }
        
        do {
            try realM.write {
                realM.add(listOfSnacks, update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getSnacks(completion: @escaping (CompletionHandler<Array<Snack>>) -> Void)
    {
        let listOfSnacks = realM.objects(SnackObject.self)
        completion(.success(listOfSnacks.map({ $0.toSnack()
        })))
    }
    
}
