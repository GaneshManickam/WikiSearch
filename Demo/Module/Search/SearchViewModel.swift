//
//  SearchViewModel.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import RxSwift
import RxCocoa

// MARK: - ViewModel protocols to communicate viewmodel to view controller
protocol SearchViewModelDelegate: class {
}

class SearchViewModel {
    let service = SearchService()
    private var disposeBag = DisposeBag()
    weak var delegate: SearchViewModelDelegate?
    
    var shouldLoad: Bool = true
    private var currentOffset: Int = 0
    let redirectToInAppBrowser = PublishSubject<BundleData>()
    var itemsArray = BehaviorRelay<[SearchResponsePages]>(value: [])
    var showEmptyState = BehaviorRelay<Bool>(value: false)

}
/// ViewController -> ViewModel
extension SearchViewModel {

    /**
     Function to perform search call
     - PARAMETER searchQuery: `String` value
     - PARAMETER isFromSearch: `Bool` value
     */
    func performSearchCall(_ searchQuery: String, isFromSearch: Bool) {
        if isFromSearch {
            shouldLoad = true
            currentOffset = 0
            itemsArray.accept([])
            AppDelegate.startLoading()
        }
        let parameters: [String: Any] = [
            Constants.ApiConstants.action: Constants.ApiConstants.query,
            Constants.ApiConstants.format: Constants.ApiConstants.json,
            Constants.ApiConstants.prop: Constants.ApiConstants.pageimages_Terms,
            Constants.ApiConstants.generator: Constants.ApiConstants.prefixsearch,
            Constants.ApiConstants.redirects: 1,
            Constants.ApiConstants.formatversion: 2,
            Constants.ApiConstants.piprop: Constants.ApiConstants.thumbnail,
            Constants.ApiConstants.pithumbsize: 100,
            Constants.ApiConstants.pilimit: 10,
            Constants.ApiConstants.wbptterms: Constants.ApiConstants.descriptionField,
            Constants.ApiConstants.gpslimit: 10,
            Constants.ApiConstants.gpsoffset: self.currentOffset,
            Constants.ApiConstants.gpssearch: searchQuery
        ]
        self.searchByQuery(parameters: parameters)
    }
    /**
     Function to perform search by query api call
     - PARAMETER parameters: Dictionary values
     */
    private func searchByQuery(parameters: [String: Any]) {
        service.searchByQuery(parameters: parameters).subscribe(onSuccess: { data in
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
                        let response = SearchResponse.from(JSON)!
                        self.shouldLoad = false
                        if response.continueField?.gpsoffset != nil {
                            self.currentOffset = (response.continueField?.gpsoffset)!
                            self.shouldLoad = true
                        }
                        var tempArray = self.itemsArray.value
                        tempArray += response.query?.pages ?? []
                        self.itemsArray.accept(tempArray)
                    }
                }
                self.showEmptyState.accept(self.itemsArray.value.isEmpty)
            } catch {}
        }, onError: { error in
            AppDelegate.showToast(message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
