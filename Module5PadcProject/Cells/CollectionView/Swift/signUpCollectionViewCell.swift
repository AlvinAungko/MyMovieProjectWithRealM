//
//  signUpCollectionViewCell.swift
//  Module5PadcProject
//
//  Created by Alvin  on 17/02/2022.
//

import UIKit

class signUpCollectionViewCell: UICollectionViewCell,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var phoneNumberTetField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passworTextField: UITextField!
    @IBOutlet weak var confirmPassWordTextField: UITextField!
    var onTabAction:()->Void = {}
    
    var onTabGoogleButton:(String,String,String,String)->Void = {_,_,_,_ in}
    
    @IBOutlet weak var nameTextField: UITextField!
    var onTabSignupButton:(String,String,String,String,String)->Void = {_,_,_,_,_ in }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        passworTextField.isSecureTextEntry = true
        confirmPassWordTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        phoneNumberTetField.delegate = self
        nameTextField.delegate = self
        passworTextField.delegate = self
        confirmPassWordTextField.delegate = self
    }

    @IBAction func onTabSignUpWithGoogleButton(_ sender: Any)
    {
        let phoneNumber = phoneNumberTetField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passworTextField.text ?? ""
        let _ = confirmPassWordTextField.text ?? ""
        let name = nameTextField.text ?? ""
        
        onTabGoogleButton(name,phoneNumber,email,password)
        
        clearTextField()
    }
    @IBAction func onTabConfirm(_ sender: Any)
    {
        let phoneNumber = phoneNumberTetField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passworTextField.text ?? ""
        let confirmPassword = confirmPassWordTextField.text ?? ""
        let name = nameTextField.text ?? ""
        
        onTabSignupButton(name,phoneNumber,email,password,confirmPassword)
        
        clearTextField()
    }
    
    
}

extension signUpCollectionViewCell
{
    func clearTextField()
    {
        phoneNumberTetField.text = ""
        emailTextField.text = ""
        passworTextField.text = ""
        confirmPassWordTextField.text = ""
        nameTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
