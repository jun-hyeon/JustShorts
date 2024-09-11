//
//  CustomTextFiled.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import SwiftUI

struct TextFieldWithCaption: View {
    
    var caption: String
    var titleKey: String
    @Binding var text: String
    var isSecureField: Bool
    
    var body: some View {
        VStack{
            Text(caption)
                .font(.caption)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            if isSecureField{
                SecureField(titleKey, text: $text)
                    .textFieldStyle(OutLinedTextFieldStyle())
            }else{
                TextField(titleKey, text: $text)
                    .textFieldStyle(OutLinedTextFieldStyle())
            }
        }
    }
}

#Preview {
    TextFieldWithCaption(caption: "ID", titleKey: "ID를 입력해주세요", text: .constant("asdf"), isSecureField: false)
}
