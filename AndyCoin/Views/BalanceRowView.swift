//
//  BalanceRowView.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/22/20.
//

import SwiftUI

struct BalanceRowView: View {
    var transaction: Transaction
    
    func getColor() -> Color {
        return transaction.type == .deposit ? Color("Green") : Color("Red")
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
    }
}
