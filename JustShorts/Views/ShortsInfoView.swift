//
//  ShortsInfoView.swift
//  JustShorts
//
//  Created by 최준현 on 9/12/24.
//

import SwiftUI

struct ShortsInfoView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack{
                AsyncImage(url: URL(string:"")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(.black)
                    
                } placeholder: {
                    Image(systemName:"person.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                        .clipped()
                }
                .clipShape(Circle())
                .frame(width: 40, height: 40)
                
                Text("강찬혁")
                    .font(.body)
                
            }
            Text("최준현의 영상입니다")
                .lineLimit(1)
                
        }.padding()
    }
}

#Preview {
    ShortsInfoView()
}
