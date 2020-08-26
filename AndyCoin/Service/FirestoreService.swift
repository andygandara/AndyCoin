//
//  FirestoreService.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/22/20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreService: ObservableObject {
    private let db = Firestore.firestore()
    private let transactionsPath = "transactions"
    private let usersPath = "users"
    private let adminsPath = "admins"
    private let userIdField = "user_id"
    
    @Published var user: User?
    @Published var isLoggedIn: Bool = false
    @Published var isAdmin: Bool = false
    @Published var transactions: [Transaction] = []
    @Published var balance: Int = 0
    @Published var users: [ACUser] = []
    @Published var adminIds: [String] = []
    
    init() {
        fetchAdmins()
        fetchUsers()
        fetchTransactions()
    }
    
    func startSessionListener() {
        _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.user = user
                self?.isLoggedIn = true
            } else {
                self?.user = nil
                self?.isLoggedIn = false
            }
        }
    }
    
    func logIn(email: String, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func logOut() {
        try! Auth.auth().signOut()
        self.user = nil
        self.isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "signedIn")
        NotificationCenter.default.post(name: NSNotification.Name("signInStatusChanged"), object: nil)
    }
    
    func fetchTransactions(for userId: String? = nil) {
        db.collection(transactionsPath)
            .addSnapshotListener { [weak self] querySnapshot, error in
                self?.transactions = querySnapshot?.documents
                    .compactMap { try? $0.data(as: Transaction.self) }
                    .filter {
                        if let userId = userId {
                            return $0.userId == userId
                        }
                        return true
                    }
                    .sorted { $0.date > $1.date } ?? []
                
                let withdrawalTotal = self?.transactions
                    .filter { $0.type == .withdrawal }
                    .reduce(0) { $0 + $1.amount } ?? 0
                let depositTotal = self?.transactions
                    .filter { $0.type == .deposit }
                    .reduce(0) { $0 + $1.amount } ?? 0
                self?.balance = depositTotal - withdrawalTotal
            }
    }
    
    private func fetchUsers() {
        db.collection(usersPath)
            .order(by: "name", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                self?.users = querySnapshot?.documents.compactMap {
                    try? $0.data(as: ACUser.self)
                } ?? []
            }
    }
    
    private func fetchAdmins() {
        db.collection(adminsPath)
            .addSnapshotListener { [weak self] querySnapshot, error in
                let adminIds = querySnapshot?.documents
                    .compactMap { try? $0.data(as: AdminID.self) }
                    .compactMap { $0.id } ?? []
                self?.adminIds = adminIds
                print(adminIds.contains(self?.user?.uid ?? ""))
                self?.isAdmin = adminIds.contains(self?.user?.uid ?? "")
            }
    }
    
    func addTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let _ = try db.collection(transactionsPath).addDocument(from: transaction)
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func deleteTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(transactionsPath).document(transaction.id ?? "").delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func transactions(for user: ACUser) -> [Transaction] {
        return transactions.filter { $0.userId == user.id }
    }
    
    func balance(for user: ACUser) -> Int {
        let withdrawalTotal = transactions
            .filter { $0.userId == user.id && $0.type == .withdrawal }
            .reduce(0) { $0 + $1.amount }
        let depositTotal = transactions
            .filter { $0.userId == user.id && $0.type == .deposit }
            .reduce(0) { $0 + $1.amount }
        return depositTotal - withdrawalTotal
    }
}
