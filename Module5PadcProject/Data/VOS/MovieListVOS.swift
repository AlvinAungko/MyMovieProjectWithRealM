//
//  ComingSoonMovieVOS.swift
//  Module5PadcProject
//
//  Created by Alvin  on 20/04/2022.
//


import Foundation
import RealmSwift

struct MovieList: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Movie]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Result
struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func toMovieObject(realM:Realm,contentObject:ContentTypeObject) -> MovieObject
    {
        let movieObject = MovieObject()
        
        movieObject.adult = adult ?? false
        movieObject.backdropPath = backdropPath ?? ""
        movieObject.genreIDS = String()
        movieObject.id = id ?? 0
        movieObject.originalLanguage = originalLanguage ?? ""
        movieObject.originalTitle = originalTitle ?? ""
        movieObject.overview = overview ?? ""
        movieObject.popularity = popularity ?? 0.0
        movieObject.posterPath = posterPath ?? ""
        movieObject.releaseDate = releaseDate ?? ""
        movieObject.title = title ?? ""
        movieObject.video = video ?? false
        movieObject.voteAverage = voteAverage ?? 0.0
        movieObject.voteCount = voteCount ?? 0
        movieObject.contentObject = contentObject
        
       return movieObject
        
    }
}
    
enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
}



