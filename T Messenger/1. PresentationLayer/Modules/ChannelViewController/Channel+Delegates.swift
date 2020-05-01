//
//  Channel+TableView.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit
import CoreData

// MARK: - NSFetchedResultsControllerDelegate

extension ChannelViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        channelTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        channelTableView.endUpdates()
        scrollToBottom()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        guard let newIndexPath = newIndexPath else {
            Notificator.notifyUser("FetchedResultsController can't update object", type: .error, in: self)
            return
        }

        if type == .insert {
            channelTableView.insertRows(at: [newIndexPath], with: .none)
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        if type == .insert {
            channelTableView.insertSections(IndexSet(integer: sectionIndex), with: .none)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ChannelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

// MARK: - IChannelModelDelegate

extension ChannelViewController: IChannelModelDelegate {
    func show(error message: String) {
        Notificator.notifyUser(message, type: .error, in: self)
    }
}
