//
//  PadcModelLayer.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 21/04/2022.
//

import Foundation

protocol PadcProtocol
{
    func fetchTheCinemaSeatsFromPADCEndpoint(timeslotID:Int,bookingDate:String,completion:@escaping(CompletionHandler<Array<CustomCinemaSeat>>)->Void)
    
    func loginWithGoogle(token:String,completion:@escaping(CompletionHandler<RegisterResponse>)->Void)
    
    func login(email:String,password:String,completion:@escaping(CompletionHandler<RegisterResponse>)->Void)
    
    func register(name:String,email:String,phone:String,password:String,facebookToken:String,googleToken:String,completion:@escaping(CompletionHandler<RegisterResponse>)->Void)
    
    func fetchSnacksFromPadcEndPoint(completion:@escaping(CompletionHandler<Array<Snack>>)->Void)
    
    func fetchThePaymentCardsFromPADCEndPoint(completion:@escaping(CompletionHandler<Array<PaymentCard>>)->Void)
    
    
    func fetchTheCinemaTimeSlots(bookingDate:String,completion:@escaping(CompletionHandler<Array<CinemaTimeSlot>>)->Void)
    
    func createCard(cardNumber:String,cardHolder:String,expirationDate:String,cvc:String,completion:@escaping(CompletionHandler<Array<CardDetailForCardResponse>>)->Void)
    
    func checkOut(timeslotID:Int,row:String,seatNumber:String,bookingDate:String,totalPrice:Int,movieID:Int,cardID:Int,cinemaID:Int,snacks:[RandomSnacks],completion:@escaping(CompletionHandler<CheckOutResponse>)->Void)
    
    func getProfile(completion:@escaping(CompletionHandler<Array<CardDetailForCardResponse>>)->Void)
    
    func fetchProfileAndCards(userID:Int,completion:@escaping(CompletionHandler<Array<CardDetailForCardResponse>>)->Void)
}

class PadcModelLayer
{
    let networkAgent = NetworkingAgent.shared
    let snackRepo = SnackRepoImpl.shared
    let paymentMethodRepo = PaymentMethRepoImpl.shared
    let cinemaSeatRepo = CinemaSeatRepoImpl.shared
    let cinemaTimeSlotRepo = CinemaDaySlotRepoImpl.shared
    let timeSlotRepo = TimeSlotRepoImpl.shared
    let cardRepo = CardRepoImpl.shared
    let userProfileRepo = ProfileRepoImpl.shared
    static let shared = PadcModelLayer()
}

extension PadcModelLayer:PadcProtocol
{
    func fetchProfileAndCards(userID: Int, completion: @escaping (CompletionHandler<Array<CardDetailForCardResponse>>) -> Void)
    {
        networkAgent.getTheUserProfile {
            switch $0
            {
            case.success(let account):
                self.userProfileRepo.save(data: account)
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage))
            }
            self.userProfileRepo.getTheUserCards(userID: userID) {
                switch $0
                {
                case.success(let data):
                    completion(.success(data.cards ?? Array<CardDetailForCardResponse>()))
//                    debugPrint(data.phoneNumber ?? "")
                case.failure(let errorMessage):
                    completion(.failure(_errorMessage: errorMessage))
                }
            }
        }
    }
    
    func getProfile(completion: @escaping (CompletionHandler<Array<CardDetailForCardResponse>>) -> Void)
    {
        networkAgent.fetchTheProfile {
            switch $0
            {
            case.success(let listOfCards):
                self.cardRepo.save(data: listOfCards)
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage))
            }
            self.cardRepo.get {
                switch $0
                {
                case.success(let listOfCards):
                    completion(.success(listOfCards))
                case.failure(let errorMessage):
                    completion(.failure(_errorMessage: errorMessage))
                }
            }
        }
    }
    
    func fetchTheCinemaSeatsFromPADCEndpoint(timeslotID: Int, bookingDate: String, completion: @escaping (CompletionHandler<Array<CustomCinemaSeat>>) -> Void)
    {
        
        var movieSeats = Array<CinemaSeat>()
        
        networkAgent.fetchTheCinemaSeatsFromPADCEndpoint(timeslotID: timeslotID, bookingDate: bookingDate) { response in
            switch response
            {
            case.success(let listOfCinemaSeats):
                listOfCinemaSeats.forEach {
                    $0.forEach {
                        movieSeats.append($0)
                    }
                }
                self.cinemaSeatRepo.save(data: movieSeats)
//                completion(.success(movieSeats))
            case.failure(let errorMessage):debugPrint(errorMessage)
            }
            
            self.cinemaSeatRepo.getSeats {
                switch $0
                {
                case.success(let data):
                    completion(.success(data))
                case.failure(let errorMessage):
                    completion(.failure(_errorMessage: errorMessage))
                }
                
            }
        }
    }
    
    func loginWithGoogle(token: String, completion: @escaping (CompletionHandler<RegisterResponse>) -> Void)
    {
        networkAgent.loginWithGoogle(token: token) {
            switch $0
            {
            case.success(let response):completion(.success(response))
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
            }
        }
    }
    
    func fetchSnacksFromPadcEndPoint(completion: @escaping (CompletionHandler<Array<Snack>>) -> Void)
    {
        networkAgent.fetchSnacksFromPadcEndPoint {
            switch $0
            {
            case.success(let snacks):
                self.snackRepo.saveSnacks(snacks: snacks)
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage))
            }
            self.snackRepo.getSnacks {
                switch $0
                {
                case.success(let snacks):
                    completion(.success(snacks))
                case.failure(let errorMessage):
                    completion(.failure(_errorMessage: errorMessage))
                }
            }
        }
    }
    
    func fetchThePaymentCardsFromPADCEndPoint(completion: @escaping (CompletionHandler<Array<PaymentCard>>) -> Void)
    {
        networkAgent.fetchThePaymentCardsFromPADCEndPoint {
            switch $0
            {
            case.success(let listOfPayments):
                self.paymentMethodRepo.save(data: listOfPayments)
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
            }
            self.paymentMethodRepo.getPaymentCards {
                completion(.success($0))
            }
        }
    }
    
    
    func fetchTheCinemaTimeSlots(bookingDate: String, completion: @escaping (CompletionHandler<Array<CinemaTimeSlot>>) -> Void)
    {
        networkAgent.fetchTheCinemaTimeSlots(bookingDate: bookingDate) {
            switch $0
            {
            case.success(let listOfCinemaSlots):
                self.cinemaTimeSlotRepo.saveCinemaDaySlot(data: listOfCinemaSlots)
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
            }
            self.cinemaTimeSlotRepo.getCinemaDaySlots {
                switch $0
                {
                case.success(let listOfSeats):
                    completion(.success(listOfSeats))
                case.failure(let errorMessage):
                    completion(.failure(_errorMessage: errorMessage))
                }
            }
        }
    }
    
    func createCard(cardNumber: String, cardHolder: String, expirationDate: String, cvc: String, completion: @escaping (CompletionHandler<Array<CardDetailForCardResponse>>) -> Void)
    {
        networkAgent.createCard(cardNumber: cardNumber, cardHolder: cardHolder, expirationDate: expirationDate, cvc: cvc)
        {
            switch $0
            {
            case.success(let listOfCards):
                self.cardRepo.save(data: listOfCards)
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
            }
            self.cardRepo.get {
                switch $0
                {
                case.success(let listOfCards):completion(.success(listOfCards))
                case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
                }
            }
        }
    }
    
    func checkOut(timeslotID: Int, row: String, seatNumber: String, bookingDate: String, totalPrice: Int, movieID: Int, cardID: Int, cinemaID: Int, snacks: [RandomSnacks], completion: @escaping (CompletionHandler<CheckOutResponse>) -> Void) {
        networkAgent.checkOut(timeslotID: timeslotID, row: row, seatNumber: seatNumber, bookingDate: bookingDate, totalPrice: totalPrice, movieID: movieID, cardID: cardID, cinemaID: cinemaID, snacks: snacks) {
            switch $0
            {
            case.success(let checkout):
                completion(.success(checkout))
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage))
            }
        }
     }
    
    func login(email: String, password: String, completion: @escaping (CompletionHandler<RegisterResponse>) -> Void)
    {
        networkAgent.login(email: email, password: password) {
            switch $0
            {
            case.success(let registerReponse):
                completion(.success(registerReponse))
            case.failure(let errorMessage):
                completion(.failure(_errorMessage: errorMessage))
            }
        }
    }
    
    func register(name: String, email: String, phone: String, password: String, facebookToken: String, googleToken: String, completion: @escaping (CompletionHandler<RegisterResponse>) -> Void)
    {
        networkAgent.register(name: name, email: email, phone: phone, password: password, facebookToken: facebookToken, googleToken: googleToken) {
            switch $0
            {
            case.success(let registerReponse):
                completion(.success(registerReponse))
            case.failure(let errorMessage):completion(.failure(_errorMessage: errorMessage))
            }
        }
    }
    
}
