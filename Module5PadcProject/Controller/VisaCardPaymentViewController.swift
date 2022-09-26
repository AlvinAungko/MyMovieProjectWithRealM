//
//  VisaCardPaymentViewController.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 19/02/2022.
//

import UIKit
import Gemini

class VisaCardPaymentViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var priceMainLabel: UILabel!
    @IBOutlet weak var heightOfCardPaymentCollectionView: NSLayoutConstraint!
 
    @IBOutlet weak var cardVisaCardCollectionView: GeminiCollectionView!
    
    var totalAmount = 0
    
    let padcShared = PadcModelLayer.shared
    
    var snacks = Array<RandomSnacks>()
    
    var listOfCards:Array<CardDetailForCardResponse>?
    {
      didSet
        {
          if let data = listOfCards
        {
          
           if data == Array<CardDetailForCardResponse>()
           {
               self.cardVisaCardCollectionView.isHidden = true
           } else {
               self.cardVisaCardCollectionView.reloadData()
           }
              
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTotalPrice()
        setUpHeightForCollectionView()
        configureAnimation()
        registerCells()
        setDataSourceAndDelegate()
        fetchTheCards()
//        addRefresher()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        fetchTheCards()
    }
    
    @IBAction func onTabaddANewCard(_ sender: Any)
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CardDataEntryViewController") as? CardDataEntryViewController else {return}
        vc.totalPrice = totalAmount
        vc.snackGroup = snacks
        vc.delegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onTabConfirm(_ sender: Any)
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ReceiptViewController") as? ReceiptViewController else {return}
        vc.snacksThatUserSelected = snacks
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onTabBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension VisaCardPaymentViewController
{
    func setupTotalPrice()
    {
        priceMainLabel.text = "$\(totalAmount)"
        let userDefaults = UserDefaults.standard
        userDefaults.set(totalAmount, forKey: "totalPrice")
        debugPrint("\(totalAmount) >> TotalPrice")
    }
    
    private func setDataSourceAndDelegate()
    {
        cardVisaCardCollectionView.dataSource = self
        cardVisaCardCollectionView.delegate = self
    }
    
    private func registerCells()
    {
        cardVisaCardCollectionView.registerCustomCells(identifier: VisaCardGeminiCollectionViewCell.identifier)
    }
    
    private func setUpHeightForCollectionView()
    {
        heightOfCardPaymentCollectionView.constant = 215+25
    }
    
    func fetchTheCards()
    {
        let userDefaults = UserDefaults.standard
         let userID = userDefaults.integer(forKey: "userID")
        padcShared.fetchProfileAndCards(userID: userID) {
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

extension VisaCardPaymentViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func configureAnimation()
    {
        let customAnimate = cardVisaCardCollectionView.gemini.scaleAnimation()
        customAnimate.scale(0.65)
        customAnimate.scaleEffect(.scaleUp)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        cardVisaCardCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? VisaCardGeminiCollectionViewCell else {return}
        self.cardVisaCardCollectionView.animateCell(cell)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfCards?.count ?? 0
    }
    
    func setUpTheCardIDForUserDefault(cardID:Int)
    {
        let deafults = UserDefaults.standard
        deafults.set(cardID, forKey: "cardID")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = cardVisaCardCollectionView.bindCustomCellToTheChambers(identifier: VisaCardGeminiCollectionViewCell.identifier, indexPath: indexPath) as VisaCardGeminiCollectionViewCell
        
        cell.customCard = listOfCards?[indexPath.row]
        
        cell.onTabCard = {
            cardID in
            self.setUpTheCardIDForUserDefault(cardID: cardID)
        }
        
        self.cardVisaCardCollectionView.animateCell(cell)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cardVisaCardCollectionView.bounds.width, height: 215)
    }
    
    
}
extension VisaCardPaymentViewController:IsAbleToReciveData
{
    func receiveCards(data: Array<CardDetailForCardResponse>) {
        debugPrint(data.count)
    }
    
    func addRefresher()
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for:.valueChanged)

        scrollView.addSubview(refreshControl)
        
    }
    
    
    @objc func didPullToRefresh()
    {
        self.fetchTheCards()
    }
        
}

protocol IsAbleToReciveData
{
    func receiveCards(data:Array<CardDetailForCardResponse>)
}
