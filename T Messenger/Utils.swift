//
//  Utils.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

class Utils {

    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()

        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM"
        }

        return dateFormatter.string(from: date)
    }

}
