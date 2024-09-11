//
//  NetworkManager.swift
//  JustShorts
//
//  Created by 최준현 on 9/9/24.
//

import Foundation
import Combine

enum HTTPMethod{
    case get([URLQueryItem])
    case post(Data?)
    case put(Data?)
    case delete
    
    var name: String{
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

enum NetworkError: Error{
    case badURL
    case badRequest
    case decodingError
    case encodingError
    case httpMethodError
}


struct Resource<T: Decodable>{
    let url: String
    var method: HTTPMethod
    var responseType: T.Type
}

actor NetworkManager{
    static let shared = NetworkManager()
    
    func load<T: Decodable>(_ resource: Resource<T>) throws -> AnyPublisher<T, NetworkError>{
        
        guard let base_url = Bundle.main.base_url else{
            print("No Base_URL")
            throw NetworkError.badURL
        }
        
        guard let url = URL(string: base_url + resource.url) else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        print(url)
        
        var urlRequest  = URLRequest(url: url)
        
        switch resource.method {
            
        case .get(let queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let url = components?.url else{
                throw NetworkError.badRequest
            }
            
            urlRequest = URLRequest(url: url)
            
        case .post(let data):
            
            urlRequest.httpMethod = resource.method.name
            urlRequest.httpBody = data
            
        case .put(let data):
            
            urlRequest.httpMethod = resource.method.name
            urlRequest.httpBody = data
            
            
        case .delete:
            urlRequest.httpMethod = resource.method.name
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else{
                    throw NetworkError.badRequest
                }
                print("status code: ", httpResponse.statusCode)
                let s = String(data: data, encoding: .utf8)
                print("String Message: ",s ?? "")
                return data
            }.decode(type: resource.responseType, decoder: JSONDecoder())
            .receive(on:DispatchQueue.main)
            .mapError({ error -> NetworkError in
                print(error)
                return NetworkError.decodingError
            })
            .eraseToAnyPublisher()
    }
    
    func multipartLoad<T: Codable>(resource: Resource<T>, imageData: Data?) throws -> AnyPublisher<T, NetworkError>{
        
        guard let url = URL(string:resource.url) else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        var urlReqeust = URLRequest(url: url)
        urlReqeust.httpMethod = resource.method.name
        print(resource.method.name)
        
        //헤더 작성
        let uniqString = UUID().uuidString
        let contentType = "multipart/form-data; boundary=\(uniqString)"
        urlReqeust.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        switch resource.method {
            
        case .get(_):
            throw NetworkError.httpMethodError
            
        case .post(let data):
            
            guard let dict = toDictionary(model: data) else{
                throw NetworkError.encodingError
            }
            print(dict)
            
            //form-data작성
            urlReqeust.httpBody = createBody(param: dict,imageData: imageData, boundary: uniqString)
            
        case .put(let data):
            
            guard let dict = toDictionary(model: data) else{
                throw NetworkError.encodingError
            }
            print(dict)
            
            //form-data작성
            urlReqeust.httpBody = createBody(param: dict,imageData: imageData, boundary: uniqString)
            
        case .delete:
            throw NetworkError.httpMethodError
        }
     

        return URLSession.shared.dataTaskPublisher(for: urlReqeust)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else{
                    throw NetworkError.badRequest
                }
                print("status code: ", httpResponse.statusCode)
                let s = String(data: data, encoding: .utf8)
                print("String Message: ",s ?? "")
                return data
            }
            .decode(type: resource.responseType, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError({ error -> NetworkError in
                print(error)
                return NetworkError.decodingError
            })
            .eraseToAnyPublisher()
            
    }
    
    
    private func createBody(param dict: [String : Any], imageData: Data?, boundary: String)->Data{
        
        var body = Data()
        for (key, value) in dict {
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }
        
        if let image = imageData{
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"profile_file\"; filename=\"image.jpg\"\r\n".utf8))
            body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
            body.append(image)
            body.append(Data("\r\n".utf8))
        }
        
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        return body
    }
}
