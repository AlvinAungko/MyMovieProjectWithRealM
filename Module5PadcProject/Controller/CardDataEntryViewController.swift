//
//  CardDataEntryViewController.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 26/02/2022.
//

import UIKit

class CardDataEntryViewController: UIViewController {

    
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var cardHolderTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    var delegate:IsAbleToReciveData?
    
    var totalPrice = Int()
    
    var snackGroup = Array<RandomSnacks>()
    
    let padcShared = PadcModelLayer.shared
    
    var cards:Array<CardDetailForCardResponse>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        delegate?.receiveCards(data: cards ?? [])
    }
    
    @IBAction func onTabBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onTabConfirm(_ sender: Any)
    {
        let cardNumber = cardNumberTextField.text ?? ""
        let cardHolder = cardHolderTextField.text ?? ""
        let expireDare = expirationDateTextField.text ?? ""
        let cvc = cvcTextField.text ?? ""
        
        if cardNumber.isEmpty || cardHolder.isEmpty || expireDare.isEmpty || cvc.isEmpty
        {
            self.showAlert(message: "Every field has to be completely filled.")
        } else {
            padcShared.createCard(cardNumber: cardNumber, cardHolder: cardHolder, expirationDate: expireDare, cvc: cvc) {
                switch $0
                {
                case.success(let lisrOfCards):
                    self.cards = lisrOfCards
    //                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    //                guard let vc = storyboard.instantiateViewController(withIdentifier: "VisaCardPaymentViewController") as? VisaCardPaymentViewController else {return}
    //                vc.totalAmount = self.totalPrice
    //                vc.snacks = self.snackGroup
    //                vc.modalTransitionStyle = .coverVertical
    //                vc.modalPresentationStyle = .fullScreen
    //                self.present(vc, animated: true, completion: nil)
                    self.dismiss(animated: true)
                case.failure(let errorMessage):debugPrint(errorMessage)
                }
            }
        }
        
    }
    
}

extension CardDataEntryViewController
{
    func showAlert(message:String)
    {
        let alertController:UIAlertController = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

