//
//  SearchResponse.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//

import Foundation
import Mapper

struct SearchResponse: Mappable, Codable {
    var batchcomplete: Bool?
    var continueField: SearchResponseContinue?
    var query: SearchResponseQuery?

    init(map: Mapper) throws {
        batchcomplete = map.optionalFrom("batchcomplete")
        continueField = map.optionalFrom("continue")
        query = map.optionalFrom("query")
    }
}

struct SearchResponseContinue: Mappable, Codable {
    
    var gpsoffset: Int?
    var continueField: String?
    
    init(map: Mapper) throws {
        gpsoffset = map.optionalFrom("gpsoffset")
        continueField = map.optionalFrom("continue")
    }
    
}

struct SearchResponseQuery: Mappable, Codable {
    
    var pages: [SearchResponsePages]?
    
    init(map: Mapper) throws {
        pages = map.optionalFrom("pages")
    }

}

struct SearchResponsePages: Mappable, Codable {
    var pageid: Int?
    var title: String?
    var thumbnail: SearchResponseThumbnail?
    var terms: SearchResponseTerms?
    
    init(map: Mapper) throws {
        pageid = map.optionalFrom("pageid")
        title = map.optionalFrom("title")
        thumbnail = map.optionalFrom("thumbnail")
        terms = map.optionalFrom("terms")
    }
}

struct SearchResponseThumbnail: Mappable, Codable {
    var source: String?
    init(map: Mapper) throws {
        source = map.optionalFrom("source")
    }
}

struct SearchResponseTerms: Mappable, Codable{
    var descriptionArray: [String]?
    init(map: Mapper) throws {
        descriptionArray = map.optionalFrom("description")
    }
}
