//
//  MovieModelLayer.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 21/04/2022.
//

import Foundation

protocol MovieModelLayeProtocol
{
    func fetchComingSoonMovies(completion:@escaping(CompletionHandler<Array<Movie>>)->Void)
    func fetchNowPlayingMovies(completion:@escaping(CompletionHandler<Array<Movie>>)->Void)
    func fetchTheMovieDetail(movieID:Int,completion:@escaping(CompletionHandler<MovieDetail>)->Void)
    
    func fetchTheMovieCredits(movieID:Int,completion:@escaping(CompletionHandler<Array<Cast>>)->Void)
}

class MovieModelLayer
{
    static let shared = MovieModelLayer()
    let networkingAgent = NetworkingAgent.shared
    let movieRepo = MovieRepositoryImpl.shared
    let contentRepo = ContentRepoImpl.contentShared
    let actorRepo = ActorRepoImpl.shared
}

extension MovieModelLayer:MovieModelLayeProtocol
{
    
    func fetchComingSoonMovies(completion: @escaping (CompletionHandler<Array<Movie>>) -> Void) {
        networkingAgent.fetchComingSoonMovies {
            switch $0
            {
            case.success(let listOfMovies):
                
                self.movieRepo.saveMovies(data: listOfMovies, contentType: self.contentRepo.extractTheContentTypeObject(name: ContentTypeMap.comingSoonMovie.rawValue)!)
                
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
            }
            
            self.contentRepo.getMovies(name: ContentTypeMap.comingSoonMovie.rawValue) {
                completion(.success($0))
            }
        }
    }
    
    func fetchNowPlayingMovies(completion: @escaping (CompletionHandler<Array<Movie>>) -> Void)
    {
        networkingAgent.fetchNowPlayingMovies {
            switch $0
            {
            case.success(let listOfMovies):
                
                self.movieRepo.saveMovies(data: listOfMovies, contentType: self.contentRepo.extractTheContentTypeObject(name: ContentTypeMap.nowShowingMovie.rawValue)!)
                
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
            }
            
            self.contentRepo.getMovies(name: ContentTypeMap.nowShowingMovie.rawValue) {
                completion(.success($0))
            }
        }
    }
    
    func fetchTheMovieDetail(movieID: Int, completion: @escaping (CompletionHandler<MovieDetail>) -> Void)
    {
        networkingAgent.fetchTheMovieDetail(movieID: movieID)
        {
            switch $0
            {
            case.success(let movieDetail):
                
                self.movieRepo.saveMovieDetail(data: movieDetail)
                
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
            }
            
            self.movieRepo.getTheMovieUserTabed(movieID: movieID)
            {
                completion(.success($0))
            }
            
        }
    }
    
    func fetchTheMovieCredits(movieID: Int, completion: @escaping (CompletionHandler<Array<Cast>>) -> Void)
    {
        networkingAgent.fetchTheMovieCredits(movieID: movieID) {
            switch $0
            {
            case.success(let casts):
                
                self.actorRepo.saveActors(data: casts, movieObject: self.movieRepo.extractTheMovieObject(movieID: movieID)!)
                
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
            }
            self.movieRepo.fetchTheCreditsAccordingToTheMovie(movieID: movieID) {
                completion(.success($0))
            }
        }
    }
    
    
}
