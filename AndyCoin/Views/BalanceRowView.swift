//
//  BalanceRowView.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/22/20.
//

import SwiftUI

struct BalanceRowView: View {
    @ObservedObject var service: FirestoreService
    @State private var showingAlert = false
    @State private var alertMessage = ""
    var transaction: Transaction
    
    func getColor() -> Color {
        return transaction.type == .deposit ? Color("Green") : Color("Red")
    }
    
    func getDeleteOption() -> AnyView? {
        if service.isAdmin {
            return AnyView(Button(action: {
                service.deleteTransaction(transaction) { result in
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        alertMessage = error.localizedDescription
                        showingAlert = true
                    }
                }
            }) {
                Text("Delete")
                Image(systemName: "trash.fill")
            })
        }
        return nil
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.date.formatted(dateStyle: .medium, timeStyle: .none))
                    .font(.subheadline)
            }
            
            Spacer()
            
            Text(transaction.amount.andyCoinFormatted)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.semibold)
                .foregroundColor(getColor())
        }
        .padding(.horizontal, 12)
        .contextMenu { getDeleteOption() }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Something went wrong"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}
