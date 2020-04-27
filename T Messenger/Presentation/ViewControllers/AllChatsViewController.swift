//
//  AllChatsViewController.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit
import CoreData

class AllChatsViewController: UIViewController {

    // MARK: - Proporties

    @IBOutlet weak var allChannelsTableView: UITableView!
    @IBOutlet weak var addChatButton: UIBarButtonItem!

    private lazy var frc: NSFetchedResultsController<Channel> = storageManager.getFetchedResultsController()

    private lazy var conversationService: ConversationService = FirebaseService()
    private lazy var storageManager: StorageManagerProtocol = StorageManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        storageManager.fetchChannels { error in
            print("fetchChannels : \(error?.localizedDescription ?? "OK")")
        }

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
                self.conversationService.create(channel: ChannelStruct(name: name))
            }
        })

        self.present(alert, animated: true)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AllChatsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let channels = frc.sections?[section], channels.numberOfObjects > 0 else { return nil }
        let sectionContainsActiveChannels = frc.object(at: IndexPath(row: 0, section: section)).isActive
        if sectionContainsActiveChannels {
            return "Active"
        } else {
            return "Inactive"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell
            else { fatalError("ChatCell cannot be dequeued") }

        let channel = frc.object(at: indexPath)
        cell.configure(with: channel)

        if channel.isActive {
            cell.layer.backgroundColor = UIColor(rgb: 0xFFEE99).cgColor
        } else {
            cell.layer.backgroundColor = UIColor.white.cgColor
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = frc.object(at: indexPath)
        ChatViewController.channel = ChannelStruct(channel)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            conversationService.removeChannel(with: frc.object(at: indexPath).identifier)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

}

// MARK: - NSFetchedResultsControllerDelegate

extension AllChatsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        allChannelsTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        allChannelsTableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        if type == .insert {
            guard let newIndexPath = newIndexPath else {
                print("FetchedResultsController can't insert object")
                return
            }
            allChannelsTableView.insertRows(at: [newIndexPath], with: .none)
        } else if type == .delete {
            guard let indexPath = indexPath else {
                print("FetchedResultsController can't delete object")
                return
            }
            allChannelsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        if type == .insert {
            allChannelsTableView.insertSections(IndexSet(integer: sectionIndex), with: .none)
        } else if type == .delete {
            allChannelsTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        }
    }
}
