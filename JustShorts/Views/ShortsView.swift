//
//  ShortsView.swift
//  JustShorts
//
//  Created by 최준현 on 9/10/24.
//

import SwiftUI

struct ShortsView: View {
    @State private var videoStore = VideoStore()
    @State private var scrollPosition: VideoListItem?
    var body: some View {
        
        ScrollView(){
            LazyVStack(spacing:0){
                ForEach(videoStore.videoList, id: \.self){ videoItem in
                    
                    
                    ZStack(alignment:.bottom){
                        VideoContainer(isPlaying: scrollPosition == videoItem, videoItem: videoItem)
                            .id(videoItem)
                        
                        ShortsInfoView()
                            .containerRelativeFrame(.horizontal, alignment: .bottomLeading)
                    
                    }
                    .containerRelativeFrame(.vertical, alignment: .center)
                    
                }//ForEach
                
            }//LazyVStack
            .scrollTargetLayout()
        }//ScrollView
        .ignoresSafeArea()
        .scrollPosition(id: $scrollPosition)
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollBounceBehavior(.basedOnSize)
        .padding(.bottom, 1)
        .task{
            await videoStore.fetchVideoList(search: "", page_current: 1, per_page: 10)
        }
        
    }
}

#Preview {
    ShortsView()
}
