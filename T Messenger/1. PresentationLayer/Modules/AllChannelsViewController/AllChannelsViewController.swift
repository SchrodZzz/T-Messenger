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

    let presentationAssembly: IPresentationAssembly
    var model: IAllChannelsModel

    lazy var frc: NSFetchedResultsController<Channel> = model.getFetchedResultsController()

    // MARK: - Initialization

    init(model: IAllChannelsModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: "AllChannels", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
        allChannelsTableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")

        adjustNavigationBar()
        model.fetchChannels()

        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            Notificator.notifyUser("Can't fetch from current context", type: .error, in: self)
        }
    }

    // MARK: - Private methods

    @objc func addChannelButtonPressed(_ sender: Any) {
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

    @objc func profileButtonPressed(_ sender: Any) {
        self.present(presentationAssembly.profileViewController(), animated: true, completion: nil)
    }

    private func adjustNavigationBar() {
        title = "Tinkoff Chat"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "All Chats", style: .plain, target: nil, action: nil)
        if let topItem = navigationController?.navigationBar.topItem {
            let profileButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileButtonPressed))
            let addChannelButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChannelButtonPressed))
            topItem.leftBarButtonItem = profileButton
            topItem.rightBarButtonItem = addChannelButton
        } else {
            fatalError()
        }
    }

}
