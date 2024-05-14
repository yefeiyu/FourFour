//
//  File.swift
//  FourDay
//
//  Created by Charles Thomas on 2024/5/8.

import SwiftUI
import SwiftSoup
import CryptoKit
func MD5(_ string: String) -> String {
    let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
struct LoginPageView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated = false

    @State private var usernamePlaceholder: String = "Username"
    @State private var passwordLabel: String = "Password"
    @State private var questions: [(value: String, text: String)] = []
    @State private var securityAnswer: String = ""
    @State private var loginButtonText: String = "Login"
    @State private var rememberMeChecked: Bool = false
    @State private var rememberMeLabel: String = "Remember Me"
    @State private var loginError: String?
    var networkManager = NetworkManager()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("用户登录").font(.title2)) {
                    TextField("用户名", text: $username)
                        .foregroundColor(Color.gray)
                    SecureField("密码", text: $password)
                        .foregroundColor(Color.gray)
                    Picker("", selection: $securityAnswer) {
                        ForEach(questions, id: \.value) { question in
                            Text(question.text).tag(question.value)
                        }
                    }
                    //TextField("Answer", text: $securityAnswer)
                    TextField("Answer", text: $securityAnswer)
//                    Button(loginButtonText) {
                    Button("  登录  ") {
                        Task {
                            await loginUser()
                        }
                    }
                    .font(.title2)  // 设置字体大小为 title3
                    .foregroundColor(.white)  // 设置文字颜色为白色
                    .background(Color.black)  // 设置背景颜色为蓝色
                    .cornerRadius(4)  // 设置边角圆滑
                    Toggle(isOn: $rememberMeChecked) {
                        Text(rememberMeLabel)
                    }
                }
            }
            .navigationTitle(Text("4DAY 4YEAR").foregroundColor(Color.purple).font(.title))
            .background(NavigationLink("", destination: ForumListView(), isActive: $isAuthenticated))
        }
        .onAppear {
            Task {
                await loadLoginPage()
            }
        }
    }

    func loginUser() async {
        guard let url = ForumURLs.loginPage(), !username.isEmpty, !password.isEmpty  else { loginError = "Username or password cannot be empty"
            return }
        let hashedPassword = MD5(password)
        let loginData = "action=login&loginsubmit=yes&inajax=1&formhash=67709ebe&referer=https%3A%2F%2Fwww.4d4y.com%2Fforum%2Findex.php&loginfield=username&username=\(username)&password=\(hashedPassword)&questionid=0&answer="

        do {
                let isSuccess = try await networkManager.login(url: url, loginData: loginData)
                isAuthenticated = isSuccess
                if !isSuccess {
                    loginError = "Invalid username or password"
                }
            } catch {
                print("Login error: \(error)")
                loginError = "Failed to login: \(error.localizedDescription)"
            }
    }

    func loadLoginPage() async {
        guard let url = ForumURLs.loginPage() else { return }
        do {
            let html = try await networkManager.fetchData(from: url)
            let parsedData = try parseLoginPage(html: html)
            DispatchQueue.main.async {
                updateUI(with: parsedData)
            }
        } catch {
            print("Failed to fetch or parse HTML: \(error)")
        }
    }

    func updateUI(with data: (usernamePlaceholder: String?, passwordLabel: String?, securityQuestions: [(value: String, text: String)], securityAnswerStyle: String?, loginButtonText: String?, rememberMeChecked: Bool, rememberMeLabel: String)) {
        usernamePlaceholder = data.usernamePlaceholder ?? "Username"
        passwordLabel = data.passwordLabel ?? "Password"
        questions = data.securityQuestions
        securityAnswer = data.securityAnswerStyle ?? ""
        loginButtonText = data.loginButtonText ?? "Login"
        rememberMeChecked = data.rememberMeChecked
        rememberMeLabel = data.rememberMeLabel
    }
}

#Preview {
    LoginPageView()
}
