//
//  LoginAndSignUpViewController.swift
//  Module5PadcProject
//
//  Created by Alvin  on 17/02/2022.
//

import UIKit

class LoginAndSignUpViewController: UIViewController
{
    @IBOutlet weak var signUpStackView: UIStackView!
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var viewOfLogin: UIView!
    @IBOutlet weak var viewOfSignUp: UIView!
    @IBOutlet weak var heightOfDataEntryCollectionView: NSLayoutConstraint!
    @IBOutlet weak var heightOfIndicatorCollectionView: NSLayoutConstraint!
    @IBOutlet weak var dataEntryCollectionView: UICollectionView!
    
    let padcModelLayerShared = PadcModelLayer.shared
    
    
    var accessToken:String?
    
    var finalToken = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initView()
        setUpHeightForCollectionView()
        registerCells()
        setDataSourceAndDelegate()
        addGesture()
        extractTheTokenFromTheDefaultKey()
       
        // Do any additional setup after loading the view.
    }
    
}

extension LoginAndSignUpViewController
{
    private func addGesture()
    {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTabLogin))
        loginStackView.addGestureRecognizer(gestureRecognizer)
        loginStackView.isUserInteractionEnabled = true
        
        
        let gestureRecognizerForSignUp = UITapGestureRecognizer(target: self, action: #selector(onTabSignUp))
        signUpStackView.addGestureRecognizer(gestureRecognizerForSignUp)
        signUpStackView.isUserInteractionEnabled = true
        
    }
    
    @objc func onTabLogin()
    {
        presentRespectiveCell(to: 0)
        
    }
    
    @objc func onTabSignUp()
    {
        presentRespectiveCell(to: 1)
        
    }
}



extension LoginAndSignUpViewController
{
    private func setDataSourceAndDelegate()
    {
        dataEntryCollectionView.dataSource = self
        dataEntryCollectionView.delegate = self
    }
    
    private func registerCells()
    {
       
        dataEntryCollectionView.registerCustomCells(identifier: dataEntryCollectionViewCell.identifier)
        dataEntryCollectionView.registerCustomCells(identifier: signUpCollectionViewCell.identifier)
    }
}

extension LoginAndSignUpViewController
{
    private func setUpHeightForCollectionView()
    {
        
        heightOfDataEntryCollectionView.constant = 600
        self.dataEntryCollectionView.layoutIfNeeded()
    }
    
    private func initView()
    {
        self.viewOfLogin.isHidden = false
        self.viewOfSignUp.isHidden = true
    }
}

//MARK: Set up the func to fetch The Data from Model Layer

extension LoginAndSignUpViewController
{
    func login(email:String,password:String)
    {
        padcModelLayerShared.login(email: email, password: password) {
            switch $0
            {
            case.success(let registerResponse):
                self.setUpDefaultStandard(token: registerResponse.token ?? "",userName: registerResponse.data?.name ?? "", userID: registerResponse.data?.id ?? 0)
                if registerResponse.code == 200
                {
                    self.navigateToViewController(identifier: MOVIE_VIEW_CONTROLLER)
                } else
                {
                    self.showAlert(message: registerResponse.message ?? "")
                }
            case.failure(let errorMessage):debugPrint(errorMessage)
            }
        }
    }
    
    func register(name:String,phoneNumber:String,email:String,password:String,confirmPassword:String,facebookToken:String,googleToken:String)
    {
        padcModelLayerShared.register(name: name, email: email, phone: phoneNumber, password: password, facebookToken: facebookToken, googleToken: googleToken) {
            switch $0
            {
            case.success(let registerResponse):
                self.setUpDefaultStandard(token: registerResponse.token ?? "",userName: registerResponse.data?.name ?? "",userID: registerResponse.data?.id ?? 0)
                let successCodeRange = 200...299
                if successCodeRange.contains(registerResponse.code ?? 0)
                {
                    self.showAlert(message: registerResponse.message ?? "")
                } else
                {
                    self.showAlert(message: registerResponse.message
                     ?? "")
                }
                
            case.failure(let errorMessage):debugPrint(errorMessage)
            }
        }
    }
    
    func loginWithGoogle(token:String)
    {
        padcModelLayerShared.loginWithGoogle(token: token) {
            switch $0
            {
            case.success(let registerResponse):
                self.setUpDefaultStandard(token: registerResponse.token ?? "",userName: registerResponse.data?.name ?? "", userID: registerResponse.data?.id ?? 0)
                let successCodeRage = 200...299
                if successCodeRage.contains(registerResponse.code ?? 0)
                {
                    self.navigateToViewController(identifier: MOVIE_VIEW_CONTROLLER)
                }
                else {
                    self.showAlert(message: registerResponse.message ?? "")
                }
                
            case.failure(let errorMessage):
                debugPrint("error = \(errorMessage)")
            }
        }
    }
}

//MARK: SetUp DefaultStandard

extension LoginAndSignUpViewController
{
    func setUpDefaultStandard(token:String,userName:String,userID:Int)
    {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "token")
        defaults.set(userName, forKey: "userName")
        defaults.set(userID, forKey: "userID")
    }
    
    func extractTheTokenFromTheDefaultKey()
    {
        let defaults = UserDefaults.standard
        guard let value = defaults.string(forKey: "token") else {
            debugPrint("No value at the moment")
            return
        }
        self.finalToken = value
    }
}

extension LoginAndSignUpViewController
{
    func showAlert(message:String)
    {
        let alertController:UIAlertController = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let alertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LoginAndSignUpViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
            return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch indexPath.section
            {
            case 0:
                let cell = dataEntryCollectionView.bindCustomCellToTheChambers(identifier: dataEntryCollectionViewCell.identifier, indexPath: indexPath) as dataEntryCollectionViewCell
                
                cell.onTabLoginButton =
                {
                    email,password in
                    
                    if email.isEmpty && password.isEmpty
                    {
                        self.showAlert(message: "Both Field are Empty")
                    }
                    
                    else
                    {
                        self.login(email: email, password: password)
                    }
                }
                
                cell.onTouchGoogleButton = {
                    condition in
                    if condition == true
                    {
                        let googleAuth = GoogleAuth()
                        googleAuth.start(view: self) { successResponse in
                            self.loginWithGoogle(token: successResponse.id)
                        } failure: { errorMessage in
                            debugPrint(errorMessage)
                        }
                    } else {
                        
                    }
                }
                
                return cell
            case 1:
                let cell = dataEntryCollectionView.bindCustomCellToTheChambers(identifier: signUpCollectionViewCell.identifier, indexPath: indexPath) as signUpCollectionViewCell
                
                cell.onTabSignupButton =
                {
                    name,phoneNumber,email,password,confirmPassword in
                   
                    
                    if email.isEmpty || phoneNumber.isEmpty || password.isEmpty || email.isEmpty
                    {
                        self.showAlert(message: "Please make sure that every field is completely filled")
                    }
                    
                    let correctFormatEmail = self.isValidEmail(email)
                    
                    if correctFormatEmail == true
                    {
                        self.register(name:name,phoneNumber: phoneNumber, email: email, password: password, confirmPassword: confirmPassword,facebookToken: "",googleToken: "")
                    }
                    else
                    {
                        self.showAlert(message: "Your Email order is not correct")
                    }
                    
                
                   
                }
                
                cell.onTabGoogleButton = {
                    name,phoneNumber,email,password in
                    
                    let googleAuth = GoogleAuth()
                    googleAuth.start(view: self)
                    {
                        self.register(name:name,phoneNumber: phoneNumber, email: email, password: password, confirmPassword: password, facebookToken: "", googleToken: $0.id)
                    } failure: { errorMessage in
                        debugPrint(errorMessage)
                    }

                }
                
                return cell
            default : return UICollectionViewCell()
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            switch indexPath.section
            {
            case 0: return CGSize(width: dataEntryCollectionView.bounds.width, height: heightOfDataEntryCollectionView.constant)
            case 1: return CGSize(width: dataEntryCollectionView.bounds.width, height:  heightOfDataEntryCollectionView.constant+100)
            default : return CGSize(width: 0, height: 0)
            }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x/scrollView.frame.width == 0
        {
            self.viewOfLogin.isHidden = false
            self.viewOfSignUp.isHidden = true
        } else
        {
            self.viewOfLogin.isHidden = true
            self.viewOfSignUp.isHidden = false
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x/scrollView.frame.width == 0
        {
            self.viewOfLogin.isHidden = false
            self.viewOfSignUp.isHidden = true
        } else
        {
            self.viewOfLogin.isHidden = true
            self.viewOfSignUp.isHidden = false
        }
    }
    
    func presentRespectiveCell(to whichCell:Int)
    {
        if whichCell == 1
        {
            let cellSize = CGSize(width: self.dataEntryCollectionView.frame.width, height: self.dataEntryCollectionView.frame.height)
            
            let contentOffSet = dataEntryCollectionView.contentOffset
            
            dataEntryCollectionView.scrollRectToVisible(CGRect(x: CGFloat(contentOffSet.x) +  CGFloat(cellSize.width), y: CGFloat(contentOffSet.y), width: cellSize.width, height: cellSize.height), animated: true)
            debugPrint(contentOffSet.x)
        } else
        {
            let cellSize = CGSize(width: self.dataEntryCollectionView.frame.width, height: self.dataEntryCollectionView.frame.height)
            
            let contentOffSet = dataEntryCollectionView.contentOffset
            
            dataEntryCollectionView.scrollRectToVisible(CGRect(x: CGFloat(contentOffSet.x) -  CGFloat(cellSize.width), y: CGFloat(contentOffSet.y), width: cellSize.width, height: cellSize.height), animated: true)
            debugPrint(contentOffSet.x)
        }
        
        
    }
    
}

extension LoginAndSignUpViewController:MovieAppDelegate
{
    func navigateToMovieList()
    {
        navigateToViewController(identifier: MOVIE_VIEW_CONTROLLER)
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
