//
//  String+Localizable.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import UIKit
import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

//MARK: Menu
extension String {
    
    //Title controller
    static var tl_tweet_list : String { return "tweeter".localized }
    static var tl_new_tweet : String { return "new_tweeter".localized }
    
    //BarButtonItem
    static var bi_cancel : String { return "cancel".localized }
    static var bi_send_tweet : String { return "tweet".localized }
    
    //UIAlertAction
    static var al_error : String { return "error".localized }
    static var al_cancel : String { return "cancel".localized }
    static var al_ok : String { return "ok".localized }
    
    //Message
    static var msg_tweet_empty : String { return "msg_tweet_empty".localized }
    static var msg_tweet_indicatorLengthExceed : String { return "msg_tweet_indicatorLengthExceed".localized }
    static var msg_tweet_wordLengthExceed : String { return "msg_tweet_wordLengthExceed".localized }
    
    
    //Place holder
    static var pl_what_happen : String { return "what_happen".localized }
    
    
}
