//
//  Navigation.swift
//  Module5PadcProject
//
//  Created by Aung Ko Ko on 19/02/2022.
//

import Foundation
import UIKit




extension UIViewController
{
    func navigateToViewController(identifier:String)
    {
//        let storyBoard = UIStoryboard.initStoryBoard(identifier: "Main")
        let vc = UIViewController.initViewController(identifer:identifier)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    static func initViewController<V:UIViewController>(identifer:String) -> V
    {
        let storyBoard = UIStoryboard.initStoryBoard(identifier: "Main")
        guard let vc = storyBoard.instantiateViewController(withIdentifier: identifer) as? V
                else
                {
                    return UIViewController() as! V
                }
        return vc
    }
    
}

extension UIStoryboard
{
    static func initStoryBoard<S:UIStoryboard>(identifier:String) -> S
    {
        guard let storyBoard = UIStoryboard(name: identifier, bundle: nil) as? S
        else
        {
            return UIStoryboard() as! S
        }
        return storyBoard
    }
}
