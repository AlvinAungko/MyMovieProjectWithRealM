//
//  PADCEndpointConfiguration.swift
//  Module5PadcProject
//
//  Created by Alvin  on 20/04/2022.
//

import Foundation
import Alamofire

enum PADCEndpointConvertible:URLConvertible
{
    
    //MARK: list of endpoint possibilities
    
    case cinemas
    case movies
    case movieDetail(_movieID:Int)
    case login
    case register
    case getSnacks
    case getPaymentMethod
    case createCard
    case checkOut
    case cinemaSeats(_timeslotID:Int,_bookingDate:String)
    case cinemaDayTimeSlots(_bookingDate:String)
    case googleLogin
    case profile
    //MARK: Specify a scheme and host
    
    var baseUrl:String
    {
        return EasyConstants.padcURL
    }
    
    //MARK: Specify API Path
    
    var apiPath:String
    {
        switch self
        {
        case .cinemas:
            return "/api/v1/cinemas"
        case .movies:
            return "/api/v1/movies"
        case .movieDetail(let movieID):
            return "/api/v1/movies/\(movieID)"
        case .login:
            return "/api/v1/email-login"
        case .register:
            return "/api/v1/register"
        case .getSnacks:
            return "/api/v1/snacks"
        case .getPaymentMethod:
            return "/api/v1/payment-methods"
        case .createCard:
            return "/api/v1/card"
        case .checkOut:
            return "/api/v1/checkout"
        case .cinemaSeats(let timeSlotID,let bookingDate):
            return "/api/v1/seat-plan?cinema_day_timeslot_id=\(timeSlotID)&booking_date=\(bookingDate)"
        case .cinemaDayTimeSlots(let bookingDate):
            return "/api/v1/cinema-day-timeslots?date=\(bookingDate)"
        case .googleLogin:
            return "/api/v1/google-login"
        case .profile:
            return "/api/v1/profile"
        }
    }
    
    //MARK: Create a complete URLEndpointForPADC
    
    var url:URL
    {
        let urlComponents = NSURLComponents(string: baseUrl.appending(apiPath))
        
        return (urlComponents?.url)!
    }
    
    func asURL() throws -> URL
    {
        return url
    }
    
    
}

