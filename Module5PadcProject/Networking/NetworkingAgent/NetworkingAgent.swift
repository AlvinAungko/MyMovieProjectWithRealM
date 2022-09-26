//
//  NetworkingAgent.swift
//  Module5PadcProject
//
//  Created by Alvin  on 20/04/2022.
//

import Foundation
import Alamofire
import SwiftUI

struct LoginWithGoogleCredentials:Codable
{
    let token:String?
    
    enum CodingKeys:String,CodingKey
    {
        case token = "access-token"
    }
}

struct RandomSnacks:Equatable
{
    let id:Int?
    let quantity:Int?
    
    func toSnackNetwork() -> SnacksForCheckoutCredentials
    {
      return SnacksForCheckoutCredentials(id: id ?? 0, quantity: quantity ?? 0)
    }
}

protocol NetworkPrototcol
{
    
    //MARK:PADCNetworkCall
    
    func loginWithGoogle(token:String,completion:@escaping(CompletionHandler<RegisterResponse>)->Void)
    
    
    func login(email:String,password:String,completion:@escaping(CompletionHandler<RegisterResponse>)->Void)
    
    func register(name:String,email:String,phone:String,password:String,facebookToken:String,googleToken:String,completion:@escaping(CompletionHandler<RegisterResponse>)->Void)
    
    func fetchSnacksFromPadcEndPoint(completion:@escaping(CompletionHandler<Array<Snack>>)->Void)
    
    func fetchThePaymentCardsFromPADCEndPoint(completion:@escaping(CompletionHandler<Array<PaymentCard>>)->Void)
    
    func fetchTheCinemaSeatsFromPADCEndpoint(timeslotID:Int,bookingDate:String,completion:@escaping(CompletionHandler<[Array<CinemaSeat>]>)->Void)
    
    func fetchTheCinemaTimeSlots(bookingDate:String,completion:@escaping(CompletionHandler<Array<CinemaTimeSlot>>)->Void)
    
    func createCard(cardNumber:String,cardHolder:String,expirationDate:String,cvc:String,completion:@escaping(CompletionHandler<Array<CardDetailForCardResponse>>)->Void)
    
    func checkOut(timeslotID:Int,row:String,seatNumber:String,bookingDate:String,totalPrice:Int,movieID:Int,cardID:Int,cinemaID:Int,snacks:[RandomSnacks],completion:@escaping(CompletionHandler<CheckOutResponse>)->Void)
    
    
    func getTheUserProfile(completion:@escaping(CompletionHandler<Account>)->Void)
//    func fetchTheProfile(completion:@escaping(CompletionHandler<RegisterResponse>)->Void)
    
    
    //MARK: MDBNetworkCall
    
    func fetchComingSoonMovies(completion:@escaping(CompletionHandler<Array<Movie>>)->Void)
    func fetchNowPlayingMovies(completion:@escaping(CompletionHandler<Array<Movie>>)->Void)
    func fetchTheMovieDetail(movieID:Int,completion:@escaping(CompletionHandler<MovieDetail>)->Void)
    func fetchTheMovieCredits(movieID:Int,completion:@escaping(CompletionHandler<Array<Cast>>)->Void)
    
    func fetchTheProfile(completion:@escaping(CompletionHandler<Array<CardDetailForCardResponse>>)->Void)
    
}

struct NetworkingAgent
{
    static let shared = NetworkingAgent()
    
    private init(){}
}

extension NetworkingAgent:NetworkPrototcol
{
    func getTheUserProfile(completion: @escaping (CompletionHandler<Account>) -> Void)
    {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "token") else {return}
        let bearerToken = "\(token)"
        let requestHeaderFieldForBearerToken:HTTPHeaders = [.authorization(bearerToken: bearerToken)]
        AF.request(PADCEndpointConvertible.profile, headers: requestHeaderFieldForBearerToken).responseDecodable(of:RegisterResponse.self){
            switch $0.result
            {
            case.success(let registerResponse):
                completion(.success(registerResponse.data!))
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
        
    }
    
    func fetchTheProfile(completion:@escaping (CompletionHandler<Array<CardDetailForCardResponse>>)->Void)
    {
        let userDefaults = UserDefaults.standard
        guard let token = userDefaults.string(forKey: "token") else {return}
        let bearerToken = "\(token)"
        let requestHeaderFieldForBearerToken:HTTPHeaders = [.authorization(bearerToken: bearerToken)]
        
        AF.request(PADCEndpointConvertible.profile, headers: requestHeaderFieldForBearerToken).responseDecodable(of:RegisterResponse.self){
            switch $0.result
            {
            case.success(let cardResponse):
                completion(.success(cardResponse.data?.cards ?? Array<CardDetailForCardResponse>()))
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
        
    }
    
    
    func loginWithGoogle(token: String, completion: @escaping (CompletionHandler<RegisterResponse>) -> Void)
    {
        let googleCredentials = LoginWithGoogleCredentials(token: token)
        
        AF.request(PADCEndpointConvertible.googleLogin, method: .post, parameters: googleCredentials, encoder: JSONParameterEncoder.default).responseDecodable(of:RegisterResponse.self)
        {
            switch $0.result
            {
            case.success(let successResponse):
                completion(.success(successResponse))
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
    }
    
    func checkOut(timeslotID: Int, row: String, seatNumber: String, bookingDate: String, totalPrice: Int, movieID: Int, cardID: Int, cinemaID: Int, snacks: [RandomSnacks], completion: @escaping (CompletionHandler<CheckOutResponse>) -> Void)
    {
        let snackForCheckoutCredentials = snacks.map {
            $0.toSnackNetwork()
        }
        
        let checkOutCredentials = CheckOutCredentials(timeSlotID: timeslotID, row: row, seatNumber: seatNumber, bookingDate: bookingDate, totalPrice: totalPrice, movieID: movieID, cardID: cardID, cinemaID: cinemaID, snacks: snackForCheckoutCredentials)
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "token") else {
            debugPrint("No token at the moment")
            return
        }
        
        let bearerToken = "\(token)"
        let requestHeaderFieldForBearerToken:HTTPHeaders = [.authorization(bearerToken: bearerToken)]
        
        AF.request(PADCEndpointConvertible.checkOut, method: .post, parameters: checkOutCredentials, encoder: JSONParameterEncoder.default, headers: requestHeaderFieldForBearerToken).responseDecodable(of:CheckOutResponse.self)
        {
            switch $0.result
            {
            case.success(let checkoutResponse):
                completion(.success(checkoutResponse))
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
        
    }
    
    func createCard(cardNumber: String, cardHolder: String, expirationDate: String, cvc: String, completion: @escaping (CompletionHandler<Array<CardDetailForCardResponse>>) -> Void)
    {
        let cardCredentials = CardCredentials(cardNumber: cardNumber , cardHolder: cardHolder , expirationDate: expirationDate, cvc: cvc)
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "token") else {
            debugPrint("No token at the moment")
            return
        }
        
        let bearerToken = "\(token)"
        let requestHeaderFieldForBearerToken:HTTPHeaders = [.authorization(bearerToken: bearerToken)]
        
        AF.request(PADCEndpointConvertible.createCard, method: .post, parameters: cardCredentials, encoder: JSONParameterEncoder.default, headers: requestHeaderFieldForBearerToken).responseDecodable(of:CardRepsonse.self)
        {
            switch $0.result
            {
            case.success(let cardResponse):
                let cards = cardResponse.data ?? Array<CardDetailForCardResponse>()
                completion(.success(cards))
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
    }
    
    func fetchTheCinemaTimeSlots(bookingDate: String, completion: @escaping (CompletionHandler<Array<CinemaTimeSlot>>) -> Void)
    {
        
        let defaults = UserDefaults.standard
//        guard let _ = defaults.string(forKey: "token") else {
//            debugPrint("No token at the moment")
//            return
//        }
        guard let token = defaults.string(forKey:"token") else {
            return
        }
        let bearerToken = "\(token)"
        let requestHeaderFieldForBearerToken:HTTPHeaders = [.authorization(bearerToken: bearerToken)]
        
        AF.request(PADCEndpointConvertible.cinemaDayTimeSlots(_bookingDate: bookingDate),headers: requestHeaderFieldForBearerToken).responseDecodable(of:CinemTimeSlots.self){
            switch $0.result
            {
            case.success(let timeSlots):
                completion(.success(timeSlots.data ?? Array<CinemaTimeSlot>()))
                debugPrint("Success is called.")
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage.localizedDescription))
                debugPrint("failure is called")
            }
        }
    }
    
    func fetchTheCinemaSeatsFromPADCEndpoint(timeslotID: Int, bookingDate: String, completion: @escaping (CompletionHandler<[Array<CinemaSeat>]>) -> Void)
    {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "token") else {
            debugPrint("No token at the moment")
            return
        }
        
        let bearerToken = "\(token)"
        let requestHeaderFieldForBearerToken:HTTPHeaders = [.authorization(bearerToken: bearerToken)]
        
        AF.request(PADCEndpointConvertible.cinemaSeats(_timeslotID: timeslotID, _bookingDate: bookingDate),headers: requestHeaderFieldForBearerToken).responseDecodable(of:CinemaSeats.self)
        {
            switch $0.result
            {
            case.success(let cinemaSeats):
                completion(.success(cinemaSeats.data!))
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
    }
    
    func fetchThePaymentCardsFromPADCEndPoint(completion: @escaping (CompletionHandler<Array<PaymentCard>>) -> Void)
    {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "token") else {
            debugPrint("No token at the moment.")
            return
        }
        let bearerToken = "\(token)"
        
        let requestHeaderFieldForBearerToken:HTTPHeaders = [.authorization(bearerToken: bearerToken)]
        
        AF.request(PADCEndpointConvertible.getPaymentMethod,headers: requestHeaderFieldForBearerToken).responseDecodable(of:PaymentCards.self)
        {
            switch $0.result
            {
            case.success(let paymentCards):
                completion(.success(paymentCards.data ?? Array<PaymentCard>()))
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
    }
    
    func fetchSnacksFromPadcEndPoint(completion: @escaping (CompletionHandler<Array<Snack>>) -> Void)
    {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "token") else
        {
            debugPrint("No token")
            return
        }
        let bearerToken = "\(token)"
        
        let headerForBearToken:HTTPHeaders = [.authorization(bearerToken: bearerToken)]
        
        AF.request(PADCEndpointConvertible.getSnacks,headers: headerForBearToken).responseDecodable(of:Snacks.self)
        {
            switch $0.result
            {
            case.success(let snack):completion(.success(snack.data ?? Array<Snack>()))
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
        
    }
    
    func register(name: String, email: String, phone: String, password: String, facebookToken: String, googleToken: String, completion: @escaping (CompletionHandler<RegisterResponse>) -> Void)
    {
        let registerCredentials = RegisterCredentials(name: name, email: email, phone: phone, password: password, facebookToken: facebookToken, googleToken: googleToken)
        
        AF.request(PADCEndpointConvertible.register, method: .post, parameters: registerCredentials, encoder: JSONParameterEncoder.default).responseDecodable(of:RegisterResponse.self)
        {
            switch $0.result
            {
            case.success(let registerReponse):
                completion(.success(registerReponse))
                
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
        
        
    }
    
    func login(email:String,password:String,completion: @escaping (CompletionHandler<RegisterResponse>) -> Void)
    {
        let loginCredentials = LoginCredentials(email: email, password: password)
        
        AF.request(PADCEndpointConvertible.login, method: .post, parameters: loginCredentials, encoder: JSONParameterEncoder.default).responseDecodable(of:RegisterResponse.self)
        {
            
            switch $0.result
            {
            case.success(let response):completion(.success(response))
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
        
    }
    
    func fetchTheMovieCredits(movieID: Int, completion: @escaping (CompletionHandler<Array<Cast>>) -> Void) {
        
        AF.request(MDBEndpoint.movieCredits(_movieID: movieID)).responseDecodable(of:MovieCasts.self){
            switch $0.result
            {
            case.success(let casts):
                let listOfCasts = casts.cast ?? Array<Cast>()
                completion(.success(listOfCasts))
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
        
    }
    
    func fetchNowPlayingMovies(completion: @escaping (CompletionHandler<Array<Movie>>) -> Void) {
        
        AF.request(MDBEndpoint.nowPlayingMovies).responseDecodable(of:MovieList.self)
        {
            switch $0.result
            {
            case.success(let movieList):
                let movies = movieList.results
                completion(.success(movies ?? Array<Movie>()))
                
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
    }
    
    func fetchTheMovieDetail(movieID: Int, completion: @escaping (CompletionHandler<MovieDetail>) -> Void) {
        
        AF.request(MDBEndpoint.movieDetail(_movieID: movieID)).responseDecodable(of:MovieDetail.self)
        {
            switch $0.result
            {
            case.success(let movieDetail):completion(.success(movieDetail))
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
        
    }
    
    
    func fetchComingSoonMovies(completion: @escaping (CompletionHandler<Array<Movie>>) -> Void) {
        AF.request(MDBEndpoint.comingSoonMovies).responseDecodable(of:MovieList.self)
        {
            switch $0.result
            {
            case.success(let movieList):
                let movies = movieList.results ?? Array<Movie>()
                completion(.success(movies))
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage.localizedDescription))
            }
        }
    }
    
}

enum CompletionHandler<T>
{
    case success(T)
    case failure(_errorMessage:String)
}
