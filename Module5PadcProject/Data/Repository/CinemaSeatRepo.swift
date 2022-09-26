//
//  CinemaSeatRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

protocol CinemaSeatRepo
{
    func save(data:Array<CinemaSeat>)
    
//    func saveTotalSeats(data:[Array<CinemaSeat>])
    
    func getSeats(completion:@escaping(CompletionHandler<Array<CustomCinemaSeat>>)->Void)
}

class CinemaSeatRepoImpl:BaseRealM
{
    static let shared = CinemaSeatRepoImpl()
    
    private override init() {
        super.init()
    }
}

extension CinemaSeatRepoImpl:CinemaSeatRepo
{
//    func saveTotalSeats(data: [Array<CinemaSeat>])
//    {
//
//    }
    
    func save(data: Array<CinemaSeat>)
    {
        let listOfCustomSuperSeats = data.map { $0.tocustomSuperSeat()
        }
        
        let listOfCinemaObjects = listOfCustomSuperSeats.map {
            $0.toCinemaSeatObject()
        }
        
        do {
          try realM.write {
              realM.add(listOfCinemaObjects, update: .modified)
          }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func getSeats(completion: @escaping (CompletionHandler<Array<CustomCinemaSeat>>) -> Void)
    {
        let listOfCinemaSeats = realM.objects(CinemaSeatPlanObject.self).sorted(byKeyPath: "symbol", ascending: true)
        
        let listOfCustomCinemaSeats:Array<CustomCinemaSeat> = listOfCinemaSeats.compactMap({  $0.toCinemaSeat()
        })
           
        completion(.success(listOfCustomCinemaSeats))
        
    }
    
    
}
