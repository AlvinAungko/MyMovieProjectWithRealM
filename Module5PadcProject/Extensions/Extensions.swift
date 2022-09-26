//
//  Extensions.swift
//  Module5PadcProject
//
//  Created by Alvin  on 15/02/2022.
//

import Foundation
import UIKit

extension UICollectionViewCell
{
    static var identifier:String
    {
        String(describing: self)
    }
}

extension UICollectionView
{
     func registerCustomCells(identifier:String)
    {
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
     func bindCustomCellToTheChambers<C:UICollectionViewCell>(identifier:String,indexPath:IndexPath) -> C
    {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? C else {
            return UICollectionViewCell() as! C
        }
        return cell
    }
}

extension Int {

    static func getUniqueRandomNumbers(min: Int, max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            set.insert(Int.random(in: min...max))
        }
        return Array(set)
    }

}

extension Date{
    
     static var thisYear: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let component = formatter.string(from: Date())
        
        if let value = Int(component) {
            return value
        }
        return 0
    }
    
    private static func getComponent(date: Date, format: String) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = format
        formatter.locale = Locale.autoupdatingCurrent
           let component = formatter.string(from: date)
           return component
    }
    
    static func getFollowingThirtyDays(for month: Int = 5) -> [TicketDate]
    {
        
        var dates = [TicketDate]()
        let dateComponents = DateComponents(year: thisYear , month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        for i in range{
            guard let fullDate = calendar.date(byAdding: DateComponents(day: i-1) , to: Date()) else { continue }
            let d = getComponent(date: fullDate, format: "dd")
            let m = getComponent(date: fullDate, format: "MM")
            let y = getComponent(date: fullDate, format: "yy")
            let e = getComponent(date: fullDate, format: "EE")
            let ticketDate = TicketDate(day: d, month: m, year: y,dayLabel: e)
            dates.append(ticketDate)
        }
        
        return dates
        
    }
}

//extension UICollectionViewCell {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

