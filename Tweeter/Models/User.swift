//
//  User.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var userId: String = ""
}
