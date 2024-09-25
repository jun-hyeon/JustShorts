//
//  CameraView.swift
//  JustShorts
//
//  Created by 최준현 on 9/25/24.
//

import SwiftUI
import AVKit

struct CameraContainer: UIViewRepresentable {
    @Binding var session: AVCaptureSession
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            layer.session = session
            layer.frame = uiView.bounds
        }
    }
}


#Preview {
    CameraContainer(session: .constant(AVCaptureSession()))
}
