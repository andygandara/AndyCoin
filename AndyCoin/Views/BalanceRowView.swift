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
        return transaction.type == .deposit
            ? Color("Green")//(UIColor(red: 34/260, green: 139/260, blue: 34/260, alpha: 1))
            : Color("Red")
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.headline)
                Text(transaction.dateString)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Text(transaction.amountString)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.semibold)
                .foregroundColor(getColor())
        }
        .padding(.horizontal, 12)
    }
}

struct BalanceRowView_Previews: PreviewProvider {
    static var previews: some View {
        let transaction = Transaction(id: "",
                                      userId: "",
                                      title: "Nomination from Chang",
                                      type: .deposit,
                                      amount: 25,
                                      date: Date())
        BalanceRowView(transaction: transaction)
    }
}
