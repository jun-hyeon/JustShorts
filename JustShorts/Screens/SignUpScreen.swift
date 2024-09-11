//
//  SignUpScreen.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import SwiftUI

struct SignUpScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var authStore: AuthStore
    @State private var email = ""
    @State private var nickName = ""
    @State private var password = ""
    @State private var passwordCheck = ""
    @State private var photoImage: UIImage?
    
    @State private var emailError = true
    @State private var passwordError = true
    @State private var passwordCheckError = true
    @State private var nickNameError = true
    
    var isValid : Bool{
        //true면 ok
        isValidEmail(email: email) && !nickNameError && !passwordError && !passwordCheckError
    }
  
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    var body: some View {
        NavigationStack{
            
            Spacer()
            
            VStack(spacing: 40){
                
                
                ProfileSelctionView(photoImage: $photoImage)
                
                VStack(alignment:.leading){
                    TextFieldWithLine(caption: "Email", titleKey: "Email을 입력해주세요", text: $email, isSecureField: false)
                    Text("이메일 형식에 맞춰서 입력해주세요.")
                        .font(.caption2)
                        .foregroundStyle(isValidEmail(email: email) ? .clear : .red)
                }
                
                VStack(alignment: .leading){
                    TextFieldWithLine(caption: "Nickname", titleKey: "사용하실 Nickname을 입력해주세요", text: $nickName, isSecureField: false)
                        .onChange(of: nickName){
                            nickNameError = nickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && nickName.count < 4 || nickName.isEmpty ? true : false
                        }
                    Text("4글자 이상 입력해주세요")
                        .font(.caption2)
                        .foregroundStyle(nickNameError ? .red : .clear)
                }
                
                VStack(alignment:.leading){
                    TextFieldWithLine(caption: "Password", titleKey: "비밀번호를 입력해주세요", text: $password, isSecureField: true)
                        .onChange(of: password){
                            passwordError = password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.count < 4 || password.isEmpty ? true : false
                        }
                    Text("비밀번호를 4글자 이상 입력해주세요")
                        .font(.caption2)
                        .foregroundStyle(passwordError ? .red : .clear)
                }
            
                VStack(alignment:.leading){
                    TextFieldWithLine(caption: "Password", titleKey: "비밀번호를 한번 더 입력해주세요", text: $passwordCheck, isSecureField: true)
                        .onChange(of: passwordCheck) {
                            passwordCheckError = (password != passwordCheck) ? true : false
                        }
                    Text("비밀번호를 다시 확인해주세요")
                        .font(.caption2)
                        .foregroundStyle(passwordCheckError ? .red : .clear)
                }
                
                Spacer()
               
            }.padding()
            
            Button{
                //회원가입
                print("clicked")
                Task{
                    await authStore.register(nickName: nickName, email: email, password: password, profileImage: photoImage)
                }
                dismiss()
                
            }label:{
                Text("회원가입")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(CustomButtonStyle(color: isValid ? .blue : .gray))
            .background()
            .padding()
            .disabled(!isValid)
        }
    }
}

#Preview {
    SignUpScreen(authStore: AuthStore())
}
