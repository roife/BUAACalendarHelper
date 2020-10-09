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
                        if 1 == 2 {
                            
                        }
                    }
                }
            }
            .navigationBarTitle(Text("登录"), displayMode: .inline)
        }
    }
}

//struct LoginSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginSheet()
//    }
//}
