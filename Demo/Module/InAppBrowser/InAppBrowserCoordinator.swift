//
//  InAppBrowserCoordinator.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import RxSwift

class InAppBrowserCoordinator: BaseCoordinator<Void> {
    
    private let rootViewController: UIViewController
    private let bundleData: BundleData
    
    init(rootViewController: UIViewController, bundleData: BundleData) {
        self.rootViewController = rootViewController
        self.bundleData = bundleData
    }
    
    override func start() throws -> Observable<Void> {
        
        let viewController = InAppBrowserViewController()
        let viewModel = InAppBrowserViewModel()
        viewController.viewModel = viewModel
        viewController.viewModel.bundleData = bundleData
        viewController.viewModel.delegate = viewController
        
        bindLifecycle(for: viewController)
        bindViewModel(for: viewModel, vc: viewController)
        rootViewController.pushTo(viewController, animated: true)
        return Observable.empty()
    }
    
}
// MARK: - Bind View controller lifecycle and viewmodel
extension InAppBrowserCoordinator {
    /**
     Function to bind lifecycle for the view controller
     - PARAMETER viewController: Instance of View Controller
     */
    func bindLifecycle(for viewController: InAppBrowserViewController) {
        
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
    func bindViewModel(for viewModel: InAppBrowserViewModel, vc: InAppBrowserViewController) {
    }
}
