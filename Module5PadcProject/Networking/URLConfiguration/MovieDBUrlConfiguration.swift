//
//  MovieDBUrlConfiguration.swift
//  Module5PadcProject
//
//  Created by Alvin  on 20/04/2022.
//

import Foundation
import Alamofire

enum MDBEndpoint:URLConvertible
{
    func asURL() throws -> URL
    {
        return url
    }
    
    //MARK: Setting up the possibilities of endPoints
    
    case comingSoonMovies
    case genreList
    case nowPlayingMovies
    case movieDetail(_movieID:Int)
    case movieCredits(_movieID:Int)
    
    //MARK: Setting up a scheme and host
    
    var baseUrl:String
    {
        return EasyConstants.baseUrlForMDB
    }
    
    //MARK: Setting up apiPath
    
    var apiPath:String
    {
        switch self
        {
        case.comingSoonMovies:
            return "/movie/upcoming"
        case.genreList:
            return "/genre/movie/list"
        case.nowPlayingMovies:
            return "/movie/now_playing"
        case.movieCredits(let movieID):
            return "/movie/\(movieID)/credits"
        case.movieDetail(let movieID):
            return "/movie/\(movieID)"
        }
    }
    
    //MARK: Create a complete URL
    
    var url:URL
    {
        let urlComponents = NSURLComponents(string: EasyConstants.baseUrlForMDB.appending(apiPath))
        
        if(urlComponents?.queryItems == nil)
        {
            urlComponents?.queryItems = []
        }
        
        urlComponents?.queryItems?.append(URLQueryItem(name: "api_key", value: EasyConstants.apiKey))
        
        return (urlComponents?.url)!
        
    }
    
    
    
    
}
