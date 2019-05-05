//
//  IdentifiableObject.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxOptional

protocol IdentifiableObject {
    associatedtype Identity: Hashable
    var id: Identity { get set }
}

extension IdentifiableObject where Self: Object {
    static func first(id: Self.Identity) -> Self? {
        return DataHelper.first(type: self, filter: NSPredicate(format: "id == \(id)"))
    }
    
    static func object(id: Self.Identity) -> Observable<Self> {
        return DataHelper
            .observableObjects(type: self, filter: NSPredicate(format: "id == \(id)"))
            .map { $0.first }
            .filterNil()
    }
}

