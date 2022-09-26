//
//  HomeScreenViewController.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 26/02/2022.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBorder()
    }
    @IBAction func onTabGetStarted(_ sender: Any) {
        navigateToViewController(identifier: LOGIN_SIGNUP_VIEW_CONTROLLER)
    }
    

}

extension HomeScreenViewController
{
    private func addBorder()
    {
        getStartedButton.layer.borderWidth = 0.5
        getStartedButton.layer.cornerRadius = 15
        getStartedButton.layer.borderColor = UIColor.white.cgColor
    }
}
