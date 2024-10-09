//
//  CameraManager.swift
//  JustShorts
//
//  Created by 최준현 on 9/25/24.
//

import Foundation
import AVFoundation
import Photos
import UIKit

class Camera: NSObject, AVCaptureFileOutputRecordingDelegate, ObservableObject{
    
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
    
    @Published var session = AVCaptureSession() // session is now @Published
    @Published var isRecording = false
    @Published var thumbnailImage: UIImage?
    private let movieOutput = AVCaptureMovieFileOutput()
    
    override
    init(){
        super.init()
        fetchRecentVideoThumbnail()
        
        Task{
            await configureSession()
        }
    }
    
    private func configureSession() async{
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async{
                
                self.session.beginConfiguration()
                self.addAudioInput()
                self.addVideoInput()
                
                if self.session.canAddOutput(self.movieOutput) {
                    self.session.addOutput(self.movieOutput)
                }
                self.session.commitConfiguration()
                
                self.session.startRunning()
                print("Session started successfully")
                continuation.resume()
            }
        }
        
    }
    
    func switchCamera(){
        guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else { return }
        
        
        session.beginConfiguration()
        
        //기존 입력 제거
        session.removeInput(currentInput)
        
        //새로운 입력 디바이스 설정
        let newCamera = currentInput.device.position == .back ?
        AVCaptureDevice.default(.builtInWideAngleCamera ,for: .video, position: .front) :
        AVCaptureDevice.default(.builtInWideAngleCamera ,for: .video, position: .back)
        
        guard let newInput = try? AVCaptureDeviceInput(device: newCamera!), session.canAddInput(newInput) else { return }
        session.addInput(newInput)
        
        session.commitConfiguration()
        
        if !session.isRunning {
            session.startRunning()
        }
    }
    
    
    private func addAudioInput() {
        guard let device = AVCaptureDevice.default(for: .audio) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        if session.canAddInput(input) {
            session.addInput(input)
        }
    }
    
    private func addVideoInput() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        if session.canAddInput(input) {
            session.addInput(input)
        }
    }
    
    
    func startRecording() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("video.mp4") else { return }
        if movieOutput.isRecording == false {
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(at: url)
            }
            movieOutput.startRecording(to: url, recordingDelegate: self)
            isRecording = true
        }
    }
    
    func stopRecording() {
        if movieOutput.isRecording {
            movieOutput.stopRecording()
            isRecording = false
        }
    }
    
    
    func fetchRecentVideoThumbnail(){
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        guard let asset = fetchResult.firstObject else {
            print("최근 비디오가 없습니다.")
            return
        }
        
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 300, height: 300)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            if let image = image{
                self.thumbnailImage = image
            }else{
                print("썸네일 생성 실패")
            }
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput,
                    didStartRecordingTo fileURL: URL,
                    from connections: [AVCaptureConnection]) {
        // Handle actions when recording starts
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // Check for recording error
        if let error = error {
            print("Error recording: \(error.localizedDescription)")
            return
        }
        
        // Save video to Photos
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }) { saved, error in
            if saved {
                print("Successfully saved video to Photos.")
            } else if let error = error {
                print("Error saving video to Photos: \(error.localizedDescription)")
            }
        }
    }
}
