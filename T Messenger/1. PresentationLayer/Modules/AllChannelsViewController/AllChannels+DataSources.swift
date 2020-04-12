//
//  AllChats+FetchedResultsController.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

extension AllChannelsViewController: UITableViewDataSource {

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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
