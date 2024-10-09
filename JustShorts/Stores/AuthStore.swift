//
//  AuthStore.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import Foundation
import UIKit
import Combine

enum LoginState: Equatable{
    case login
    case logout
    case loading
    case loginfail(error: String)
}

enum SignUpState: Equatable{
    case none
    case success
    case loading
    case fail(error: String)
}

@Observable class AuthStore{
    var loginState: LoginState = .login
    var registerState: SignUpState = .none
    var loginMessage = ""
    var registerMessage = ""
    private let networkManager = NetworkManager.shared
    
    private var loginCancellable : Set<AnyCancellable> = []
    private var signUpCancellable: Set<AnyCancellable> = []
    
    
    func login(email: String, password: String) async {
        loginState = .loading
        
        let loginModel = LoginModel(member_id: email, member_pwd: password)
        
         do{
             let resource = try Resource(url: "/auth/login", method: .post(JSONEncoder().encode(loginModel)), responseType: LoginResponse.self)
             try await networkManager.load(resource)
                    .sink { completion in
                        switch completion{
                        case .finished:
                            print("Login Success")
                        case .failure(let error):
                            print(error)
                            self.loginState = .loginfail(error: "\(error)")
                        }
                    } receiveValue: {  response in
                        print(response)
                        self.loginMessage = response.message
                        
                        if response.success{
                            print(response.data ?? "")
                            self.loginState = .login
                        }else{
                            self.loginState = .loginfail(error: response.message)
                        }
                    }.store(in: &loginCancellable)
         }catch{
             print(error)
         }
    }//login
    
    func register(nickName: String, email: String, password: String, profileImage: UIImage?) async {
        registerState = .loading
        let data = profileImage?.jpegData(compressionQuality: 0.5)
        let registerModel = RegisterModel(member_id: email, member_pwd: password, member_nickname: nickName)
        
        do{
            let resource = try Resource(url: "/auth/register", method: .post(JSONEncoder().encode(registerModel)), responseType: RegisterResponse.self)
            try await networkManager.multipartLoad(resource: resource, data: data, type: .image)
                .sink { [weak self] completion in
                    switch completion{
                        
                    case .finished:
                        print("signup networking success")
                        
                    case .failure(let error):
                        print("signup networking fail")
                        print(error)
                        self?.registerState = .fail(error: "\(error)")
                    }
                } receiveValue: { [weak self] response in
                    self?.registerMessage = response.message
                    if response.success{
                        self?.registerState = .success
                    }else{
                        self?.registerState = .fail(error: response.message)
                    }
                    print(response)
                }.store(in: &signUpCancellable)

        }catch{
            print(error)
        }
    }//signup()
    
    func logout(){
        
    }//logout
}//class
