//
//  RealmBase.swift
//  Module5PadcProject
//
//  Created by Alvin  on 20/04/2022.
//

import Foundation
import RealmSwift

class BaseRealM
{
    let realM = try!Realm()
    
     init()
    {
        debugPrint("RealM Directory is at \(realM.configuration.fileURL?.absoluteString ?? "")")
    }
}
