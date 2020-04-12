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