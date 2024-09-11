//
//  ContentView.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import SwiftUI

struct LoginScreen: View {
    @Bindable var authStore: AuthStore
    @State var email = ""
    @State var password = ""
    @State private var path = NavigationPath()
    @State private var showMessage = false
    var type : ToastStyle{
        switch authStore.loginState {
        case .login:
                .success
        case .logout:
                .success
        case .loading:
                .info
        case .loginfail(_):
                .error
        }
    }
    var body: some View {
        NavigationStack(path: $path){
            ZStack(alignment:.bottom){
                if authStore.loginState == .loading{
                    ProgressView()
                }else{
                    
                    VStack(spacing: 80){
                        Text("Just Shorts")
                            .font(.system(size: 60))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)
                        
                        VStack{
                            TextFieldWithCaption(caption: "email", titleKey: "Email을 입력해주세요", text: $email, isSecureField: false)
                                .padding(.vertical)
                            
                            
                            TextFieldWithCaption(caption: "password", titleKey: "Password를 입력해주세요", text: $password, isSecureField: true)
                                .padding(.vertical)
                        }
                        
                        VStack{
                            Button{
                                //로그인
                                Task{
                                    await authStore.login(email: email, password: password)
                                }
                                showMessage.toggle()
                            }label:{
                                Text("로그인")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(CustomButtonStyle(color: .blue))
                            .padding(.vertical)
                            
                            
                            NavigationLink{
                                //회원가입
                                withAnimation(.easeIn){
                                    SignUpScreen(authStore: authStore)
                                }
                                
                            }label:{
                                Text("회원가입")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(CustomButtonStyle(color: .blue))
                            .padding(.vertical)
                        }
                    }
                    .padding()
                    if showMessage{
                        withAnimation(.spring(duration: 0.5)) {
                            ToastMessage(type: type, title: "로그인 정보", message: authStore.loginMessage) {
                                showMessage.toggle()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LoginScreen(authStore: AuthStore())
}
