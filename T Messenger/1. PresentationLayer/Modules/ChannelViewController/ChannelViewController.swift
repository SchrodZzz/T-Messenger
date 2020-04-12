//
//  ChatViewController.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit
import CoreData

class ChannelViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var messageInputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    static var channel: ChannelStruct?

    let presentationAssembly: IPresentationAssembly
    let model: IChannelModel

    lazy var frc: NSFetchedResultsController<Message> = model.getFetchedResultsController(fromChannel: ChannelViewController.channel?.identifier)

    private let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
    private lazy var notificationMethods: NotificationMethods = NotificationMethods(for: self)

    // MARK: - Initialization

    init(model: IChannelModel, presentationAssembly: IPresentationAssembly) {
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

        model.fetchMessages(fromChannel: ChannelViewController.channel?.identifier ?? "") { [weak self] in
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

        self.navigationItem.title = ChannelViewController.channel?.name ?? "Unknown channel name"

        sendButton.layer.cornerRadius = 10.0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Button Actions

    @IBAction func sendButtonPressed(_ sender: Any) {
        model.sendMessage(content: messageInputTextField.text, toChannel: ChannelViewController.channel?.identifier)
        messageInputTextField.text = ""
        changeSendButtonState(to: false)
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

    // MARK: - Methods

    func scrollToBottom() {
        let messageCount = tableView(conversationTableView, numberOfRowsInSection: 0) - 1
        guard messageCount > 0 else { return }
        self.conversationTableView.scrollToRow(at: IndexPath(row: messageCount, section: 0), at: .bottom, animated: false)
    }

    func senderIsUser(senderId: String) -> Bool {
        return senderId == deviceId
    }

    // MARK: - Private Methods

    private func changeSendButtonState(to isEnabled: Bool) {
        sendButton.isEnabled = isEnabled
        sendButton.backgroundColor = isEnabled ? .blue : .systemGray
    }

}

// MARK: - UITextFieldDelegate

extension ChannelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}