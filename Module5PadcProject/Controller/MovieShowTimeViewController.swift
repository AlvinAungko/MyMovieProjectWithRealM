//
//  MovieShowTimeViewController.swift
//  Module5PadcProject
//
//  Created by Alvin  on 15/02/2022.
//

import UIKit

class TicketDate
{
    var day:String?
    var month:String?
    var year:String?
    var dayLabel:String?
    
    init(day:String,month:String,year:String,dayLabel:String)
    {
        self.day = day
        self.month = month
        self.year = year
        self.dayLabel = dayLabel
    }
    
    func toCustomTicketDate() -> CustomTicketDate
    {
        return CustomTicketDate(day: day ?? "", month: month ?? "", year: year ?? "", isSelected: false, dayLabel: dayLabel ?? "")
    }
}

class CustomTicketDate
{
    var day:String?
    var month:String?
    var year:String?
    var dayLabel:String?
    var isSelected:Bool?
    
    init(day:String,month:String,year:String,isSelected:Bool,dayLabel:String)
    {
        self.day = day
        self.month = month
        self.year = year
        self.isSelected = isSelected
        self.dayLabel = dayLabel
   }
}


class MovieShowTimeViewController: UIViewController
{

    @IBOutlet weak var heightOfDayCollectionView: NSLayoutConstraint!
    @IBOutlet weak var scrollViewForEntireView: UIScrollView!
    @IBOutlet weak var heightOfThirdCinemaCollectionView: NSLayoutConstraint!
    @IBOutlet weak var heightOfSecondCinemaCollectionView: NSLayoutConstraint!
    @IBOutlet weak var heightOfFirstCinemaCollectionview: NSLayoutConstraint!
    @IBOutlet weak var thirdCinemaCollectionView: UICollectionView!
    @IBOutlet weak var secondCinemaCollectionView: UICollectionView!
    @IBOutlet weak var firstCinemaCollectionView: UICollectionView!
    @IBOutlet weak var dayCalendarCollectionView: UICollectionView!
    
    var dummyDayList = Array<DummyDay>()
    
    var movieAppDele:MovieAppDelegate?
    
    var customDateTime = Array<CustomTicketDate>()
    
    var dummyTimeList = Array<dummyTime>()
    var dummySecondTimeList = Array<dummyTime>()
    
    let padcShared = PadcModelLayer.shared
    
//    var listOfCinemaTimeSlot:Array<CinemaTimeSlot>?
    
    var timeSlotThatUserTabbed = Int()
    
    var timeSlotIDMappingStartTime = Dictionary<Int,String>()
    //MARK: For Example : (TimeSlotID 1: 9:30 PM)
    
    var timeSlotMappingCinema = Dictionary<Int,String>() //MARK: For Example (TimeSlotID 1: Cinema I)
    
    var cinemaByTimeSlots = Dictionary<String,Array<TimeSlot>>()
    //MARK: For Example(CinemaI : [TimeSlot Object1, TimeSlot Object2])
    
    var timeSlotMappingCinemaID = Dictionary<Int,Int>()
    //MARK: For Example(timeslotID 1: CinemaID 2)
    
    var idForCinema = Int()
    
    var firstCinemaTimeSlots:Array<CustomTimeSlot>?
    {
        didSet
        {
            if let _ = firstCinemaTimeSlots
            {
                self.firstCinemaCollectionView.reloadData()
            }
        }
    }
    var secondCinemaTimeSlots: Array<CustomTimeSlot>?
    {
        didSet
        {
            if let _ = secondCinemaTimeSlots
            {
                self.secondCinemaCollectionView.reloadData()
            }
        }
    }
    
    var thirdCinemaTimeSlots:Array<CustomTimeSlot>?
    {
        didSet
        {
            if let _ = thirdCinemaTimeSlots
            {
                self.thirdCinemaCollectionView.reloadData()
            }
        }
    }
    
    var bookingDate:String?
    {
        didSet
        {
            if let date = bookingDate
            {
                self.fetchTheCinemaAndDaySlots(bookingDate: date)
                self.firstCinemaCollectionView.reloadData()
                self.secondCinemaCollectionView.reloadData()
                self.thirdCinemaCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        setUpContentInsetForScrollView()
        registerCells()
        setHeightForCollectionView()
        bindDataToTheCalenderList()
        fetchTheCinemaAndDaySlots(bookingDate: bookingDate ?? "\(customDateTime.first?.year ?? "")-\(customDateTime.first?.month ?? "")-\(customDateTime.first?.day ?? "")")
        setDataSourceAndDelegate()
        setDelegate()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTabNext(_ sender: Any)
    {
        
        guard let cinema = timeSlotMappingCinema[timeSlotThatUserTabbed] else {
            debugPrint("No Cinema")
            return
        }
        
        guard let selectedTime = timeSlotIDMappingStartTime[timeSlotThatUserTabbed] else {
            debugPrint("No selectedTime")
            return
        }
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: MOVIE_SEAT_VIEW_CONTROLLER) as? MovieSeatViewController else {
            return
        }
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
        vc.bookingDate = bookingDate ?? ""
        vc.cinemaName = cinema
        vc.selectedTime = selectedTime
        vc.timeslotID = timeSlotThatUserTabbed
                self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onTabBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MovieShowTimeViewController
{
    private func bindDataToTheCalenderList()
    {
        customDateTime = Date.getFollowingThirtyDays().map({
            $0.toCustomTicketDate()
        })
        
        customDateTime.first?.isSelected = true
        
    }
    
}

extension MovieShowTimeViewController
{
    private func setUpContentInsetForScrollView()
    {
        scrollViewForEntireView.contentInsetAdjustmentBehavior = .never
        scrollViewForEntireView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
    }
}

extension MovieShowTimeViewController
{
    
    private func setHeightForCollectionView()
    {
        heightOfDayCollectionView.constant = 84
        heightOfFirstCinemaCollectionview.constant = 56
        heightOfSecondCinemaCollectionView.constant = 56
        heightOfThirdCinemaCollectionView.constant = 56
        
        dayCalendarCollectionView.layoutIfNeeded()
        firstCinemaCollectionView.layoutIfNeeded()
        secondCinemaCollectionView.layoutIfNeeded()
        thirdCinemaCollectionView.layoutIfNeeded()
    }
    
    private func setDataSourceAndDelegate()
    {
        dayCalendarCollectionView.dataSource = self
        dayCalendarCollectionView.delegate = self
        
        firstCinemaCollectionView.dataSource = self
        firstCinemaCollectionView.delegate = self
        
        secondCinemaCollectionView.dataSource = self
        secondCinemaCollectionView.delegate = self
        
        thirdCinemaCollectionView.dataSource = self
        thirdCinemaCollectionView.delegate = self
    }
    
    private func registerCells()
    {
        dayCalendarCollectionView.registerCustomCells(identifier: DayCollectionViewCell.identifier)
        firstCinemaCollectionView.registerCustomCells(identifier: TimeShowerCollectionViewCell.identifier)
        secondCinemaCollectionView.registerCustomCells(identifier: TimeShowerCollectionViewCell.identifier)
        thirdCinemaCollectionView.registerCustomCells(identifier: TimeShowerCollectionViewCell.identifier)
    }
}

//MARK: Binding the cinemas to each respective list of timeslots

extension MovieShowTimeViewController
{
    func fetchTheCinemaAndDaySlots(bookingDate:String)
    {
        padcShared.fetchTheCinemaTimeSlots(bookingDate: bookingDate) {
            switch $0
            {
            case.success(let listOfCinemaTimeSlots):
                listOfCinemaTimeSlots.forEach {
                    cinema in
                    self.mapTheCinemaWithTheListOfTimeSlots(cinemaName: cinema.cinema ?? "", listOfTimeSlots: cinema.timeSlots ?? Array<TimeSlot>()) //MARK: For displaying data in this vc
                    
                    self.mapTheTimeSlotWithCiema(listOfTimeSlots: cinema.timeSlots ?? Array<TimeSlot>(), cinemaName: cinema.cinema ?? "") //MARK: For Displaying Data in the upcoming VC
                    
                    self.mapTheTimeSlotWithTheCinemaID(timeSlots: cinema.timeSlots ?? Array<TimeSlot>(), cinemaID: cinema.cinemaID ?? 0)
                    
                    cinema.timeSlots?.forEach({
                        self.mapTheTimeSlotIDWithStartTime(timeSlotID: $0.cinemaDayTimeSlotID ?? 0, startTime: $0.startTime ?? "")
                    })
                }
                self.extractTheTimeSlotsFromTheCinema()
                
            case.failure(let errorMessage):
                debugPrint("\(errorMessage) >> is the Error That Has Occured.")
            }
        }

      
    }
}

//MARK: Extracting the lists of timeSlots from the cinemas and storing those lists in respective variable

extension MovieShowTimeViewController
{
    func extractTheTimeSlotsFromTheCinema()
    {
        guard let listOfTimeSlots = cinemaByTimeSlots["Cinema I"] else {
            debugPrint("No Cinema I")
            return
        }
        
        firstCinemaTimeSlots = listOfTimeSlots.map({
            $0.toCustomTimeSlot()
        })

        guard let listOfTimeSlotsForSecondCinema = cinemaByTimeSlots["Cinema II"] else {
            return
        }

        secondCinemaTimeSlots = listOfTimeSlotsForSecondCinema.map({
            $0.toCustomTimeSlot()
        })

        guard let listOfTimeSlotsForThirdCinema = cinemaByTimeSlots["Cinema III"] else {
            return
        }

        thirdCinemaTimeSlots = listOfTimeSlotsForThirdCinema.map({ $0.toCustomTimeSlot()
        })
    }
}

//MARK: Mapping Procedures

extension MovieShowTimeViewController
{
    func mapTheCinemaWithTheListOfTimeSlots(cinemaName:String,listOfTimeSlots:Array<TimeSlot>)
    {
        self.cinemaByTimeSlots[cinemaName] = listOfTimeSlots
    }
    
    func mapTheTimeSlotWithCiema(listOfTimeSlots:Array<TimeSlot>,cinemaName:String)
    {
        listOfTimeSlots.forEach {
            self.timeSlotMappingCinema[$0.cinemaDayTimeSlotID ?? 0] = cinemaName
        }
    }
    
    func mapTheTimeSlotIDWithStartTime(timeSlotID:Int,startTime:String)
    {
        timeSlotIDMappingStartTime[timeSlotID] = startTime
    }
    
    func mapTheTimeSlotWithTheCinemaID(timeSlots:Array<TimeSlot>,cinemaID:Int)
    {
        timeSlots.forEach {
            timeSlotMappingCinemaID[$0.cinemaDayTimeSlotID ?? 0] = cinemaID
        }
    }
}

extension MovieShowTimeViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dayCalendarCollectionView
        {
            return customDateTime.count
            
        }else if collectionView == firstCinemaCollectionView
        {
            return firstCinemaTimeSlots?.count ?? 0
        }
        else if collectionView == thirdCinemaCollectionView
        {
            return thirdCinemaTimeSlots?.count ?? 0
        }
        else
        {
            return secondCinemaTimeSlots?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == dayCalendarCollectionView{
            let cell = dayCalendarCollectionView.bindCustomCellToTheChambers(identifier: DayCollectionViewCell.identifier, indexPath: indexPath) as DayCollectionViewCell
            
//            cell.bindDataToTheCell(dayVOS: dummyDayList[indexPath.row])
//            cell.dayCalender = dummyDayList[indexPath.row]
            
            cell.customDayCalendar = customDateTime[indexPath.row]
            
            cell.onTabDayDate =
            {
                onTabDate,ontabDay in
                self.bookingDate = onTabDate
                self.setupCinemaBookingDate(bookingDate: onTabDate)
                for eachDate in self.customDateTime
                {
                    if ontabDay == eachDate.day
                    {
                        eachDate.isSelected = true
                    } else
                    {
                        eachDate.isSelected = false
                    }
                }
                self.dayCalendarCollectionView.reloadData()
            }
            
            return cell
        } else if collectionView == firstCinemaCollectionView
        {
            let cell = firstCinemaCollectionView.bindCustomCellToTheChambers(identifier: TimeShowerCollectionViewCell.identifier, indexPath: indexPath) as TimeShowerCollectionViewCell
            cell.customTimeSlot = firstCinemaTimeSlots?[indexPath.row]
            cell.onTabTimeSlot = {
                self.resetUpTheCollectionView(timeSlotID: $0)
                self.timeSlotThatUserTabbed = $0
                self.idForCinema = self.timeSlotMappingCinemaID[$0]!
                self.setUpCinemaIdForUserDefault(cinemaID: self.idForCinema)
            }
            return cell
        }
        else if collectionView == secondCinemaCollectionView
        {
            let cell = collectionView.bindCustomCellToTheChambers(identifier: TimeShowerCollectionViewCell.identifier, indexPath: indexPath) as TimeShowerCollectionViewCell
            cell.customTimeSlot = secondCinemaTimeSlots?[indexPath.row]
            cell.onTabTimeSlot = {
                self.resetUpTheCollectionView(timeSlotID: $0)
                self.timeSlotThatUserTabbed = $0
                self.idForCinema = self.timeSlotMappingCinemaID[$0]!
                self.setUpCinemaIdForUserDefault(cinemaID: self.idForCinema)
            }
           
            return cell
        }
        else
        {
            let cell = thirdCinemaCollectionView.bindCustomCellToTheChambers(identifier: TimeShowerCollectionViewCell.identifier, indexPath: indexPath) as TimeShowerCollectionViewCell
            cell.customTimeSlot = thirdCinemaTimeSlots?[indexPath.row]
            cell.onTabTimeSlot = {
                self.resetUpTheCollectionView(timeSlotID: $0)
                self.timeSlotThatUserTabbed = $0
                self.idForCinema = self.timeSlotMappingCinemaID[$0]!
                self.setUpCinemaIdForUserDefault(cinemaID: self.idForCinema)
            }
            return cell
        }
        
    }
    
    func setupCinemaBookingDate(bookingDate:String)
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(bookingDate, forKey: "cinemaBookingDate")
    }
    
    func setUpCinemaIdForUserDefault(cinemaID:Int)
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(cinemaID, forKey: "cinemaID")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            if collectionView == dayCalendarCollectionView
        {
              return CGSize(width: 60, height: 84)
        }
        else if collectionView == firstCinemaCollectionView
        {
            let width = collectionView.bounds.width/3
            let height = CGFloat(48)
            
            return CGSize(width: width, height: height)
        } else
        {
            let width = collectionView.bounds.width/3
            let height = CGFloat(48)
            
            return CGSize(width: width, height: height)
        }
        
    }
}

extension MovieShowTimeViewController:MovieAppDelegate
{
    func navigateToMovieList() {
       navigateToViewController(identifier: MOVIE_SEAT_VIEW_CONTROLLER)
    }
    
    func resetUpTheCollectionView(timeSlotID:Int)
    {
        self.firstCinemaTimeSlots?.forEach {
            timeslot in
            if timeSlotID == timeslot.cinemaTimeSlotID
            {
                timeslot.isSelected = true
            } else {
                timeslot.isSelected = false
            }
        }
        self.firstCinemaCollectionView.reloadData()
        
        self.secondCinemaTimeSlots?.forEach {
            if timeSlotID == $0.cinemaTimeSlotID
            {
                $0.isSelected = true
            } else {
                $0.isSelected = false
            }
        }
        
        self.secondCinemaCollectionView.reloadData()
        
        self.thirdCinemaTimeSlots?.forEach {
            if timeSlotID == $0.cinemaTimeSlotID
            {
                $0.isSelected = true
            } else {
                $0.isSelected = false
            }
        }
        self.thirdCinemaCollectionView.reloadData()
        
        setupDaySlotIDForFurtherUse(timeslotID: timeSlotID)
    }
    
}

extension MovieShowTimeViewController
{
    private func setDelegate()
    {
        self.movieAppDele = self
    }
    
    func setupDaySlotIDForFurtherUse(timeslotID:Int)
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(timeslotID, forKey: "timeSlotID")
    }
}

