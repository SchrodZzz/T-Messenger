//
//  MessageCell.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageContentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        messageView.layer.cornerRadius = 10.0
        messageContentLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - ConfigurableView protocol implementation

extension MessageCell: ConfigurableView {

    func configure(with model: Message?) {
        nameLabel.text = model?.senderName ?? "Unknown Sender"
        messageContentLabel.text = model?.content ?? "Empty Content"
        dateLabel.text = model?.created?.toString() ?? "XX:xx"
    }

}
