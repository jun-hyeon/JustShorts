//
//  CameraScreen.swift
//  JustShorts
//
//  Created by 최준현 on 9/25/24.
//

import SwiftUI
import AVFoundation
import PhotosUI
import AVKit



struct CameraView: View {
    @StateObject private var camera = Camera()
    @State private var video: Video?
    @State private var player: AVPlayer?
    var body: some View {
        ZStack (alignment:.bottom){
            
                CameraPreview(session: $camera.session)
                    
                // Adjust the height to your needs
                HStack {
                    if let image = camera.thumbnailImage{
                        videoPicker(selectedVideo: $video, thumbnail: image)
                            .frame(width: 64, height: 64)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        camera.isRecording ? camera.stopRecording() : camera.startRecording()
                    }) {
                        Text(camera.isRecording ? "Stop Recording" : "Start Recording")
                            .padding()
                            .background(camera.isRecording ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button{
                        //back, front camera change
                        
                    }label:{
                        Image(systemName:"arrow.triangle.2.circlepath.camera")
                    }
                    
                }.padding()
                
                if camera.isRecording {
                    Text("Recording...")
                        .foregroundColor(.red)
                }
                
                
            
//                VideoPlayView(video: $video, image: $camera.thumbnailImage)
            
        }
        
        
    }
}

struct VideoPlayView: View{
    @State private var player: AVPlayer?
    @Binding var video: Video?
    @Binding var image: UIImage?
    var body: some View{
        ZStack(alignment:.bottom){
            VideoPlayer(player: player)
                .task(id: player){
                    guard let url = video?.url else { return }
                    player = AVPlayer(url: url)
                    
                }
            
            HStack{
                
                if let image = image{
                    videoPicker(selectedVideo: $video, thumbnail: image)
                        .frame(width: 64, height: 64)
                }
                
                Spacer()
                
                Button{
                    self.video = nil
                }label:{
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
            }.padding()
        }
    }
}

struct videoPicker: View {
    @State private var selectedItem: PhotosPickerItem?
    @Binding var selectedVideo: Video?
    var thumbnail: UIImage
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .videos) {
            Image(uiImage: thumbnail)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 25))
            
        }.onChange(of: selectedItem){
            Task{
                do{
                    guard let video = try await selectedItem?.loadTransferable(type: Video.self)else{
                        print("load failed")
                        return
                    }
                    selectedVideo = video
                }catch{
                    print(error)
                }
            }
        }
    }
}

#Preview {
    CameraView()
}
