//
//  PageInfoResponse.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//

import Foundation
import Mapper

struct PageInfoResponse: Mappable, Codable {
    var batchcomplete: Bool?
    var query: PageInfoResponseQuery?
    
    init(map: Mapper) throws {
        batchcomplete = map.optionalFrom("batchcomplete")
        query = map.optionalFrom("query")
    }
}

struct PageInfoResponseQuery: Mappable, Codable {
    
    var pages: [PageInfoResponsePages]?
    
    init(map: Mapper) throws {
        pages = map.optionalFrom("pages")
    }
}

struct PageInfoResponsePages: Mappable, Codable {
    
    var pageid: Int?
    var title: String?
    var fullurl: String?
    var canonicalurl: String?
    
    init(map: Mapper) throws {
        pageid = map.optionalFrom("pageid")
        title = map.optionalFrom("title")
        fullurl = map.optionalFrom("fullurl")
        canonicalurl = map.optionalFrom("canonicalurl")
    }
}
