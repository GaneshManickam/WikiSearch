//
//  RecenltyViewed.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//

import Foundation
import RealmSwift

class RecenltyViewed: Object {
    var pageId = RealmOptional<Int>()
    var updatedAt = RealmOptional<Double>()
    @objc dynamic var titleValue = ""
    @objc dynamic var subTitleValue = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var redirectUrl = ""


    override class func primaryKey() -> String? {
        return "pageId"
    }
    
    convenience init(_ data: BundleData) {
        self.init()
        self.pageId.value = data.pageId ?? 0
        self.updatedAt.value = data.updatedAt ?? 0
        self.titleValue = data.titleValue ?? ""
        self.subTitleValue = data.subTitleValue ?? ""
        self.imageUrl = data.imageUrl ?? ""
        self.redirectUrl = data.redirectUrl ?? ""
    }
    
    /**
     Function to get `BundleData` from the realm object
     */
    func getBundleDataFromRealm() -> BundleData {
        var bundleData = BundleData()
        bundleData.pageId = self.pageId.value ?? 0
        bundleData.updatedAt = self.updatedAt.value ?? 0
        bundleData.titleValue = self.titleValue
        bundleData.subTitleValue = self.subTitleValue
        bundleData.imageUrl = self.imageUrl
        bundleData.redirectUrl = self.redirectUrl
        return bundleData
    }
}
