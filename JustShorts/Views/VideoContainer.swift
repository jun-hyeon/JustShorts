//
//  VideoView.swift
//  JustShorts
//
//  Created by 최준현 on 9/11/24.
//

import SwiftUI
import AVKit
struct VideoContainer: View {
    @State private var player: AVPlayer?
    @State private var isVideoPlaying: Bool = false
    var isPlaying: Bool
    var videoItem: VideoListItem
    
    // 재생/일시정지 토글 함수
    private func togglePlayPause() {
        isVideoPlaying ? player?.pause() : player?.play()
        isVideoPlaying.toggle()
        player?.seek(to: .now)
    }
    
    var body: some View {
        ZStack{
            VideoPlayer(player: player)
                .task {
                    guard let url = URL(string: videoItem.video_url)else{
                        return
                    }
                    player = AVPlayer(url:url)
//                    player?.play()
                }
                .onChange(of: isPlaying){
                    isPlaying ? player?.play() : player?.pause()
                }
                .onDisappear{
                    player?.pause()
                }
                .scaledToFill()
                .disabled(true)
                
            Button{
                togglePlayPause()
            }label:{
                Color.clear
            }
        }//ZStack
        
    }
}


