//
//  BottomLineTextField.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import SwiftUI

struct BottomLineTextFieldStyle: TextFieldStyle{
    func _body(configuration: TextField<Self._Label>) -> some View{
        configuration
            .font(.body)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}




