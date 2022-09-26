//
//  CardRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 23/04/2022.
//

import Foundation
import RealmSwift

protocol CardRepo
{
    func save(data:Array<CardDetailForCardResponse>)
    
    func get(completion:@escaping(CompletionHandler<Array<CardDetailForCardResponse>>)->Void)
}

class CardRepoImpl:BaseRealM
{
    static let shared = CardRepoImpl()
    
    private override init() {
        super.init()
    }
}

extension CardRepoImpl:CardRepo
{
    func save(data: Array<CardDetailForCardResponse>)
    {
        
       let listOfCards = data.map {
            $0.toCardObject()
        }
        do {
            try realM.write {
                realM.add(listOfCards, update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func get(completion: @escaping (CompletionHandler<Array<CardDetailForCardResponse>>) -> Void)
    {
        let listOfCards = realM.objects(CardObject.self)
        completion(.success(listOfCards.map({
            $0.toCardDetail()
        })))
        
    }
    
    
}
