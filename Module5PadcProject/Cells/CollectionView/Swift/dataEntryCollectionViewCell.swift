//
//  dataEntryCollectionViewCell.swift
//  Module5PadcProject
//
//  Created by Alvin  on 17/02/2022.
//

import UIKit

class dataEntryCollectionViewCell: UICollectionViewCell,UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var view: UIView!
    var onTabLoginButton:(String,String)->Void = {_,_ in}
    
    var movieAppProtocol:MovieAppDelegate?
    
    var onTouchGoogleButton:(Bool)->Void = {_ in}

    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        roundTheButtons()
        passWordTextField.isSecureTextEntry = true
        
        emailTextField.delegate = self
        passWordTextField.delegate = self
        
    }

    @IBAction func onTabConfirm(_ sender: Any)
    {
        
        let email = emailTextField.text ?? "No Email"
        let password = passWordTextField.text ?? "No Password"
        onTabLoginButton(email,password)
        
    }
    @IBAction func onTabGoogleButton(_ sender: Any)
    {
        onTouchGoogleButton(true)
    }
}

extension dataEntryCollectionViewCell
{
    private func roundTheButtons()
    {
        googleButton.layer.borderWidth = 0.5
        googleButton.layer.cornerRadius = 15
        
        facebookButton.layer.borderWidth = 0.5
        facebookButton.layer.cornerRadius = 15
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
