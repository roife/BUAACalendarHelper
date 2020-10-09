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
    
    var body: some View {
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
                        loginVM.login()
                        self.isLoginSheetPresented.toggle()
                        self.isUpdating.toggle()
                        self.isLogined = true
                    }
                }
            }
            .navigationBarTitle(Text("登录"), displayMode: .inline)
        }
    }
}
