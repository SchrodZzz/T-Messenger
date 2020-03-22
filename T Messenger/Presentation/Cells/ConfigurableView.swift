//
//  ConfigurableView.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import Foundation

protocol ConfigurableView {

    associatedtype ConfigurationModel

    func configure(with model: ConfigurationModel)
}
