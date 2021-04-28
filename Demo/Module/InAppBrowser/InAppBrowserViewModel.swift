//
//  InAppBrowserViewModel.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import RxSwift
import RxCocoa

// MARK: - ViewModel protocols to communicate viewmodel to view controller
protocol InAppBrowserViewModelDelegate: class {
    func loadUrl(_ url: URL)
}

class InAppBrowserViewModel {
    let service = InAppBrowserService()
    private var disposeBag = DisposeBag()
    weak var delegate: InAppBrowserViewModelDelegate?
    
    var bundleData: BundleData?
}
extension InAppBrowserViewModel {
    /**
     Function to perform initialize data
     */
    func performInitializeData() {
        if let redirectUrlStr = bundleData?.redirectUrl, !redirectUrlStr.isEmpty, let redirectUrl = URL(string: redirectUrlStr) {
            self.loadUrlIntoWebView(redirectUrl)
        } else if let pageId = bundleData?.pageId {
            let parameters: [String: Any] = [
                Constants.ApiConstants.action: Constants.ApiConstants.query,
                Constants.ApiConstants.format: Constants.ApiConstants.json,
                Constants.ApiConstants.prop: Constants.ApiConstants.info,
                Constants.ApiConstants.inprop: Constants.ApiConstants.url,
                Constants.ApiConstants.formatversion: 2,
                Constants.ApiConstants.pageids: pageId
            ]
            AppDelegate.startLoading()
            self.getPageInfo(parameters: parameters)
        }
    }
    
    /**
     Function to load url into webview
     - PARAMETER url: Instance of `URL`
     */
    private func loadUrlIntoWebView(_ url: URL) {
        AppDelegate.startLoading()
        self.delegate?.loadUrl(url)
        self.bundleData?.redirectUrl = url.absoluteString
        self.bundleData?.updatedAt = Date().timeIntervalSince1970
        if let data = self.bundleData {
            self.updateRecentlyViewedInDB(data)
        }
    }
    
    /**
     Function to get page info
     - PARAMETER parameters: Dictionary value
     */
    private func getPageInfo(parameters: [String: Any]) {
        service.getPageInfo(parameters: parameters).subscribe(onSuccess: { data in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                AppDelegate.finishLoading()
                if let JSON: NSDictionary = json as? NSDictionary {
                    if JSON.object(forKey: "error") != nil {
                        let response = ErrorResponse.from(JSON)!
                        if let reason = response.error?.reason, !reason.isEmpty {
                            AppDelegate.showToast(message: reason)
                        }

                    } else {
                        let response = PageInfoResponse.from(JSON)!
                        if let urlString = response.query?.pages?.first?.fullurl, let url = URL(string: urlString) {
                            self.loadUrlIntoWebView(url)
                        }
                    }
                }
            } catch {}
        }, onError: { error in
            AppDelegate.showToast(message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }

    /**
     Function to perform update recently viewed in db
     - PARAMETER data: `BundleData` value
     */
    private func updateRecentlyViewedInDB(_ data: BundleData) {
        DBManager.shared.create(RecenltyViewed(data))
    }
}

