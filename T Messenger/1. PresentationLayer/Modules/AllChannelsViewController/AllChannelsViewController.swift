//
//  AllChatsViewController.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit
import CoreData

class AllChannelsViewController: UIViewController {

    // MARK: - Proporties

    @IBOutlet weak var allChannelsTableView: UITableView!
    @IBOutlet weak var addChatButton: UIBarButtonItem!

    let presentationAssembly: IPresentationAssembly
    let model: IAllChannelsModel

    lazy var frc: NSFetchedResultsController<Channel> = model.getFetchedResultsController()

    // MARK: - Initialization

    init(model: IAllChannelsModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.fetchChannels()

        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Can't fetch from current context")
        }
    }

    // MARK: - Button Actions

    @IBAction func addChatButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Create new channel", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter channel name here..."
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if let name = alert.textFields?.first?.text {
                self.model.createChannel(named: name)
            }
        })

        self.present(alert, animated: true)
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        self.present(presentationAssembly.profileViewController(), animated: true, completion: nil)
    }

}
