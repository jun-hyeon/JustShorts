//
//  CameraScreen.swift
//  JustShorts
//
//  Created by 최준현 on 9/25/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var camera = CameraManager()
    var body: some View {
        CameraContainer(session: $camera.session)
            .frame(height: 400)
        HStack{
            Button{
                camera.startRecording()
            }label:{
                Text("Start Recording")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(camera.isRecording)
            
            Button{
                camera.stopRecording()
            }label:{
                Text("Stop Recording")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(!camera.isRecording)
        }
    }
}

#Preview {
    CameraView()
}
