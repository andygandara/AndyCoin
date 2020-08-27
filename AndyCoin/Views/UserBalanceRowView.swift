//
//  UserBalanceRowView.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/26/20.
//

import SwiftUI

struct UserBalanceRowView: View {
    @ObservedObject var service: FirestoreService
    var user: ACUser
    
    var body: some View {
        NavigationLink(destination: BalanceView(service: service, title: user.name, user: user, isAdminView: true)) {
            HStack {
                Text(user.name)
                    .fontWeight(.medium)
                Spacer()
                Text(service.balance(for: user).andyCoinFormatted)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
        }
    }
}
