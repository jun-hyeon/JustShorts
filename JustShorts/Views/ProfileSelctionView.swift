//
//  ProfileSelctionView.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import SwiftUI
import PhotosUI
struct ProfileSelctionView: View {
    @State private var photosPickerItem : PhotosPickerItem?
    @Binding var photoImage: UIImage?
    var body: some View {
            VStack{
                PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()){
                    if let image = photoImage{
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            
                    }else{
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.black)
                    }
                }
                .frame(width: 90, height: 90)
                .clipped()
                .clipShape(Circle())
                .overlay{
                    Circle().stroke(.white, lineWidth: 2)
                }
                .shadow(radius: 6)
                .padding()
                .task(id: photosPickerItem){
                    guard let data = try? await photosPickerItem?.loadTransferable(type: Data.self)else{
                        return
                    }
                    photoImage = UIImage(data: data)
                }
            }
            
    }
}


