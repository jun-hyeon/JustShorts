//
//  CameraView.swift
//  JustShorts
//
//  Created by 최준현 on 9/25/24.
//

import SwiftUI
import AVKit

struct CameraPreview: UIViewRepresentable {
    
    
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = PreviewView()
        if let previewLayer = view.previewLayer{
            previewLayer.session = session
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.videoRotationAngle = 90.0
        }
        
       return view
     }

     func updateUIView(_ uiView: UIView, context: Context) {
       
     }
}

class PreviewView: UIView{
    override class var layerClass: AnyClass{
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer?{
        layer as? AVCaptureVideoPreviewLayer
    }
    
}
