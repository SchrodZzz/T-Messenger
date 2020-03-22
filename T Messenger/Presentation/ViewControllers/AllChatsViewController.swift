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

    @IBOutlet weak var allChannelsTableView: UITableView!
    @IBOutlet weak var addChatButton: UIBarButtonItem!

    private var conversationService: ConversationService!
    private var channels: Channels?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        conversationService = FirebaseService()

        conversationService.fetchChannels { [weak self] channels in
            self?.channels = Channels(from: channels)
            self?.allChannelsTableView.reloadData()
        }
    }

    // MARK: - Button Actions

    @IBAction func addChatButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Create new channel", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input channel name here..."
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if let name = alert.textFields?.first?.text {
                self.conversationService.create(channel: Channel(name: name))
            }
        })

        self.present(alert, animated: true)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AllChatsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels?.getChannels(for: section)?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return channels?.getTypeHeader(for: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell
            else { fatalError("ChatCell cannot be dequeued") }

        if let channel = channels?.getChannels(for: indexPath.section)?[indexPath.row] {
            cell.configure(with: channel)
        }

        if indexPath.section == 0 {
            cell.layer.backgroundColor = UIColor(rgb: 0xFFEE99).cgColor
        } else {
            cell.layer.backgroundColor = UIColor.white.cgColor
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channel = channels?.getChannels(for: indexPath.section)?[indexPath.row] else { return }
        ChatViewController.channel = channel
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

}
