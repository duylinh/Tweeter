//
//  NewTweetViewModel.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

extension NewTweetViewModel: NewTweetViewModelType {
    var inputs: NewTweetViewModelInputs { return self }
    var outputs: NewTweetViewModelOutputs { return self }
}

class NewTweetViewModel: NewTweetViewModelInputs, NewTweetViewModelOutputs {
    
    // MARK: - Properties
    // Inputs
    var tweet = BehaviorRelay<String?>(value: nil)
    let sendTweet = PublishRelay<Void>()
    
    // Outputs
    private(set) lazy var twitSuccessful: Driver<Bool> = self.successfulRelay.asDriver(onErrorJustReturn: false)
    private(set) lazy var errors: Driver<Error> = self.errorRelay.asDriver(onErrorDriveWith: .never())
    
    // Private
    private let successfulRelay = PublishRelay<Bool>()
    private let errorRelay = PublishRelay<Error>()
    
    private let tweetProccessor = TweetHelper(maxLength: 50)
    private let disposeBag = DisposeBag()
    
    // MARK: - Con(De)structor
    init() {
        let sendTweetResult = sendTweet
            .withLatestFrom(tweet)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .flatMap { [unowned self] message in
                return self.splitMessage(message).materialize()
            }
            .share(replay: 1)
        
        sendTweetResult
            .elements()
            .subscribe(onNext: { [unowned self] tweets in
                self.saveTweets(tweets)
                self.successfulRelay.accept(true)
            })
            .disposed(by: disposeBag)
        
        sendTweetResult
            .errors()
            .bind(to: errorRelay)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    fileprivate func splitMessage(_ message: String?) -> Observable<SplitResult> {
        let tweetProccessor = self.tweetProccessor
        
        return Observable.create { (observer) -> Disposable in
            do {
                let tweets = try tweetProccessor.splitTweet(message)
                observer.onNext(tweets)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    fileprivate func saveTweets(_ result: SplitResult) {
        var tweets = [Tweet]()
        
        switch result {
        case .components(let components):
            tweets = components.reversed().map { component -> Tweet in
                let tweet = Tweet()
                tweet.content = component.tweet
                tweet.creator = User()
                return tweet
            }
            
        case .message(let message):
            
            let tweet = Tweet()
            tweet.content = message
            tweet.creator = User()
            tweets.append(tweet)
        }
        
        try! DataHelper.realm.write {
            DataHelper.realm.add(tweets, update: false)
        }
    }
}
