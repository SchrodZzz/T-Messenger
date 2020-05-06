//
//  Channel+FetchedResultsController.swift
//  T Messenger
//
//  Created by Suspect on 12.04.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

extension ChannelViewController: UITableViewDataSource {

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
