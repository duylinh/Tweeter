//
//  TweetHelper.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import Foundation
import UIKit

enum TweetValidationError: Error {
    case empty
    case wordLengthExceed(Int)
    case indicatorLengthExceed(Int)
}

extension TweetValidationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty:
            return  String.msg_tweet_empty //"Please enter your message"
            
        case .indicatorLengthExceed:
            return String.msg_tweet_indicatorLengthExceed //"Your message is too long. Please cut it down!"
            
        case .wordLengthExceed(let length):
            return String.localizedStringWithFormat(NSLocalizedString(String.msg_tweet_wordLengthExceed, comment: ""), "\(length)")
        }
    }
}

enum SplitResult {
    case components([TweetComponent])
    case message(String)
}

struct TweetComponent {
    var index: Int
    var total: Int
    var text: String
    var tweet: String {
        return "\(index)/\(total) " + text
    }
}

struct TweetHelper {
    let maxLength: Int
    
    init(maxLength: Int = Constants.max_lenght) {
        self.maxLength = maxLength
    }
    // Length of a message part = Length of indicator and whitespace + Length of text <= 50 (EX: "IndexPart/TotalPart" + " " +  text). But we actually don't know total part. So, I determined total part the following:
    // + The first: Estimate number of digits of total page: K = numberOfDigits(message.count / 50). And then we can calculate length of indicator: indicatorCharacterCount = numberOfDigits(indexPart) + 1 + K + 1 // 1 first is "/" character and 1 second is white space
    // + The Second: Try to split the message with K.
    // + The Third: If we can't split the message (Length of total part is greater than K), we increase K value by 1 (K = K + 1) and try split the message again. If we can't get split return nil, otherwise return list of message parts that is splitted
    func splitTweet(_ tweet: String?) throws -> SplitResult {
        
        // Validate empty tweet
        guard let trimmedTweet = tweet?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmedTweet.isEmpty else {
            throw TweetValidationError.empty
        }
        
        // If length of tweet is less than the maximum count -> just return without index part
        if trimmedTweet.count <= self.maxLength {
            return SplitResult.message(trimmedTweet)
        }
        
        let words = trimmedTweet.components(separatedBy: CharacterSet.whitespaces)
        // Validate if word's length exceed maxLength
        guard (words.filter { $0.count >= maxLength }).isEmpty else {
            throw TweetValidationError.wordLengthExceed(maxLength)
        }
        
        var K = numberOfDigits(trimmedTweet.count / self.maxLength)
        
        // Init variables
        var indexPart = 1
        var subTweets: [String] = []
        
        // Number of characters of indicator and whitespace (EX: "1/1 ")
        var indicatorCharacterCount = numberOfDigits(indexPart) + 1 + K + 1 // 1 first is "/" character and 1 second is white space
        
        // Init indexBegin and indexEnd
        var indexBegin = 0
        var indexEnd = indexBegin + self.maxLength - indicatorCharacterCount
        
        // indexBegin is first index of message that we need to split
        // indexEnd is end index of message that we need to split
        // For example the following message: "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        // The First: indexBegin = 0, indexEnd = indexBegin + 50 - Number of characters of indicator and whitespace ("1/K " = 4) = 46. And then we run from indexEnd to indexBegin to find white space index (indexWhiteSpace) and split the message between indexBegin and indexWhiteSpace
        // The Second: indexBegin = indexWhiteSpace + 1, indexEnd = indexBegin + 50 - Number of characters of indicator and whitespace ("2/K "). The we slit the message like the first step.
        // The Third: indexBegin = indexWhiteSpace + 1, indexEnd = indexBegin + 50 - Number of characters of indicator and whitespace ("3/K "). The we slit the message like the first step.
        // And so on...
        
        while indexEnd < trimmedTweet.count {
            
            var indexWhiteSpace = 0
            var isExcess = true
            
            // we run from indexEnd to indexBegin to find index of the whitespace
            for index in stride(from: indexEnd, to: indexBegin, by: -1) {
                if trimmedTweet[index] == " " {
                    isExcess = false
                    indexWhiteSpace = index
                    break
                }
            }
            
            // Check the message is not excessed yet (less than or equal 50 characters) and split that message
            if !isExcess {
                // Split the message at between indexBegin and indexWhiteSpace
                let messagePart = trimmedTweet[indexBegin..<indexWhiteSpace]
                
                // Add message part is splitted to array
                subTweets.append(messagePart)
                
                // Increase indexPart by 1
                indexPart += 1
                
                // Update indexBegin value
                indexBegin = indexWhiteSpace + 1
                
                // Update indicatorCharacterCount value
                indicatorCharacterCount = numberOfDigits(indexPart) + 1 + K + 1
                
                // Update indexEnd value
                indexEnd = indexBegin + self.maxLength - indicatorCharacterCount
            } else {
                throw TweetValidationError.indicatorLengthExceed(maxLength)
            }
            
            // Split the message error at the first time and we will split the message at the second time by increasing K by 1
            if numberOfDigits(indexPart) > K {
                K = K + 1
                
                // Init variables
                indexPart = 1
                subTweets = []
                
                // Number of characters of indicator and whitespace (EX: "1/1 ")
                indicatorCharacterCount = numberOfDigits(indexPart) + 1 + K + 1 // 1 first is "/" character and 1 second is white space
                
                // Init indexBegin and indexEnd
                indexBegin = 0
                indexEnd = indexBegin + self.maxLength - indicatorCharacterCount
            }
        }
        
        // Add last one
        if indexBegin < trimmedTweet.count {
            subTweets.append(trimmedTweet[indexBegin..<trimmedTweet.count])
        }
        
        let result = subTweets.map { TweetComponent(index: subTweets.index(of: $0)! + 1, total: subTweets.count, text: $0)}
        
        return SplitResult.components(result)
    }
    
    // MARK: - Get number of digits
    fileprivate func numberOfDigits(_ n: Int) -> Int {
        if(n == 0) {
            return 0
        } else {
            return 1 + numberOfDigits(n / 10)
        }
    }
}
