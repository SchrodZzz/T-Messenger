//
//  ConversationListCell.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ConversationListCell: ConfigurableView {

    func configure(with model: MockConversation) {
        dateLabel.text = model.date.dateToString()
        nameLabel.text = model.name

        let messagesCount = model.messages?.count ?? 0
        lastMessageLabel.text = messagesCount == 0
            ? "No messages yet"
            : model.messages?[messagesCount - 1] ?? ""

        if model.hasUnreadMessages {
            lastMessageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            lastMessageLabel.font = UIFont.systemFont(ofSize: 16)
        }

    }

}
