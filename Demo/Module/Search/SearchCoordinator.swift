//
//  SearchCoordinator.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import RxSwift

class SearchCoordinator: BaseCoordinator<Void> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() throws -> Observable<Void> {
        
        let viewController = SearchViewController()
        let viewModel = SearchViewModel()
        viewController.viewModel = viewModel
        viewController.viewModel.delegate = viewController
        
        bindLifecycle(for: viewController)
        bindViewModel(for: viewModel, vc: viewController)
        rootViewController.pushTo(viewController, animated: true)
        return Observable.empty()
    }
    
}
// MARK: - Bind View controller lifecycle and viewmodel
extension SearchCoordinator {
    /**
     Function to bind lifecycle for the view controller
     - PARAMETER viewController: Instance of View Controller
     */
    func bindLifecycle(for viewController: SearchViewController) {
        
        viewController.rx.viewWillAppear
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    /**
     Function to bind view model
     - PARAMETER viewModel: Instance of View Model
     - PARAMETER vc: Instance of View Controller
     */
    func bindViewModel(for viewModel: SearchViewModel, vc: SearchViewController) {
        
        viewModel.redirectToInAppBrowser.asObservable().subscribe(onNext: { [weak self] bundleData in
            self?.redirectToInAppBrowser(on: vc, bundleData: bundleData)
        }).disposed(by: disposeBag)
    }
}
extension SearchCoordinator {
    /**
     Function to redirect to in app browser
     - PARAMETER vc: Instance of `UIViewController`
     - PARAMETER bundleData: `BundleData` value
     */
    private func redirectToInAppBrowser(on vc: UIViewController, bundleData: BundleData) {
        let coordinator = InAppBrowserCoordinator(rootViewController: vc, bundleData: bundleData)
        self.coordinate(to: coordinator)
    }
}
