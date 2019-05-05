//
//  UIView+Extensions.swift
//  Tweeter
//
//  Created by DUYLINH on 5/3/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import UIKit

extension UIView {
    
    func rounded(_ cornerRadius:CGFloat = 5) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
