//
//  BorderedTextField.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import SwiftUI

struct BorderedTextField: View {
    var body: some View {
        VStack{
            Text("ID*")
                .font(.caption)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("")
        }
        
    }
}

#Preview {
    BorderedTextField()
}
