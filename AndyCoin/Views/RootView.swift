//
//  RootView.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/22/20.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var service: FirestoreService
    @State var signedIn = UserDefaults.standard.value(forKey: "signedIn") as? Bool ?? false
    
    var body: some View {
        Group {
            if signedIn {
                if service.isAdmin {
                    UserBalancesView(service: service)
                        .onAppear(perform: service.startSessionListener)
                } else {
                    BalanceView(service: service,
                                user: service.users.filter { $0.id == service.user?.uid }.first ?? ACUser(id: nil, name: ""))
                        .onAppear(perform: service.startSessionListener)
                }
            } else {
                SignInView(service: service)
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("signInStatusChanged"),
                                                   object: nil,
                                                   queue: .main) { _ in
                let signedIn = UserDefaults.standard.value(forKey: "signedIn") as? Bool ?? false
                self.signedIn = signedIn
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(service: FirestoreService())
    }
}
