//
//  SnackSelectionViewController.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 19/02/2022.
//

import UIKit

class SnackSelectionViewController: UIViewController {

    @IBOutlet weak var priceTotallabel: UILabel!
    @IBOutlet weak var heighOfPaymentCardCollectionView: NSLayoutConstraint!
    @IBOutlet weak var heightOfSnackCollectionView: NSLayoutConstraint!
    @IBOutlet weak var paymentCardCollectionView: UICollectionView!
    @IBOutlet weak var snackCollectionView: UICollectionView!
    
    let padcShared = PadcModelLayer.shared
    
    var snackLists:Array<RandomSnacks>?
    
    var capturedPriceList:Int = 0
    var accessToken:String?
    
    var snackList = Array<RandomSnacks>()
    
    var firstSnackList = Dictionary<Int,[RandomSnacks]>()
    var secondSnackList = Dictionary<Int,[RandomSnacks]>()
    var thirdSnackList = Dictionary<Int,[RandomSnacks]>()
    
    var listOfSnacks:Array<Snack>?
    {
      didSet
        {
            if let _ = listOfSnacks
            {
                self.snackCollectionView.reloadData()
            }
        }
    }
    
    var listOfCards:Array<PaymentCard>?
    {
       didSet
        {
            if let _ = listOfCards
            {
                self.paymentCardCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpHeightForCollectionView()
        registerCells()
        setDataSourceAndDelegate()
        extractTheTokenFromDefault()
        setPayment()
        fetchTheSnacks()
        fetchTheListOfCards()
        // Do any additional setup after loading the view.
    }

    @IBAction func onTabPay(_ sender: Any)
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: MOVIE_VISA_VIEW_CONTROLLER) as? VisaCardPaymentViewController else {return}
        
        vc.totalAmount = capturedPriceList
        vc.snacks = snackList
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onTabBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SnackSelectionViewController
{
    private func setPayment()
    {
        priceTotallabel.text = "You have to pay \(String(capturedPriceList))$"
        
    }
    
    func fetchTheSnacks()
    {
        padcShared.fetchSnacksFromPadcEndPoint {
            switch $0
            {
            case.success(let snacks):
                self.listOfSnacks = snacks
            case.failure(let errorMessage):debugPrint(errorMessage)
            }
        }
    }
    
    func fetchTheListOfCards()
    {
        padcShared.fetchThePaymentCardsFromPADCEndPoint {
            switch $0
            {
            case.success(let listOfCards):
                self.listOfCards = listOfCards
            case.failure(let errorMessage):
                debugPrint(errorMessage)
            }
        }
    }
}

extension SnackSelectionViewController
{
    private func setDataSourceAndDelegate()
    {
        snackCollectionView.dataSource = self
        snackCollectionView.delegate = self
        
        paymentCardCollectionView.dataSource = self
        paymentCardCollectionView.delegate = self
        
    }
    
    private func registerCells()
    {
        snackCollectionView.registerCustomCells(identifier: SnackCouponCollectionViewCell.identifier)
        paymentCardCollectionView.registerCustomCells(identifier: PaymentCardCollectionViewCell.identifier)
    }
    
    private func setUpHeightForCollectionView()
    {
        heightOfSnackCollectionView.constant = 94*3
        heighOfPaymentCardCollectionView.constant = (56*2)+10
        
        snackCollectionView.layoutIfNeeded()
        paymentCardCollectionView.layoutIfNeeded()
    }
}

extension SnackSelectionViewController
{
    func extractTheTokenFromDefault()
    {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "token") else
        {
            debugPrint("Empty token")
            return
        }
        accessToken = token
    }
}

extension SnackSelectionViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == snackCollectionView
        {
            return listOfSnacks?.count ?? 0
        }
        else
        {
            return listOfCards?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == snackCollectionView
        {
            let cell = snackCollectionView.bindCustomCellToTheChambers(identifier: SnackCouponCollectionViewCell.identifier, indexPath: indexPath) as SnackCouponCollectionViewCell
            
            cell.customSnack = listOfSnacks?[indexPath.row]
            
            cell.onTabPlus =
            {
                capturedValue,snackId,numberOfSnack in
                self.capturedPriceList += Int(capturedValue) ?? 0
                self.setPayment()
                self.setupTheSnackList(snackID: snackId, snackQuantity: numberOfSnack)
                self.setUpTheDefaults()
            }
            
            cell.onTabMinus =
            {
                capturedPrice,snackID,numberOfSnack in
                self.capturedPriceList -= Int(capturedPrice) ?? 0
                self.setPayment()
                self.setupTheSnackList(snackID: snackID, snackQuantity: numberOfSnack)
                self.setUpTheDefaults()
            }
            return cell
        } else
        {
            let cell = paymentCardCollectionView.bindCustomCellToTheChambers(identifier: PaymentCardCollectionViewCell.identifier, indexPath: indexPath) as PaymentCardCollectionViewCell
            
            cell.customCard = listOfCards?[indexPath.row]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == snackCollectionView
        {
            return CGSize(width: snackCollectionView.bounds.width, height: 94)
        } else
        {
            return CGSize(width: paymentCardCollectionView.bounds.width, height: 56)
        }
    }
    
    
    func setupTheSnackList(snackID:Int,snackQuantity:Int)
    {
        snackList.append(RandomSnacks(id: snackID, quantity: snackQuantity))
        snackList.forEach {
            debugPrint("[\($0.id ?? 0),\($0.quantity ?? 0)] ")
        }
    }
    
    func setUpTheDefaults()
    {
        snackList.forEach {
            if $0.id == 1
            {
                firstSnackList[$0.id ?? 0] = [$0]
            } else if $0.id == 2
            {
                secondSnackList[$0.id ?? 0] = [$0]
            } else {
                thirdSnackList[$0.id ?? 0] = [$0]
            }
        }
        
        guard let firstSnack = firstSnackList[1]?.first else {return}
        guard let secondSnack = secondSnackList[2]?.first else {return}
        guard let thirdSnack = thirdSnackList[3]?.first else {return}
        
//        debugPrint("\(firstSnack?.id ?? 0) >> \(firstSnack?.quantity ?? 0)")
//        
//        debugPrint("\(secondSnack?.id ?? 0) >> \(secondSnack?.quantity ?? 0)")
//        
//        debugPrint("\(thirdSnack?.id ?? 0) >> \(thirdSnack?.quantity ?? 0)")
        

        var listOfSnacks = Array<RandomSnacks>()
        
        listOfSnacks.append(firstSnack)
        listOfSnacks.append(secondSnack)
        listOfSnacks.append(thirdSnack)
        
        self.snackList = listOfSnacks
        
    }
}


