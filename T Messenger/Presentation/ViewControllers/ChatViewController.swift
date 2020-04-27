//
//  ChatViewController.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var messageInputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    static var channel: ChannelStruct?

    private let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""

    private lazy var frc: NSFetchedResultsController<Message> = storageManager.getFetchedResultsController(from: ChatViewController.channel)

    private lazy var notificationMethods: NotificationMethods = NotificationMethods(for: self)
    private lazy var conversationService: ConversationService = FirebaseService()
    private lazy var storageManager: StorageManagerProtocol = StorageManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        storageManager.fetchMessages(from: ChatViewController.channel) { [weak self] error in
            print("fetchMessages : \(error?.localizedDescription ?? "OK")")
            self?.scrollToBottom()
        }

        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Can't fetch from current context")
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
        let message = MessageStruct(content: messageInputTextField.text, senderName: conversationService.getUserName())
        conversationService.send(message: message, to: ChatViewController.channel)
        messageInputTextField.text = ""
        changeSendButtonState(to: false)
    }

    // MARK: - Notification Methods

    @objc func keyboardWillChange(_ notification: Notification) {
        notificationMethods.keyboardWillChange(notification)
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
        let messageCount = tableView(conversationTableView, numberOfRowsInSection: 0) - 1
        guard messageCount > 0 else { return }
        self.conversationTableView.scrollToRow(at: IndexPath(row: messageCount, section: 0), at: .bottom, animated: false)
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
        return frc.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = frc.object(at: indexPath)

        let identifier = senderIsUser(senderId: message.senderId ?? "") ? "outMessageCell" : "inMessageCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageCell
            else { fatalError("MessageCell cannot be dequeued") }

        cell.configure(with: message)

        return cell
    }

}

// MARK: - NSFetchedResultsControllerDelegate

extension ChatViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationTableView.endUpdates()
        scrollToBottom()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        guard let newIndexPath = newIndexPath else {
            print("FetchedResultsController can't update object")
            return
        }

        if type == .insert {
            conversationTableView.insertRows(at: [newIndexPath], with: .none)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        if type == .insert {
            conversationTableView.insertSections(IndexSet(integer: sectionIndex), with: .none)
        }
    }
}
