//
//  PaymentMethodRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

protocol PaymentMethRepo
{
    func save(data:Array<PaymentCard>)
    
    func getPaymentCards(completion:@escaping(Array<PaymentCard>)->Void)
}

class PaymentMethRepoImpl:BaseRealM
{
  static let shared = PaymentMethRepoImpl()
    
    private override init()
    {
        super.init()
    }
}

extension PaymentMethRepoImpl:PaymentMethRepo
{
    func save(data: Array<PaymentCard>)
    {
        let listOfPaymentCards = data.map {
            $0.toPaymentObject()
        }
        
        do {
          try realM.write {
                realM.add(listOfPaymentCards, update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getPaymentCards(completion: @escaping (Array<PaymentCard>) -> Void)
    {
        let listOfPaymentCards = realM.objects(PaymentObject.self)
        completion(listOfPaymentCards.map({
            $0.toPaymentCard()
        }))
    }
    
    
}
