//
//  DateFormat.swift
//  Strandparken
//
//  Created by Tina Thomsen on 31/05/2020.
//  Copyright © 2020 Tina Thomsen. All rights reserved.
//

import Foundation
import Firebase

class DateFormat {
	
	static func dateFormatter(Date: Date)-> String{
		let format = DateFormatter()
		format.dateFormat = "yyyy-MM-dd HH:mm"
		let formattedDate = format.string(from: Date)
		return formattedDate
	}
	
	static func getYear(Date: Date) -> String{
		let format = DateFormatter()
		format.dateFormat = "yyyy"
		let formattedDate = format.string(from: Date)
		return formattedDate
	}
	
	static func getMonth(Date: Date) -> String{
		let format = DateFormatter()
		format.dateFormat = "MM"
		let formattedDate = format.string(from: Date)
		return formattedDate
	}
	
}
