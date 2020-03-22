//
//  ConversationCell.swift
//  T Messenger
//
//  Created by Suspect on 01.03.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageView.layer.cornerRadius = 10.0
        messageLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ConversationCell: ConfigurableView {

    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
    }

}
