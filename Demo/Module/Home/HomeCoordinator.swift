//
//  HomeCoordinator.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import RxSwift

class HomeCoordinator: BaseCoordinator<Void> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() throws -> Observable<Void> {
        
        let viewController = HomeViewController()
        let viewModel = HomeViewModel()
        viewController.viewModel = viewModel
        
        bindLifecycle(for: viewController)
        bindViewModel(for: viewModel, vc: viewController)
        rootViewController.pushTo(viewController, animated: true)
        return Observable.empty()
    }
    
}
// MARK: - Bind View controller lifecycle and viewmodel
extension HomeCoordinator {
    /**
     Function to bind lifecycle for the view controller
     - PARAMETER viewController: Instance of View Controller
     */
    func bindLifecycle(for viewController: HomeViewController) {
        
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
    func bindViewModel(for viewModel: HomeViewModel, vc: HomeViewController) {
        
        viewModel.redirectToSearch.asObservable().subscribe(onNext: { _ in
            self.redirectToSearch(on: vc)
        }).disposed(by: disposeBag)
        
        viewModel.redirectToInAppBrowser.asObservable().subscribe(onNext: { [weak self] bundleData in
            self?.redirectToInAppBrowser(on: vc, bundleData: bundleData)
        }).disposed(by: disposeBag)

    }
}
extension HomeCoordinator {
    /**
     Function to redirect to search
     - PARAMETER vc: Instance of `UIViewController`
     */
    private func redirectToSearch(on vc: UIViewController) {
        let homeCoordinator = SearchCoordinator(rootViewController: vc)
        self.coordinate(to: homeCoordinator)
    }

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
