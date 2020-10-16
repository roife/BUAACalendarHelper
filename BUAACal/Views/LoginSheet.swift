//
//  LoginSheet.swift
//  BUAACal
//
//  Created by roife on 10/4/20.
//

import SwiftUI

struct LoginSheet: View {
    @Binding var isLoginSheetPresented:Bool
    @Binding var isUpdating:Bool
    @Binding var isLogined:Bool
    @ObservedObject var loginVM = LoginViewModel()
    
    @State var loginFailed:Bool = false
    
    var body: some View {
        if loginVM.isLogining {
            ProgressView("登录中...")
                .progressViewStyle(CircularProgressViewStyle())
                .onDisappear() {
                    if !loginFailed {
                        isLoginSheetPresented.toggle()
                        
                    }
                }
        } else {
            NavigationView {
                Form {
                    Section(header: Text("登录信息北航")) {
                        TextField("学号", text: $loginVM.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        SecureField("密码", text: $loginVM.password)
                    }
                    Section {
                        Button ("登录并更新") {
                            loginVM.login(loginSheet: self)
                        }
                        .disabled(loginVM.email.isEmpty || loginVM.password.isEmpty)
                    }
                }
                .navigationBarTitle(Text("登录"), displayMode: .inline)
            }
            .alert(isPresented: $loginFailed) {
                Alert(title: Text("登陆发生错误"), message: Text("请检查学号和密码是否输入正确"), dismissButton: .default(Text("好")))
            }
        }
    }
}
