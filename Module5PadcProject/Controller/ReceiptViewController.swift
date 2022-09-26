//
//  ReceiptViewController.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 19/02/2022.
//

import UIKit
import RealmSwift
import SDWebImage

class ReceiptViewController: UIViewController {

    @IBOutlet weak var stackedDataView: UIStackView!
    @IBOutlet weak var cinemaMovieIv: UIImageView!
    @IBOutlet weak var viewToCurve: UIView!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var bookingNumber: UILabel!
    @IBOutlet weak var showDateLabel: UILabel!
    @IBOutlet weak var cinemaLabel: UILabel!
    @IBOutlet weak var cinemaIDLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var barCodeImageView: UIImageView!
    
    var snacksThatUserSelected = Array<RandomSnacks>()
    
    var movieID:Int?
    {
        didSet
        {
          if let data = movieID
        {
              self.extractTheMovieObject(movieID: data)
        }
        }
    }
    
    
    var checkout:CheckOutResponse?
    {
      didSet
        {
          if let data = checkout
            {
              self.bindTheDatatoUI(data: data)
          }
        }
    }
    
    let realM = try!Realm()
    
    let padcShared = PadcModelLayer.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundTheCorners()
        // Do any additional setup after loading the view.
        checkOut()
    }
    
    @IBAction func onTabBack(_ sender: Any)
    {
       navigateToViewController(identifier: MOVIE_VIEW_CONTROLLER)
    }
    

}

extension ReceiptViewController
{
    private func roundTheCorners()
    {
        cinemaMovieIv.layer.cornerRadius = 15
        cinemaMovieIv.clipsToBounds = true
        
        viewToCurve.backgroundColor = UIColor.white
        viewToCurve.clipsToBounds = true
        viewToCurve.layer.cornerRadius = 15
        
        viewToCurve.layer.masksToBounds = false
//        viewToCurve.layer.shadowRadius = 30
        viewToCurve.layer.shadowOpacity = 0.14
        viewToCurve.layer.shadowOffset = CGSize(width: 1, height: 3)
        viewToCurve.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    func checkOut()
    {
        let defaults = UserDefaults.standard
        let movieID = defaults.integer(forKey: "movieID")
        let timeslotID = defaults.integer(forKey: "timeSlotID")
        let seatsThatUserTaken = defaults.string(forKey: "seatsOfTicket")
        let cinemaID = defaults.integer(forKey: "cinemaID")
        let totalPrice = defaults.integer(forKey: "totalPrice")
        
        debugPrint("Total Price >> \(totalPrice)")
        
        let cardID = defaults.integer(forKey: "cardID")
        
        let data = seatsThatUserTaken?.dropLast()
       let customSeat =  data.map {
            return String($0)
        }
        let bookingDate = defaults.string(forKey: "cinemaBookingDate")
        
        let snacks = self.validateTheEmptySnacks(data: snacksThatUserSelected)
        
        
        padcShared.checkOut(timeslotID: timeslotID, row: "", seatNumber: customSeat ?? "", bookingDate: bookingDate ?? "", totalPrice: totalPrice, movieID: movieID, cardID: cardID, cinemaID: cinemaID, snacks: snacks) {
            switch $0
            {
            case.success(let data):
                self.checkout = data
                self.movieID = data.data?.movieID ?? 0
            case.failure(let errorMessage):debugPrint(errorMessage)
            }
        }
        
    }
}

extension ReceiptViewController
{
    func validateTheEmptySnacks(data:Array<RandomSnacks>)->Array<RandomSnacks>
    {
        if data == Array<RandomSnacks>()
        {
            return [RandomSnacks(id: 1, quantity: 0)]
        } else {
            return data
        }
    }
    
    
    func extractTheMovieObject(movieID:Int)
    {
        guard let movieObject = realM.object(ofType: MovieObject.self, forPrimaryKey: movieID) else {return}
        self.movieTitle.text = movieObject.title ?? ""
        self.movieDuration.text = ""
        self.movieImageView.sd_setImage(with:URL(string: "\(EasyConstants.urlImage)\(movieObject.posterPath ?? "")") )
    }
    
    func bindTheDatatoUI(data:CheckOutResponse)
    {
        self.bookingNumber.text = data.data?.bookingNumber ?? ""
        self.showDateLabel.text = data.data?.bookingDate ?? ""
        self.cinemaIDLabel.text = "\(data.data?.cinemaID ?? 0)"
        self.seatLabel.text = data.data?.seat ?? ""
        self.totalPriceLabel.text = data.data?.total
        self.barCodeImageView.sd_setImage(with:URL(string: "\(EasyConstants.urlImageForPadc)\(data.data?.qrCode ?? "")"))
    }
}
