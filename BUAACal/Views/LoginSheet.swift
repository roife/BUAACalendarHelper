//
//  LoginSheet.swift
//  BUAACal
//
//  Created by roife on 10/4/20.
//

import SwiftUI

struct LoginSheet: View {
    @Binding var isLoginSheetPresented: Bool
    @Binding var isUpdating: Bool
    @Binding var isLogined: Bool
    @ObservedObject var loginVM = LoginViewModel()
    
    @State var loginFailed: Bool = false
    @State var showReloginAlert: Bool = false
    
    var body: some View {
        if loginVM.isLogin {
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
                    Section(header: Text(loginVM.currentUserId.isEmpty ? "登录信息北航"
                                            : isLogined ? "当前用户：\(loginVM.currentUserId) （已登录）"
                                            : "当前用户：\(loginVM.currentUserId) （未登录）")) {
                        TextField("学号", text: $loginVM.userId)
                            .keyboardType(.numberPad)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        SecureField("密码", text: $loginVM.password)
                    }
                    Section() {
                        Button("登录并更新") {
                            if isLogined {
                                showReloginAlert = true
                            } else {
                                loginVM.login(loginSheet: self)
                            }
                        }
                        .disabled(loginVM.userId.isEmpty || loginVM.password.isEmpty)
                        .alert(isPresented: $showReloginAlert) {
                            Alert(title: Text("登录提醒"),
                                  message: Text("检测到您已经登录账号，是否切换用户？"),
                                  primaryButton: .destructive(Text("确定")) {
                                    loginVM.login(loginSheet: self)
                                  },
                                  secondaryButton: .cancel(Text("取消")))
                        }
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
