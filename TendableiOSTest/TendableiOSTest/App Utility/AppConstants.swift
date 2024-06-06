//
//  AppConstants.swift
//  TendableiOSTest
//
//  Created by Shravan Gundawar on 05/06/24.
//

import Foundation

class AppConstants {
    
    class UIConstants {
        static let submit = "Submit"
        static let cancel = "Cancel"
        static let noInternetTitle = "Network Error"
        static let noInternetMessage = "No internet connection"
        static let ok = "OK"
    }
    
    class APIConstants {
        static let baseUrl = "http://localhost:5001/"
        static let inspection = "api/inspections/start"
        static let submit = "api/inspections/submit"
    }
}
