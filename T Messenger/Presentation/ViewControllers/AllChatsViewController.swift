//
//  AllChatsViewController.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class AllChatsViewController: UIViewController {

    // MARK: - Proporties

    @IBOutlet weak var conversationListTableView: UITableView!

    private var conversations: [[MockConversation]]?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        conversations = MockDataFiller.getConversationsList()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AllChatsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?[section].count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Online" : "History"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell
            else { fatalError("ChatCell cannot be dequeued") }

        if let conversation = conversations?[indexPath.section][indexPath.row] {
            cell.configure(with: conversation)
        }

        if indexPath.section == 0 {
            cell.layer.backgroundColor = UIColor(rgb: 0xFFEE99).cgColor
        } else {
            cell.layer.backgroundColor = UIColor.white.cgColor
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversation = conversations?[indexPath.section][indexPath.row] else { return }
        ChatViewController.name = conversation.name
        ChatViewController.massages = conversation.messages
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

}
