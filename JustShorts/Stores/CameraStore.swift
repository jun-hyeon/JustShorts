//
//  CameraStore.swift
//  JustShorts
//
//  Created by 최준현 on 10/8/24.
//
import Foundation
import AVFoundation
import Photos
import UIKit

@Observable
class CameraStore{
    private var camera: Camera
    private var session: AVCaptureSession
    var isRecording: Bool = false
    var thumbnail: UIImage?
    
    
    init() {
        camera = Camera()
        session = camera.session
        
    }
    
    func startRecording(){
        camera.startRecording()
        isRecording = true
    }
    
    func stopRecording(){
        camera.stopRecording()
        isRecording = false
    }
    
   
    
}
