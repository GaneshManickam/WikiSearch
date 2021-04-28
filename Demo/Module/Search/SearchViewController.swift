//
//  SearchViewController.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, UITableViewDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel: SearchViewModel!

    // MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        initRxBinding()
        setupUI()
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
extension SearchViewController {
    /**
     Function to initialize Rx binding
     */
    func initRxBinding() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.asDriver()
            .drive(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
                self?.viewModel.performSearchCall(self?.searchBar.text ?? "", isFromSearch: true)
            }).disposed(by: disposeBag)

        viewModel.itemsArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: "HomeTableViewCell", cellType: HomeTableViewCell.self)) { (row, item, cell) in
            cell.loadDataIntoUI(item)
            if row == self.viewModel.itemsArray.value.count-1 && self.viewModel.shouldLoad {
                self.viewModel.performSearchCall(self.searchBar.text ?? "", isFromSearch: false)
            }

        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(SearchResponsePages.self)
            .subscribe(onNext: { [weak self] model in
                let bundleData = BundleData(updatedAt: Date().timeIntervalSince1970, pageId: model.pageid ?? 0, titleValue: model.title ?? "", subTitleValue: model.terms?.descriptionArray?.first ?? "", imageUrl: model.thumbnail?.source ?? "", redirectUrl: nil)
                self?.viewModel.redirectToInAppBrowser.asObserver().onNext(bundleData)
            }).disposed(by: disposeBag)
        
        viewModel.showEmptyState
            .asObservable()
            .bind { [weak self] status in
                self?.tableView.isHidden = status
                self?.emptyStateLabel.isHidden = !status
            }
            .disposed(by: disposeBag)

    }
    
}

// MARK: - UI Setup
extension SearchViewController {
    /**
     Function to setup ui elements
     */
    func setupUI() {
        
    }
}
// MARK: - ViewModel Delegate
extension SearchViewController: SearchViewModelDelegate {
    
}
