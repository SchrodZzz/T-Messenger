//
//  Date+Formatter.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()

        if Calendar.current.isDateInToday(self) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM"
        }

        return dateFormatter.string(from: self)
    }
    
    func minutes(sinceDate: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute ?? 0
    }
}
