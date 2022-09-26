//
//  MovieObject.swift
//  Module5PadcProject
//
//  Created by Alvin  on 20/04/2022.
//

import Foundation
import RealmSwift

class MovieObject:Object
{
    @Persisted
    var adult:Bool?
    
    @Persisted
    var backdropPath:String?
    
    @Persisted
    var genreIDS:String?
    
    @Persisted(primaryKey: true)
    var id:Int
    
    @Persisted
    var originalLanguage:String?
    
    @Persisted
    var originalTitle:String?
    
    @Persisted
    var overview:String?
    
    @Persisted
    var popularity:Double?
    
    @Persisted
    var posterPath:String?
    
    @Persisted
    var releaseDate:String?
    
    @Persisted
    var title:String?
    
    @Persisted
    var video:Bool?
    
    @Persisted
    var voteAverage:Double?
    
    @Persisted
    var voteCount:Int?
    
    @Persisted
    var contentObject:ContentTypeObject?
    
    @Persisted(originProperty: "movie")
    var casts:LinkingObjects<ActorObject>
    
    func toMovie() -> Movie
    {
        return Movie(adult: adult ?? false, backdropPath: backdropPath ?? "", genreIDS: Array<Int>(), id: id, originalLanguage: originalLanguage ?? "", originalTitle: originalTitle ?? "", overview: overview ?? "", popularity: popularity ?? 0.0, posterPath: posterPath ?? "", releaseDate: releaseDate ?? "", title: title ?? "", video: video ?? false, voteAverage: voteAverage ?? 0.0, voteCount: voteCount ?? 0)
    }
    
    func toMovieDetail() -> MovieDetail
    {
        return MovieDetail(adult: adult ?? false, backdropPath: backdropPath ?? "", budget: Int(), genres: Array<Genre>(), homepage: String(), id: id , imdbID: String(), originalLanguage: originalLanguage ?? "", originalTitle: originalTitle ?? "", overview: overview ?? "", popularity: popularity ?? 0.0, productionCompanies: Array<ProductionCompany>(), productionCountries: Array<ProductionCountry>(), releaseDate: releaseDate ?? "", revenue: Int(), runtime: Int(), spokenLanguages: Array<SpokenLanguage>(), status: String(), tagline: String(), title: title ?? "", video: video ?? false, voteAverage: voteAverage ?? 0.0, voteCount: voteCount ?? 0)
    }

}
