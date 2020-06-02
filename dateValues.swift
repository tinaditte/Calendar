//
//  dateValues.swift
//  Strandparken_portal
//
//  Created by Tina Thomsen on 02/06/2020.
//  Copyright © 2020 Tina Thomsen. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
var week = calendar.component(.weekday, from: date)
var month =  calendar.component(.month, from: date)  - 1
var year  = calendar.component(.year, from: date)



