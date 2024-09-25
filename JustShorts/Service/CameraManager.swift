//
//  CameraManager.swift
//  JustShorts
//
//  Created by 최준현 on 9/25/24.
//

import Foundation
import AVFoundation
import Photos

@Observable
class CameraManager: NSObject, AVCaptureFileOutputRecordingDelegate{
    
    var session = AVCaptureSession()
    var isRecording: Bool = false
    
    var isAuthorized: Bool {
        get async{
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAuthorized = status == .authorized
            
            if status == .notDetermined{
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            return isAuthorized
        }
    }
    
    private let movieOutPut = AVCaptureMovieFileOutput()
    
    
    override init(){
        super.init()
        Task{
            await isAuthorized
        }
        addAudioInput()
        addVideoInput()
        if session.canAddOutput(movieOutPut){
            session.addOutput(movieOutPut)
        }
        DispatchQueue.global(qos: .userInitiated).async{ [weak self] in
            self?.session.startRunning()
        }
    }
    
    private func addAudioInput(){
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {return}
        guard let audioInput = try? AVCaptureDeviceInput(device: audioDevice) else { return }
        if session.canAddInput(audioInput){
            session.addInput(audioInput)
        }
    }
    
    private func addVideoInput(){
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        if session.canAddInput(videoInput){
            session.addInput(videoInput)
        }
    }
    
    
    func startRecording(){
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("video.mp4") else {return}
        if movieOutPut.isRecording == false{
            if FileManager.default.fileExists(atPath: url.path()){
                try? FileManager.default.removeItem(at: url)
            }
            movieOutPut.startRecording(to: url, recordingDelegate: self)
            isRecording = true
        }
    }
    
    func stopRecording(){
        if movieOutPut.isRecording{
            movieOutPut.stopRecording()
            isRecording = false
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error = error{
            print("Error recording: \(error.localizedDescription)")
            return
        }
        
        //Save video to Photos
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }) { success, error in
            if success{
                print("Successfully saved video to Photos")
            }else if let error = error{
                print("Error saving video to Photos: \(error.localizedDescription)")
            }
        }
    }
    
    
}
