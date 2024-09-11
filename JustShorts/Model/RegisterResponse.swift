//
//  RegisterResponse.swift
//  JustShorts
//
//  Created by 최준현 on 9/9/24.
//

import Foundation

struct RegisterModel: Codable{
    var member_id: String
    var member_pwd: String
    var member_nickname: String
    
    
    enum CodingKeys: CodingKey {
        case member_id
        case member_pwd
        case member_nickname
    }
}

struct RegisterResponse: Codable{
    let success: Bool
    let message: String
    
    
    enum CodingKeys: CodingKey {
        case success
        case message
    }
}

