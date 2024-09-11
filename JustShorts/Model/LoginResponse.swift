//
//  LoginResponse.swift
//  JustShorts
//
//  Created by 최준현 on 9/9/24.
//

import Foundation

struct LoginModel: Encodable{
    var member_id: String
    var member_pwd: String
    
    enum CodingKeys: CodingKey{
        case member_id
        case member_pwd
    }
}

struct LoginResponse: Codable{
    let success: Bool
    let message: String
    let data: LoginInfo?
}

struct LoginInfo: Codable{
    let member_id: String
    let member_nickname: String
    
    enum CodingKeys: CodingKey {
        case member_id
        case member_nickname
    }
    
    
}
