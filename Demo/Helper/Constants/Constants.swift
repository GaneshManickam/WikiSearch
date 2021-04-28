//
//  Constants.swift
//  Demo
//
//  Created by Ganesh Manickam on 28/04/21.
//

import Foundation

struct Constants {
    
    struct URLs {
        static let base_url = "https://en.wikipedia.org//w/api.php"
    }

    struct ApiConstants {
        static let action = "action"
        static let query = "query"
        static let format = "format"
        static let json = "json"
        static let prop = "prop"
        static let pageimages_Terms = "pageimages|pageterms"
        static let generator = "generator"
        static let prefixsearch = "prefixsearch"
        static let redirects = "redirects"
        static let formatversion = "formatversion"
        static let piprop = "piprop"
        static let thumbnail = "thumbnail"
        static let pithumbsize = "pithumbsize"
        static let pilimit = "pilimit"
        static let wbptterms = "wbptterms"
        static let gpssearch = "gpssearch"
        static let gpslimit = "gpslimit"
        static let pageids = "pageids"
        static let gpsoffset = "gpsoffset"
        static let url = "url"
        static let inprop = "inprop"
        static let descriptionField = "description"
        static let info = "info"
    }
    
    struct ApiPathConstants {
        static let searchByQuery = ""
        static let getPageInfo = ""
    }

    
    struct BundleConstants {
        static let sample = "sample"
    }
}
