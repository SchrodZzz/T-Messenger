//
//  ChatCell.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    @IBOutlet weak var lastMessageContentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - ConfigurableView protocol implementation

extension ChatCell: ConfigurableView {

    func configure(with model: Channel) {
        nameLabel.text = model.name ?? "Unknown Name"
        lastMessageDateLabel.text = model.lastActivity?.toString() ?? "XX:xx"

        if let lastMessageContent = model.lastMessage, !lastMessageContent.isEmpty {
            lastMessageContentLabel.text = lastMessageContent
        } else {
            lastMessageContentLabel.text = "No messages yet"
        }

        #warning("TODO: wait for 'registration' server implementation")
//        if model.hasUnreadMessages {
//            lastMessageBodyLabel.font = UIFont.boldSystemFont(ofSize: 16)
//        } else {
//            lastMessageBodyLabel.font = UIFont.systemFont(ofSize: 16)
//        }

    }

}
