//
//  BundleExtensions.swift
//  JustShorts
//
//  Created by 최준현 on 9/11/24.
//

import Foundation
extension Bundle{
    var base_url: String?{
        return infoDictionary?["BASE_URL"] as? String
    }
}
