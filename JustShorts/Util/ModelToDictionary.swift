//
//  ModelToDictionary.swift
//  JustShorts
//
//  Created by 최준현 on 9/11/24.
//

import Foundation

func toDictionary<T: Encodable>(model: T) -> [String : Any]?{
    do {
        let jsonData = try JSONEncoder().encode(model)
        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            return json.compactMapValues { $0 }
        }
    } catch {
        print("Error converting model to parameters: \(error)")
    }
    return nil
}

func toQueryItem<T: Encodable>(model: T) -> [URLQueryItem]{
    guard let dict = toDictionary(model: model) else{
        return []
    }
    return dict.map{URLQueryItem(name: $0.key, value: "\($0.value)")}
}

