//
//  TextExtensions.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import Foundation
import SwiftUI

extension Text {
    func captionText(text: String){
          self
            .font(.caption)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
