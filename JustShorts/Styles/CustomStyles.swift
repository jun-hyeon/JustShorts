//
//  CustomStyles.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import SwiftUI

struct OutLinedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>)-> some View{
            configuration
            .font(.body)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 8).stroke(.black)
                }
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
    }
}








