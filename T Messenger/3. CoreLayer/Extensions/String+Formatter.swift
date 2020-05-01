//
//  String+Formatter.swift
//  T Messenger
//
//  Created by Suspect on 01.05.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

extension String {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
