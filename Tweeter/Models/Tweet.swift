//
//  Tweet.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Tweet: Object {
    
    @objc dynamic var creator: User?
    @objc dynamic var content: String = ""
    @objc dynamic var createdAt: Date = Date()
    
}
