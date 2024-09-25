//
//  ShortsInfoView.swift
//  JustShorts
//
//  Created by 최준현 on 9/12/24.
//

import SwiftUI

struct ShortsInfoView: View {
    var videoItem : VideoListItem
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack{
                AsyncImage(url: URL(string:"\(videoItem.writer_profile)")) { image in
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
                        .background(.white)
                }
                .clipShape(Circle())
                .frame(width: 40, height: 40)
                
                Text("\(videoItem.writer)")
                    .font(.body)
                    .foregroundStyle(.white)
            }
            
            Text("\(videoItem.title)")
                .lineLimit(1)
                .foregroundStyle(.white)
                
        }.padding()
    }
}

