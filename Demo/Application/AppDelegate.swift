//
//  AppDelegate.swift
//  Demo
//
//  Created by Ganesh Manickam on 27/04/21.
//

import UIKit
import RxSwift
import Toast_Swift
import Toaster

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Instance of `UIWindow`
    var window: UIWindow?
    /// Instance of `AppCoordinator`
    fileprivate var appCoordinator: AppCoordinator!
    /// AppDelegate's `DisposeBag`
    fileprivate let disposeBag = DisposeBag()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        AppDelegate.currentDelegate.showRootScreen()
        return true
    }

}
extension AppDelegate {
    static var loaderBaseView = UIView()

    // AppDelegate instance for access from other classes
    static var currentDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // UIWindow instance for access from other classes
    static var currentWindow: UIWindow {
        return currentDelegate.window!
    }

    // Loader start
    static func startLoading() {
        getCurrentViewController()?.view.makeToastActivity(.center)
    }
    
    // Loader finish
    static func finishLoading() {
        getCurrentViewController()?.view.hideToastActivity()
    }
    
    // Get current view controller instance
    static func getCurrentViewController() -> UIViewController? {
        return UIApplication.topViewController() != nil ? UIApplication.topViewController() : nil
    }

    // Show Toast
    static func showToast(message: String) {
        ToastView.appearance().font = UIFont.systemFont(ofSize: 14, weight: .medium)
        Toast(text: message).show()
    }
    
    /**
     Function to show root screen
     */
    func showRootScreen() {
        appCoordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
    }

}
