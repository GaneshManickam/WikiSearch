//
//  InAppBrowserViewController.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

class InAppBrowserViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel: InAppBrowserViewModel!
    
    fileprivate var webView: WKWebView!
    
    // MARK: - Superview Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initRxBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        viewModel.performInitializeData()
    }

}

// MARK: - Binding
extension InAppBrowserViewController {
    /**
     Function to initialize Rx binding
     */
    func initRxBinding() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.webView != nil && self?.webView.canGoBack ?? false {
                    self?.webView.goBack()
                } else  {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - UI Setup
extension InAppBrowserViewController {
    /**
     Function to setup ui elements
     */
    func setupUI() {
        if self.webView == nil {
            let webConfiguration = WKWebViewConfiguration()
            self.webView = WKWebView(frame: self.containerView.bounds, configuration: webConfiguration)
            self.webView.isOpaque = false
            self.webView.backgroundColor = UIColor.clear
            self.webView.navigationDelegate = self
            self.webView.uiDelegate = self
            self.containerView.addSubview(self.webView)
            self.webView.allowsBackForwardNavigationGestures = true
            self.containerView.addSubview(self.webView)
        }
    }
}
// MARK:- WKNavigationDelegate & WKUIDelegate
extension InAppBrowserViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        AppDelegate.finishLoading()
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
        AppDelegate.finishLoading()
    }
}
// MARK: - ViewModel Delegate
extension InAppBrowserViewController: InAppBrowserViewModelDelegate {
    /**
     Function to load url
     - PARAMETER url: Instance of `URL`
     */
    func loadUrl(_ url: URL) {
        if self.webView != nil {
            self.webView.load(URLRequest(url: url))
        }
    }
}
