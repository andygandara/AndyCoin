//
//  AddTransactionView.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/24/20.
//

import SwiftUI
import Combine

struct AddTransactionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var service: FirestoreService
    @State var title: String = ""
    @State var amount: String = ""
    @State var date: Date = Date()
    @State var userSelectionIndex = 0
    @State var typeSelectionIndex = 0
    var typeOptions = TransactionType.allCases.map { $0.rawValue.capitalized }
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertButtonTitle = ""
    @State private var alertButtonHandler = {}
    
    
    func submitTransaction() {
        guard let userId = service.users[userSelectionIndex].id, !amount.isEmpty, !title.isEmpty else {
            alertTitle = "Error"
            alertMessage = "Make sure all fields are entered."
            alertButtonTitle = "OK"
            showingAlert = true
            return
        }
        let transaction = Transaction(id: UUID().uuidString,
                                      userId: userId,
                                      title: title,
                                      type: TransactionType.allCases[typeSelectionIndex],
                                      amount: Int(amount) ?? 0,
                                      date: date)
        service.addTransaction(transaction) { result in
            alertTitle = "Success!"
            alertMessage = "Transaction was successfully added."
            alertButtonTitle = "Cool"
            alertButtonHandler = {
                self.presentationMode.wrappedValue.dismiss()
            }
            showingAlert = true
            self.resetFields()
        }
    }
    
    func resetFields() {
        title = ""
        amount = ""
        date = Date()
        userSelectionIndex = 0
        typeSelectionIndex = 0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select account", selection: $userSelectionIndex) {
                        ForEach(0..<service.users.count, id: \.self) {
                            Text(self.service.users[$0].name).tag(service.users[$0].id)
                        }
                    }
                    
                    Picker("Transaction type", selection: $typeSelectionIndex) {
                        ForEach(0..<typeOptions.count) {
                            Text(self.typeOptions[$0])
                        }
                    }
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                        .onReceive(Just(amount)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.amount = filtered
                            }
                        }
                    
                    TextField("What is this for?", text: $title) {
                        UIApplication.shared.endEditing()
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button("Submit transaction") {
                        submitTransaction()
                    }
                }
            }
            .navigationBarTitle(Text("Add Transaction"))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(alertMessage),
                      dismissButton: .default(Text(alertButtonTitle)) { alertButtonHandler() })
            }
        }
    }
}
