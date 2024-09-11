//
//  VideoStore.swift
//  JustShorts
//
//  Created by 최준현 on 9/11/24.
//

import Foundation
import Combine
@Observable
class VideoStore{
    var videoList: [VideoListItem] = []
    
    private var cancellable = Set<AnyCancellable>()
    private let networkManager = NetworkManager.shared
    
    func fetchVideoList(search: String, page_current: Int, per_page: Int) async{
        let search = URLQueryItem(name: "search", value: search)
        let page_current = URLQueryItem(name: "page_current", value: "\(page_current)")
        let per_page = URLQueryItem(name: "per_page", value: "\(per_page)")
        let resource =  Resource(url: "/videos/list", method: .get([search, page_current, per_page]), responseType: VideoListResponse.self)
        do{
            try await networkManager.load(resource)
                .sink { completion in
                    switch completion{
                    case .finished:
                        print("videolist networking success")
                    case .failure(let error):
                        print(error)
                    }
                } receiveValue: { response in
                    print(response)
                    if response.success{
                        self.videoList = response.list
                    }
                }.store(in: &cancellable)

        }catch{
            print(error)
        }
        
    }
}
