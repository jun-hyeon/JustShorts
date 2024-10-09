//
//  Video.swift
//  JustShorts
//
//  Created by 최준현 on 10/8/24.
//


import AVKit
import PhotosUI
import SwiftUI

struct Video: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie){ movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let origin = received.file
            let filename = origin.lastPathComponent
            let copy = URL.documentsDirectory.appendingPathComponent(filename)
            let filepath = copy.path()
            
            if FileManager.default.fileExists(atPath: copy.path) {
                try FileManager.default.removeItem(atPath: filepath)
            }
            
            try FileManager.default.copyItem(at: origin, to: copy)
            return Video(url: copy)
        }
    }
}
