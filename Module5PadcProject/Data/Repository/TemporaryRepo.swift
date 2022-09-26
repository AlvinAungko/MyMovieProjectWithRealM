//
//  TemporaryRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 23/04/2022.
//

import Foundation

protocol TemporaryRepo
{
    func extractTheCinemaByID(cinemaID:Int)->CinemaDayObject?
}

class TemporaryRepoImpl:BaseRealM
{
    var idByCinema = Dictionary<Int,CinemaDayObject>()
    
    static let shared = TemporaryRepoImpl()
    
    private override init() {
        super.init()
    }
}

extension TemporaryRepoImpl:TemporaryRepo
{
    func extractTheCinemaByID(cinemaID:Int)->CinemaDayObject?
    {
        let listOfCinemas = realM.objects(CinemaDayObject.self)
        
        listOfCinemas.forEach {
            idByCinema[$0.cinemaID] = $0
        }
        
        if let cinema = idByCinema[cinemaID]
        {
            return cinema
        } else
        {
            return nil
        }
        
    }
}
