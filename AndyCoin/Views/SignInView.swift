//
//  SignInView.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/22/20.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var service: FirestoreService
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Sign In") {
                    service.logIn(email: email, password: password) { result, error in
                        if let error = error {
                            alertMessage = error.localizedDescription
                            showingAlert = true
                            return
                        }
                        
                        UserDefaults.standard.set(true, forKey: "signedIn")
                        NotificationCenter.default.post(name: NSNotification.Name("signInStatusChanged"), object: nil)
                    }
                }
                .padding(.horizontal, 60)
                .padding(.vertical, 8)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding(.top, 20)
            }
            .padding(.horizontal, 40)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Something went wrong"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
    }
}
