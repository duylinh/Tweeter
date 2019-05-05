//
//  TweetsController.swift
//  Tweeter
//
//  Created by DUYLINH on 5/03/19.
//  Copyright © 2019 DUYLINH. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources

public typealias TweetsSectionModel = AnimatableSectionModel<String, TweetCellModel>

public protocol TweetsViewModelInputs {}

public protocol TweetsViewModelOutputs {
    var tweets: Driver<[TweetsSectionModel]> { get }
}

public protocol TweetsViewModelType {
    var inputs: TweetsViewModelInputs { get }
    var outputs: TweetsViewModelOutputs { get }
}

final class TweetsController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var viewModel: TweetsViewModelType! = TweetsViewModel()
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<TweetsSectionModel>!
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var newTweetButton: UIBarButtonItem = UIBarButtonItem(image: Asset.tweetIcon.image, style: .plain, target: nil, action: nil)
    
    // MARK: - Overridden: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationItem.title = String.tl_tweet_list
        navigationItem.rightBarButtonItem = newTweetButton
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        
        viewModel
            .outputs.tweets
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        newTweetButton
            .rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.showNewTweetScreen()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    fileprivate func configureTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        dataSource = RxTableViewSectionedAnimatedDataSource<TweetsSectionModel>(configureCell: { (_, tableView, _, model) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.ID) as? TweetCell else {
                fatalError("Cannot dequeue cell with identfier: TweetCell")
            }
            cell.setModel(model)
            return cell
        })
    }
    
    fileprivate func showNewTweetScreen() {
        let newTweetViewController = StoryboardScene.Main.newTweetViewController.instantiate()
        newTweetViewController.viewModel = NewTweetViewModel()
        
        let naviController = UINavigationController(rootViewController: newTweetViewController)
        present(naviController, animated: true, completion: nil)
    }
}
