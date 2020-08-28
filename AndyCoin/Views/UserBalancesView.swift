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
    
    func getSelf() -> ACUser? {
        return service.users.filter { $0.id == service.user?.uid }.first
    }
    
    func getOtherUsers() -> [ACUser] {
        return service.users.filter { $0.id != service.user?.uid }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                List {
                    if getSelf() != nil {
                        Section {
                            UserBalanceRowView(service: service, user: getSelf()!)
                        }
                    }
                    
                    Section {
                        ForEach(getOtherUsers()) { user in
                            UserBalanceRowView(service: service, user: user)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarItems(leading: Button(action: service.logOut, label: { Text("Sign out") }),
                                    trailing: getTrailingButton())
                .navigationBarTitle(Text("AndyCoin Balances"))
                .sheet(isPresented: $presentAddTransactionView) { AddTransactionView(service: service) }
            } else {
                List {
                    if getSelf() != nil {
                        Section {
                            UserBalanceRowView(service: service, user: getSelf()!)
                        }
                    }
                    
                    Section {
                        ForEach(getOtherUsers()) { user in
                            UserBalanceRowView(service: service, user: user)
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarItems(leading: Button(action: service.logOut, label: { Text("Sign out") }),
                                    trailing: getTrailingButton())
                .navigationBarTitle(Text("AndyCoin Balances"))
                .sheet(isPresented: $presentAddTransactionView) { AddTransactionView(service: service) }
            }
        }
    }
}
