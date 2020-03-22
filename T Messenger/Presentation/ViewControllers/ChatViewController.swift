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
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var messageInputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    static var channel: Channel?
    
    private let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""

    private var notificationMethods: NotificationMethods!
    private var conversationService: ConversationService!
    private var messages: [Message]?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationMethods = NotificationMethods(for: self)

        conversationService = FirebaseService()

        conversationService.fetchMessages(from: ChatViewController.channel) { [weak self] messages in
            self?.messages = messages
            self?.conversationTableView.reloadData()
            self?.scrollToBottom()
        }

        messageInputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        self.navigationItem.title = ChatViewController.channel?.name ?? "Unknown channel name"

        sendButton.layer.cornerRadius = 10.0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Button Actions

    @IBAction func sendButtonPressed(_ sender: Any) {
        let message = Message(created: Date(), content: messageInputTextField.text, senderName: conversationService.getUserName(), senderId: deviceId)
        conversationService.send(message: message, to: ChatViewController.channel)
        messageInputTextField.text = ""
        changeSendButtonState(to: false)
        dismissKeyboard()
    }

    // MARK: - Notification Methods

    @objc func keyboardWillChange(_ notification: Notification) {
        notificationMethods.keyboardWillChange(notification)
        scrollToBottom()
    }

    // MARK: - Gesture Methods

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Target Methods

    @objc func textFieldDidChange(_ textField: UITextField) {
        let messageContent = messageInputTextField.text ?? ""
        changeSendButtonState(to: !messageContent.filter({ $0 != " " }).isEmpty)
    }

    // MARK: - Private Methods

    private func scrollToBottom() {
        if let msgs = messages, !msgs.isEmpty {
            self.conversationTableView.scrollToRow(at: IndexPath(row: msgs.count - 1, section: 0), at: .bottom, animated: false)
        }
    }

    private func changeSendButtonState(to isEnabled: Bool) {
        sendButton.isEnabled = isEnabled
        sendButton.backgroundColor = isEnabled ? .blue : .systemGray
    }

    private func senderIsUser(senderId: String) -> Bool {
        return senderId == deviceId
    }

}

// MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = senderIsUser(senderId: messages?[indexPath.row].senderId ?? "") ? "outMessageCell" : "inMessageCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageCell
            else { fatalError("MessageCell cannot be dequeued") }

        cell.configure(with: messages?[indexPath.row])

        return cell
    }

}
