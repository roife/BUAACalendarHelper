//
//  LoginViewModel.swift
//  BUAACal
//
//  Created by roife on 10/4/20.
//

import Foundation

class LoginViewModel:ObservableObject {
    // MARK: Login Info
    @Published var email:String = ""
    @Published var password:String = ""
    
    func login() {
        let url = URL(string: "https://app.buaa.edu.cn/uc/wap/login/check")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let body: [String: Any] = [
            "username": email,
            "password": password
        ]
        request.setValue("application/x-www-form-urlencoded; charset=utf-8",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36",
                         forHTTPHeaderField: "User-Agent")
        request.httpBody = body.percentEncoded()
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
//            let cookieName = "eai-sess"
//            if let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName }) {
//                print("\(cookieName): \(cookie.value)")
//            }
        }
        
        task.resume()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
