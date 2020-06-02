//
//  CalendarViewController.swift
//  Strandparken_portal
//
//  Created by Tina Thomsen on 02/06/2020.
//  Copyright © 2020 Tina Thomsen. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	@IBOutlet weak var calendarView: UICollectionView!
	@IBOutlet weak var yearLabel: UILabel!
	
	let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
	let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	let daysInMonthleapYear = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	
	var currentMonth = String()
	var currentYear = year
	
	var numberOfEmptyBoxes = Int() //Number of empty boxes before start date of current month
	var nextNumberOfEmptyBoxes = Int() //Amount of empty boxes before start date of the next month
	var preNumberOfEmptyBoxes = 0 //Amount of boxes before start date of the previous month
	var direction = 0 // = 0 if we are the current month, -1 if we are in the previous month, 1 if we are in the next month
	var posIndex = 0 // the position determining where we 'travel' Will store the values of above
	var dayCounter = 0
	
	//_______________________________FUNCTIONS_________________________________________
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		currentMonth = Months[month]
		yearLabel.text = "\(currentMonth) \(year) "
		
		if week == 0{
			week = 7
		}
		startDateWeekDayPos()
    }
	
	func isLeapYear(year: Int)->Bool{
		
		if year % 400 == 0{
			return true
		}else if year % 100 == 0{
			return true
		}else if year % 4 == 0{
			return true
		}
		return false
	}
	
	func startDateWeekDayPos(){		//Function to determine the amount of empty boxes
		switch direction {
		case 0:										//Case: Current month
			numberOfEmptyBoxes = week
			dayCounter = day
			
			while dayCounter > 0 {
				numberOfEmptyBoxes -= 1
				dayCounter -= 1
				if numberOfEmptyBoxes == 0{
					numberOfEmptyBoxes = 7
				}
			}
			if numberOfEmptyBoxes == 7{
				numberOfEmptyBoxes = 0
			}
			posIndex = numberOfEmptyBoxes
		case 1...:						//Case: Future month
			if isLeapYear(year: currentYear){
			nextNumberOfEmptyBoxes = (posIndex + daysInMonthleapYear [month]) % 7
			}else{
				nextNumberOfEmptyBoxes = (posIndex + daysInMonth[month]) % 7
			}
			posIndex = nextNumberOfEmptyBoxes
		case -1:						//Case: past month
			if isLeapYear(year: currentYear){
				preNumberOfEmptyBoxes = (7 - (daysInMonthleapYear[month] - posIndex)%7)
			}else{
				preNumberOfEmptyBoxes = (7 - (daysInMonth[month] - posIndex)%7)
			}
			if preNumberOfEmptyBoxes == 7{
				preNumberOfEmptyBoxes = 0
			}
			posIndex = preNumberOfEmptyBoxes
		default:
			fatalError()
		}
	}
	
	checkForEvent
	
	//___________________________________ACTIONS______________________________________________
	
	@IBAction func preTapped(_ sender: Any) {
		switch currentMonth{
		case "January":
			direction = -1
			month = 11
			year -= 1
			
			startDateWeekDayPos()
			
			currentMonth = Months[month]
			yearLabel.text = "\(currentMonth) \(year) "
			calendarView.reloadData()
		default:
			month -= 1
			direction = -1
			
			startDateWeekDayPos()
			
			currentMonth = Months[month]
			yearLabel.text = "\(currentMonth) \(year)"
			calendarView.reloadData()
		}
	}

	@IBAction func nextTapped(_ sender: Any) {
		switch currentMonth{
		case "December":
			month = 0
			year += 1
			direction = 1
			
			startDateWeekDayPos()
			
			currentMonth = Months[month]
			yearLabel.text = "\(currentMonth) \(year) "
			calendarView.reloadData()
		default:
			direction = 1
			
			startDateWeekDayPos()
			
			month += 1
			currentMonth = Months[month]
			yearLabel.text = "\(currentMonth) \(year) "
			calendarView.reloadData()
		}
	}
	
	//_____________________________COLLECTIONVIEW___________________________________________
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch direction {			//returning the number of -days in month- and its -empty boxes- based on the direction
		case 0:
			if isLeapYear(year: currentYear) == true{ return daysInMonthleapYear[month] + numberOfEmptyBoxes
			}else{ return daysInMonth[month] + numberOfEmptyBoxes }
		
		case 1...:
			if isLeapYear(year: currentYear) == true { return daysInMonthleapYear[month] + nextNumberOfEmptyBoxes
			}else{ return daysInMonth[month] + nextNumberOfEmptyBoxes }
		
		case -1:
			if isLeapYear(year: currentYear) == true{ return daysInMonthleapYear[month] + preNumberOfEmptyBoxes
		}else{ return daysInMonth[month] + preNumberOfEmptyBoxes }
			
		default:
			fatalError()
		}
	}
		
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath) as! CalendarCollectionViewCell
		cell.backgroundColor = UIColor.clear
		cell.dateLabel.textColor = UIColor.black
		
		if cell.isHidden{
			cell.isHidden = false
		}
		
		switch direction {			//Start the date at a weekday based on month
		case 0:
			cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBoxes)"
		case 1...:
			cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBoxes)"
		case -1:
			cell.dateLabel.text = "\(indexPath.row + 1 - preNumberOfEmptyBoxes)"
		default:
			fatalError()
		}
		
		if Int(cell.dateLabel.text!)! < 1{ //To hide cell text that isn't above 1
			cell.isHidden = true
		}
		
		//Show weekend in different color
		switch indexPath.row {
		case 5, 6, 12, 13, 19, 20, 26, 27, 33, 34:			//The indexes of the collectionview that matches with the weekend days
			if Int(cell.dateLabel.text!)! > 0 {
				cell.dateLabel.textColor = UIColor.lightGray
			}
		default:
			break
		}
		//marks the cell that shows the current date
		if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 == day{
			cell.dateLabel.textColor = UIColor.red
		}
		return cell
		}
}
