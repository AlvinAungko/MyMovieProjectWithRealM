//
//  CinemaDaySlotRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 22/04/2022.
//

import Foundation
import RealmSwift

protocol CinemadaySlotRepo
{
    func saveCinemaDaySlot(data:Array<CinemaTimeSlot>)
    
}

class CinemaDaySlotRepoImpl:BaseRealM
{
    static let shared = CinemaDaySlotRepoImpl()
    
    var idByCinema = Dictionary<Int,CinemaDayObject>()
    let timeslotShared = TimeSlotRepoImpl.shared
    
    private override init() {
        super.init()
    }
    
}

extension CinemaDaySlotRepoImpl:CinemadaySlotRepo
{
    func saveCinemaDaySlot(data: Array<CinemaTimeSlot>)
    {
        let listOfCinemas = data.map {
            $0.toCinemaDayObject(realM: realM)
        }
        
        do {
           try realM.write {
                realM.add(listOfCinemas, update: .modified)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getCinemaDaySlots(completion:@escaping(CompletionHandler<Array<CinemaTimeSlot>>)->Void)
    {
        let listOfCinemaDaySlots = realM.objects(CinemaDayObject.self).sorted(byKeyPath: "cinemaID", ascending: true)
        
        completion(.success(listOfCinemaDaySlots.map({
            $0.toCinemaTimeSlot()
        })))
        
    }
    
    
    
}
