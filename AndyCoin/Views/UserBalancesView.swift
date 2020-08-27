//
//  UserBalancesView.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/25/20.
//

import SwiftUI

struct UserBalancesView: View {
    @ObservedObject var service: FirestoreService
    @State var presentAddTransactionView = false
    
    func togglePresentAddTransactionView() {
        presentAddTransactionView.toggle()
    }
    
    func getTrailingButton() -> AnyView? {
        if service.isAdmin {
            return AnyView(
                Button(action: togglePresentAddTransactionView) {
                    Image(systemName: "dollarsign.circle.fill")
                        .imageScale(.large)
                        .padding(4)
                }
            )
        }
        return nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(service.users) { user in
                        UserBalanceRowView(service: service, user: user)
                    }
                }
            }
            .navigationBarItems(leading: Button(action: service.logOut, label: { Text("Sign out") }),
                                trailing: getTrailingButton())
            .navigationBarTitle(Text("AndyCoin Balances"))
            .sheet(isPresented: $presentAddTransactionView) { AddTransactionView(service: service) }
        }
    }
}
