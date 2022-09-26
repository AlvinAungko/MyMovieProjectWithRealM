//
//  ContentTypeRepo.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 21/04/2022.
//

import Foundation
import RealmSwift

protocol ContentRepo
{
    func initDictionary()
    
    func saveToContentRepo()
    
    func extractTheContentTypeObject(name:String) -> ContentTypeObject?
    
    func getMovies(name:String,completion:@escaping(Array<Movie>)->Void)
}

class ContentRepoImpl:BaseRealM
{
    static let contentShared = ContentRepoImpl()
    
    var contentDictionary = Dictionary<String,ContentTypeObject>()
    
    private override init()
    {
        super.init()
        saveToContentRepo()
        initDictionary()
    }
}

extension ContentRepoImpl:ContentRepo
{
    
    func saveToContentRepo()
    {
        ContentTypeMap.allCases.forEach {
            let contentObject = ContentTypeObject()
            
            contentObject.name = $0.rawValue
            
            do {
                try realM.write {
                    realM.add(contentObject, update: .modified)
                }
            } catch
            {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func initDictionary()
    {
        let listOfContentType = realM.objects(ContentTypeObject.self)
        listOfContentType.forEach {
            contentDictionary[$0.name] = $0
        }
    }
    
    func extractTheContentTypeObject(name: String) -> ContentTypeObject?
    {
        if let data = contentDictionary[name]
        {
          return data
        }
        else
        {
          return nil
        }
    }
    
    func getMovies(name:String,completion: @escaping (Array<Movie>) -> Void)
    {
        if let data = contentDictionary[name]
        {
            let mappedMovies = data.movies
            completion(mappedMovies.compactMap({
                $0.toMovie()
            }))
            
        } else
        {
            debugPrint("No content is found")
        }
    }
    
}
