//
//  BalanceView.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/22/20.
//

import SwiftUI

struct BalanceView: View {
    @ObservedObject var service: FirestoreService
    @State var title: String = "AndyCoin Balance"
    var user: ACUser
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    Color(UIColor.secondarySystemGroupedBackground)
                    Text(service.balance(for: user).andyCoinFormatted)
                        .font(.system(.largeTitle, design: .monospaced))
                        .fontWeight(.semibold)
                    
                }
                .frame(height: 140)
                .cornerRadius(20)
                .padding(.horizontal, 60)
                .padding(.vertical, 40)
                
                if #available(iOS 14.0, *) {
                    List {
                        ForEach(service.transactions(for: user)) { transaction in
                            BalanceRowView(service: service, transaction: transaction)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                } else {
                    List {
                        ForEach(service.transactions(for: user)) { transaction in
                            BalanceRowView(service: service, transaction: transaction)
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarTitle(Text(title))
        }
    }
}

