//
//  AllChannels+TableView.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit
import CoreData

// MARK: - UITableViewDelegate

extension AllChannelsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = frc.object(at: indexPath)
        ChannelViewController.channel = ChannelStruct(channel)
        self.navigationController?.pushViewController(presentationAssembly.channelViewController(), animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = frc.object(at: indexPath).identifier ?? ""
            model.removeChannel(id: id)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

}

// MARK: - NSFetchedResultsControllerDelegate

extension AllChannelsViewController: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        allChannelsTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        allChannelsTableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                print("FetchedResultsController can't insert object")
                return
            }
            allChannelsTableView.insertRows(at: [newIndexPath], with: .none)
        case .delete:
            guard let indexPath = indexPath else {
                print("FetchedResultsController can't delete object")
                return
            }
            allChannelsTableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else {
                print("FetchedResultsController can't update object")
                return
            }
            allChannelsTableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {
                print("FetchedResultsController can't update object")
                return
            }
            allChannelsTableView.insertRows(at: [newIndexPath], with: .fade)
            allChannelsTableView.deleteRows(at: [indexPath], with: .fade)
        @unknown default:
            fatalError("Unsupported NSFetchedResultsChangeType")
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