//
//  InAppBrowserService.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//  
//

import Foundation
import RxSwift

class InAppBrowserService {
    private let facade = HTTPFacade<NetworkTarget>()
    private let disposeBag = DisposeBag()
}
/// ViewModel -> Service
extension InAppBrowserService {
    func getPageInfo(parameters: [String: Any]) -> Single<Data> {
        return Single.create { observer in
            let target = NetworkTarget.getPageInfo(parameters: parameters)
            self.facade.request(target: target).subscribe(onSuccess: { data in
                observer(.success(data))
            }, onError: { error in
                observer(.error(error))
            }).disposed(by: self.disposeBag)
            
            return Disposables.create {}
        }
    }

}
