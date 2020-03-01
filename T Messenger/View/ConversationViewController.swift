//
//  ConversationViewController.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var ConversationTableView: UITableView!
    
    
    static var massages: [String]?
    static var name: String?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ConversationViewController.name ?? "Name"
    }

    //MARK: - Private Methods
    private func getMagic(from num: Int) -> Bool {
        return num % 2 == 0 && num < 5
    }

}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationViewController.massages?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ConversationCell

        if getMagic(from: indexPath.row) {
            cell = tableView.dequeueReusableCell(withIdentifier: "inMessageCell", for: indexPath) as! ConversationCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "outMessageCell", for: indexPath) as! ConversationCell
        }
        
        cell.configure(with: MessageCellModel(text: ConversationViewController.massages?[indexPath.row] ?? ""))

        return cell
    }

}
