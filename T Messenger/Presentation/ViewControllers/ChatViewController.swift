//
//  ChatViewController.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var ConversationTableView: UITableView!

    static var massages: [String]?
    static var name: String?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ChatViewController.name ?? "Name"
    }

    // MARK: - Private Methods

    private func getMagic(from num: Int) -> Bool {
        return num % 2 == 0 && num < 5
    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatViewController.massages?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = getMagic(from: indexPath.row) ? "inMessageCell" : "outMessageCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageCell
            else { fatalError("MessageCell cannot be dequeued") }

        cell.configure(with: MessageCellModel(text: ChatViewController.massages?[indexPath.row] ?? ""))

        return cell
    }

}
