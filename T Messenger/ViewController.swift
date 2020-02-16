//
//  ViewController.swift
//  T Messenger
//
//  Created by Suspect on 14.02.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    #if PRINT_VC_STATES
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            print("ViewController moved from <Disappeared> to <Appearing>: \(#function)")
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            print("ViewController moved from <Appearing> to <Appeared>: \(#function)")
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()

            print("ViewController's subview update starts: \(#function)")
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            print("ViewController's subview update ends: \(#function)")
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            print("ViewController moved from <Appeared> to <Disappearing>: \(#function)")
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)

            print("ViewController moved from <Disappearing> to <Disappeared>: \(#function)")
        }
    #endif


}

