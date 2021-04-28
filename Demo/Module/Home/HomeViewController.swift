//
//  HomeViewController.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController, UITableViewDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModel!

    // MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        initRxBinding()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getRecentlyViewedPages()
    }

    /**
     Function to register table view
     */
    private func registerTableView() {
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableView.automaticDimension
    }

}

// MARK: - Binding
extension HomeViewController {
    /**
     Function to initialize Rx binding
     */
    func initRxBinding() {
        searchButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.redirectToSearch.asObserver().onNext(())
            }).disposed(by: disposeBag)
        
        viewModel.showEmptyState
            .asObservable()
            .bind { [weak self] status in
                self?.tableView.isHidden = status
                self?.emptyStateLabel.isHidden = !status
            }
            .disposed(by: disposeBag)
        
        viewModel.itemsArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: "HomeTableViewCell", cellType: HomeTableViewCell.self)) { (row, item, cell) in
            cell.loadDataIntoUI(item)
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(RecenltyViewed.self)
            .subscribe(onNext: { [weak self] model in
                let bundleData = model.getBundleDataFromRealm()
                self?.viewModel.redirectToInAppBrowser.asObserver().onNext(bundleData)
            }).disposed(by: disposeBag)

    }
    
}

// MARK: - UI Setup
extension HomeViewController {
    /**
     Function to setup ui elements
     */
    func setupUI() {
        
    }
}
