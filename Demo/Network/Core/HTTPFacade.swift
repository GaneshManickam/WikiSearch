//
//  HTTPFacade.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//

import Foundation
import Moya
import RxSwift

class HTTPFacade<TypeOfTarget: NetworkTargetType> {
    private var provider: MoyaProvider<TypeOfTarget> = MoyaProviderFactory<TypeOfTarget>().moyaProvider()
    private var subject = PublishSubject<Data>()
    private var bag = DisposeBag()

    func request(target: TypeOfTarget) -> Single<Data> {
        return Single.create { observer in
            self.provider.rx.request(target).subscribe { event in
                switch event {
                case let .success(response):
                    print("\n\n")
                    print("Request URL: \(response.request?.url!.debugDescription ?? " ")")
                    let data = response.request?.httpBody
                    if data != nil {
                        print("\n\n")
                        print("Request Body: \(String(data: data!, encoding: .utf8)!)")
                    }
                    print("\n\n")
                    print("Request Headers: \(String(describing: (response.request?.allHTTPHeaderFields!)!))")
                    do {
                        let json = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.allowFragments)
                        if let JSONData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                            let prettyString = NSString(data: JSONData, encoding: String.Encoding.utf8.rawValue) {
                            print("\n\n")
                            print(prettyString)
                            print("\n\n")
                        }
                    } catch {}

                    observer(.success(response.data))
                case let .error(error):
                    print("\n\n")
                    print("BaseURL: \(target.baseURL)")
                    print("\n\n")
                    print("Headers: \(target.headers ?? [:])")
                    print("\n\n")
                    print("Params: \(target.parameters ?? [:])")
                    print("\n\n")
                    print("Error: \(error)")

                    observer(.error(checkFailureError(error)))
                }
            }.disposed(by: self.bag)

            return Disposables.create {}
        }
    }
}
