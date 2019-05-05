//
//  TweetCell.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import UIKit
import Differentiator
import SwiftDate

public struct TweetCellModel: Hashable, Equatable {
    let id: Int
    let username: String
    let userId: String
    let createdDate: String
    let message: String
    
    init(tweet: Tweet) {
        self.id = Int(tweet.createdAt.timeIntervalSince1970)
        self.userId = tweet.creator?.userId ?? ""
        self.username = tweet.creator?.name ?? ""
        if tweet.createdAt.compare(.isSameDay(Date())) {
            self.createdDate = tweet.createdAt.toString(DateToStringStyles.custom(Constants.df_hhmm))
        } else {
            self.createdDate = tweet.createdAt.toString(DateToStringStyles.custom(Constants.df_ddmmyyyy))
        }
        self.message = tweet.content
    }
}

extension TweetCellModel: IdentifiableType {
    public typealias Identity = Int
    
    public var identity: Int {
        return self.hashValue
    }
}

final class TweetCell: UITableViewCell {
    
    // MARK: - Properties
    static let ID = "TweetCell"
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetLengthLabel: UILabel!
    
    // MARK: - Overridden: UITableViewCell
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Overridden: UITableViewCell
    func setModel(_ model: TweetCellModel) {
        userIdLabel.text = "@\(model.userId)"
        usernameLabel.text = model.username
        postDateLabel.text = model.createdDate
        tweetLabel.text = model.message
        tweetLengthLabel.text = String(model.message.count)
    }
}

