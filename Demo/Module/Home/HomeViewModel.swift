//
//  HomeViewModel.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import RxSwift
import RxCocoa

class HomeViewModel {
    let redirectToSearch = PublishSubject<Void>()
    let redirectToInAppBrowser = PublishSubject<BundleData>()
    var itemsArray = BehaviorRelay<[RecenltyViewed]>(value: [])
    var showEmptyState = BehaviorRelay<Bool>(value: false)

}

extension HomeViewModel {
    /**
     Function to get recently viewed pages
     */
    func getRecentlyViewedPages() {
        DBManager.shared.readRecentlyViewed { [weak self] (result) in
            self?.itemsArray.accept(Array(result))
            self?.showEmptyState.accept(self?.itemsArray.value.isEmpty ?? true)
        }
    }
}
