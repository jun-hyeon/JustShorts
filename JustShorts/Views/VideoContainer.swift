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
    @State private var duration: CMTime = .zero
    
    var isPlaying: Bool
    var videoItem: VideoListItem
    
    // 재생/일시정지 토글 함수
    private func togglePlayPause() {
        if isVideoPlaying {
            player?.pause()
        }else{
            player?.play()
        }
        isVideoPlaying.toggle()
        player?.seek(to: .now)
    }
    
    private func activeAudioSession(){
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private func deactiveAudioSession(){
        do{
            try AVAudioSession.sharedInstance().setActive(false)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    private func loadVideo(url: String) async {
        
        guard let url = URL(string: url) else{
            return
        }
        let asset = AVURLAsset(url: url)
        
        do{
            let (preffered, tracks) = try await asset.load(.preferredTransform, .tracks)
            
            print("Tracks:\n \(tracks)")
            print("preffered:\n \(preffered)")
            
            if asset.status(of: .preferredTransform) == .loaded(preffered) && asset.status(of: .tracks) == .loaded(tracks){
                print("-----loaded-----")
                let playerItem = AVPlayerItem(asset: asset)
                player?.replaceCurrentItem(with: playerItem)
            }
            
        }catch{
            print(error)
        }
    }
    
    var body: some View {
        ZStack{
            VideoPlayer(player:player)
                .onAppear{
                    NotificationCenter.default.addObserver(forName: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem, queue: .main) { noti in
                        player?.seek(to: .zero)
                        player?.play()
                    }
                }
                .task {
                    player = AVPlayer()
                    await loadVideo(url: videoItem.video_url)
                    activeAudioSession()
                    player?.play()
                }
                .onChange(of: isPlaying){
                    if isPlaying{
                        player?.play()
                        activeAudioSession()
                    }else{
                        player?.pause()
                        deactiveAudioSession()
                    }
                }
                .onDisappear{
                    player?.pause()
                    deactiveAudioSession()
                }
                .scaledToFill()
                .disabled(true)
            
            Button{
                togglePlayPause()
            }label:{
                Color.clear
            }
        }//ZStack
        .task{
            player = AVPlayer()
            await loadVideo(url: videoItem.video_url)
            
        }
        .onChange(of: isPlaying){
            if isPlaying{
                player?.play()
                activeAudioSession()
            }else{
                player?.pause()
                deactiveAudioSession()
            }
        }
        .onDisappear{
            player?.pause()
            NotificationCenter.default.removeObserver(self)
        }
    }
}


