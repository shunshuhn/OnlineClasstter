//
//  PostTableViewCell.swift
//  OnlineClasstter
//
//  Created by 伊藤　陽香 on 2020/10/05.
//  Copyright © 2020 伊藤　陽香. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setValue(_ post: Post) {
        nameLabel.text = post.userName
        dateLabel.text = formatter.string(from: post.createdAt)
        contentLabel.text = post.content
    }
}
