//
//  SplashCoordinator.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import RxSwift

class SplashCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() throws -> Observable<Void> {
        
        let viewController = SplashViewController(nibName: "SplashViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: viewController)
        let viewModel = SplashViewModel()
        viewController.viewModel = viewModel
        
        bindLifecycle(for: viewController)
        bindViewModel(for: viewModel, vc: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return Observable.empty()
    }
    
}
// MARK: - Bind View controller lifecycle and viewmodel
extension SplashCoordinator {
    /**
     Function to bind lifecycle for the view controller
     - PARAMETER viewController: Instance of View Controller
     */
    func bindLifecycle(for viewController: SplashViewController) {
        
        viewController.rx.viewWillAppear
            .subscribe(onNext: { _ in
                viewController.navigationController?.isNavigationBarHidden = true
            })
            .disposed(by: disposeBag)
        
        viewController.rx.viewDidAppear
            .subscribe(onNext: { _ in
                viewController.viewModel.redirectToHome.asObserver().onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    /**
     Function to bind view model
     - PARAMETER viewModel: Instance of View Model
     - PARAMETER vc: Instance of View Controller
     */
    func bindViewModel(for viewModel: SplashViewModel, vc: SplashViewController) {
        viewModel.redirectToHome.asObservable().subscribe(onNext: { _ in
            self.redirectToHome(on: vc)
        }).disposed(by: disposeBag)
    }
}
extension SplashCoordinator {
    /**
     Function to redirect to home
     - PARAMETER vc: Instance of `UIViewController`
     */
    private func redirectToHome(on vc: UIViewController) {
        let homeCoordinator = HomeCoordinator(rootViewController: vc)
        self.coordinate(to: homeCoordinator)
    }

}
