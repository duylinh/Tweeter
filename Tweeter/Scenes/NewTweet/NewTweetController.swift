//
//  NewTweetController.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//


import UIKit
import RxCocoa
import RxSwift
import KMPlaceholderTextView

public protocol NewTweetViewModelInputs {
    var tweet: BehaviorRelay<String?> { get }
    var sendTweet: PublishRelay<Void> { get }
}

public protocol NewTweetViewModelOutputs {
    var twitSuccessful: Driver<Bool> { get }
    var errors: Driver<Error> { get }
}

public protocol NewTweetViewModelType {
    var inputs: NewTweetViewModelInputs { get }
    var outputs: NewTweetViewModelOutputs { get }
}

final class NewTweetController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var textView: KMPlaceholderTextView!
    
    // MARK: - UI Components
    private lazy var cancelButton: UIBarButtonItem = UIBarButtonItem(title: String.bi_cancel, style: .plain, target: nil, action: nil)
    private lazy var sendTweetButton: UIBarButtonItem = UIBarButtonItem(title: String.bi_send_tweet, style: .plain, target: nil, action: nil)
    
    // MARK: - Properties
    var viewModel: NewTweetViewModelType! = NewTweetViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Overridden: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = String.tl_new_tweet
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = sendTweetButton
        textView.placeholder = String.pl_what_happen
        textView.rounded()
        cancelButton
            .rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        configureViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    // MARK: - Private
    private func configureViewModel() {
        // Inputs
        sendTweetButton
            .rx.tap
            .bind(to: viewModel.inputs.sendTweet)
            .disposed(by: disposeBag)
        
        textView
            .rx.text
            .bind(to: viewModel.inputs.tweet)
            .disposed(by: disposeBag)
        
        // Outputs
        
        viewModel
            .outputs.twitSuccessful
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .outputs.errors
            .drive(onNext: { [unowned self] in self.showError($0) })
            .disposed(by: disposeBag)
        
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: String.al_error, message: String(describing: error), preferredStyle: .alert)
        let OK = UIAlertAction(title: String.al_ok, style: .default, handler: nil)
        alert.addAction(OK)
        
        present(alert, animated: true, completion: nil)
    }
}
