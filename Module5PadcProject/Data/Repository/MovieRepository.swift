//
//  MovieRepository.swift
//  Module5PadcProject
//
//  Created by Alvin  on 20/04/2022.
//

import Foundation
import RealmSwift

protocol MovieRepoProtocol
{
    func saveMovies(data:Array<Movie>,contentType:ContentTypeObject)
    
    func getMovies(comppletion:@escaping(CompletionHandler<Array<Movie>>)->Void)
    
    func saveMovieDetail(data:MovieDetail)
    
    func  getTheMovieUserTabed(movieID:Int,completion:@escaping(MovieDetail)->Void)
    
    func extractTheMovieObject(movieID:Int)->MovieObject?
    
    func fetchTheCreditsAccordingToTheMovie(movieID:Int,completion:@escaping(Array<Cast>)->Void)
    
}


class MovieRepositoryImpl:BaseRealM
{
    
    var movieObjectByID = Dictionary<Int,MovieObject>()
    static let shared = MovieRepositoryImpl()
}

extension MovieRepositoryImpl:MovieRepoProtocol
{
    func saveMovies(data: Array<Movie>,contentType:ContentTypeObject)
    {
        let listOfMovies = data.map {
            $0.toMovieObject(realM: realM, contentObject: contentType)
        }
        do
        {
           try realM.write
            {
                realM.add(listOfMovies, update: .modified)
            }
        } catch
        {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getMovies(comppletion: @escaping (CompletionHandler<Array<Movie>>) -> Void)
    {
        let listOfMovies = realM.objects(MovieObject.self).sorted(byKeyPath: "popularity", ascending: false)
        
        comppletion(.success(listOfMovies.map({
            $0.toMovie()
        })))
    }
    
    func saveMovieDetail(data: MovieDetail)
    {
        data.toMovieObject(realM: realM)
    }
    
    func getTheMovieUserTabed(movieID: Int, completion: @escaping (MovieDetail) -> Void)
    {
        guard let specificMovie = realM.object(ofType: MovieObject.self, forPrimaryKey: movieID) else {
            debugPrint("No Movie Object According to that key is found.")
            return
        }
        completion(specificMovie.toMovieDetail())
    }
    
    func extractTheMovieObject(movieID: Int) -> MovieObject?
    {
        guard let movieObject = realM.object(ofType: MovieObject.self, forPrimaryKey: movieID) else
        {
            return nil
        }
        return movieObject
    }
    
    func fetchTheCreditsAccordingToTheMovie(movieID: Int, completion: @escaping (Array<Cast>) -> Void)
    {
        guard let movieObject = realM.object(ofType: MovieObject.self, forPrimaryKey: movieID) else
        {
            completion(Array<Cast>())
            return
        }
        
        let listOfCredits:Array<Cast> = movieObject.casts.compactMap {
            $0.toCast()
        }
        
        completion(listOfCredits)
    }
    
}
