//
//  ToastMessage.swift
//  JustShorts
//
//  Created by 최준현 on 9/10/24.
//

import SwiftUI

enum ToastStyle{
    case error
    case warning
    case success
    case info
}

extension ToastStyle{
    var themeColor : Color{
        switch self{
        case .error:
            return Color.red
        case .warning:
            return Color.orange
        case .info:
            return Color.blue
        case .success:
            return Color.green
        }
    }
    var iconFileName: String{
        switch self{
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        }
    }
}
struct Toast: Equatable{
    
    var type: ToastStyle
    var title: String
    var message: String
    var duration: Double = 3.0
}

struct ToastMessage: View {
    var type: ToastStyle
    var title: String
    var message: String
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading){
            
            HStack(alignment: .top){
                Image(systemName: type.iconFileName)
                    .foregroundStyle(type.themeColor)
                
                VStack(alignment: .leading){
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundStyle(.black.opacity(0.6))
                }
                
                Spacer()
                
                Button{
                    onCancelTapped()
                }label:{
                    Image(systemName:"xmark")
                        .foregroundStyle(.black)
                }
            }
            .padding()
        }
        .background(.white)
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(type.themeColor)
                .frame(width: 6)
                .clipped()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ToastMessage(type: .success, title: "Login", message: "Success", onCancelTapped: {
        
    })
}
