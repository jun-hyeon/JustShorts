//
//  VideoListResponse.swift
//  JustShorts
//
//  Created by 최준현 on 9/11/24.
//

import Foundation
struct VideoListResponse: Decodable{
    
    let success: Bool
    let message: String
    let list: [VideoListItem]
    let total_count: Int
    let total_page: Int
    
    enum CodingKeys: CodingKey {
        case success
        case message
        case list
        case total_count
        case total_page
    }
}

struct VideoListItem: Decodable, Hashable{
    
    let video_no: Int
    let title: String
    let member_id: String
    let writer: String
    let video_key: String
    let upload_yn: String
    let reg_date: String
    let change_date: String
    let video_url: String
    
    enum CodingKeys: CodingKey {
        case video_no
        case title
        case member_id
        case writer
        case video_key
        case upload_yn
        case reg_date
        case change_date
        case video_url
    }
}
