//
//  Constants.swift
//  Module5PadcProject
//
//  Created by Alvin  on 16/02/2022.
//

import Foundation
import RealmSwift

let SEAT_TYPE_TEXT = "Text"
let SEAT_TYPE_EMPTY = "Empty"
let SEAT_TYPE_AVAILABLE = "Available"
let SEAT_TYPE_RESERVE = "Reserved"
let SEAT_TYPE_SELECTED = "Selected"

let primary_color = "primary_color "
let available_color = "available_color"
let color_reserved = "reserved_color"

let LOGIN_SIGNUP_VIEW_CONTROLLER = "LoginAndSignUpViewController"
let MOVIE_VIEW_CONTROLLER = "MovieViewController"
let MOVIE_DETAIL_VIEW_CONTROLLER = "MovieDetailViewController"
let MOVIE_SHOWTIME_VIEW_CONTROLLER = "MovieShowTimeViewController"
let MOVIE_SEAT_VIEW_CONTROLLER = "MovieSeatViewController"
let MOVIE_SNACK_VIEW_CONTROLLER = "SnackSelectionViewController"
let MOVIE_VISA_VIEW_CONTROLLER = "VisaCardPaymentViewController"
let MOVIE_RECEIPT_VIEW_CONTROLLER = "ReceiptViewController"


struct EasyConstants
{
    static let baseUrlForMDB = "https://api.themoviedb.org/3"
    static let padcURL = "https://tmba.padc.com.mm"
    static let apiKey = "23d169995a98a377d09741a13e9f451f"
    static let urlImage = "https://image.tmdb.org/t/p/w500"
    static let urlImageForPadc = "https://tmba.padc.com.mm/img"
}

enum ContentTypeMap:String,CaseIterable
{
   case nowShowingMovie = "NowShowingMovie"
   case comingSoonMovie = "ComingSoonMovie"
}

let TEXT_SEAT = "text"
let AVAILABLE_SEAT = "available"
let TAKEN_SEAT = "taken"
let SPACE_SEAT = "space"
