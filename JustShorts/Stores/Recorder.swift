//
//  Recorder.swift
//  JustShorts
//
//  Created by 최준현 on 9/23/24.
//

import Foundation
import AVFoundation
@Observable
class Recorder: NSObject, AVCaptureFileOutputRecordingDelegate {
    
    var session = AVCaptureSession()
    var isRecording = false
    private let movieOutPut = AVCaptureMovieFileOutput()
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        <#code#>
    }
    
}
