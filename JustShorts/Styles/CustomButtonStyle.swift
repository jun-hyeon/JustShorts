//
//  CustomButtonStyle.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.primary)
            .padding()
            .background(color, in: RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 10)
    }
}


