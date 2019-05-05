//
//  TweetsViewModel.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension TweetsViewModel: TweetsViewModelType {
    var inputs: TweetsViewModelInputs { return self }
    var outputs: TweetsViewModelOutputs { return self }
}

final class TweetsViewModel: TweetsViewModelInputs, TweetsViewModelOutputs {
    
    // MARK: - Properties
    let tweets: Driver<[TweetsSectionModel]>
    
    // MARK: - Con(De)structor
    init() {
        self.tweets = DataHelper.observableObjects(type: Tweet.self)
            .map { tweets -> [TweetsSectionModel] in
                let cellModels = tweets
                    .sorted(byKeyPath: "createdAt", ascending: false)
                    .map { TweetCellModel(tweet: $0) }
                
                return [TweetsSectionModel(model: "", items: Array(cellModels))]
            }
            .asDriver(onErrorJustReturn: [])
    }
}
