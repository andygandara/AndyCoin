//
//  Transaction.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/22/20.
//

import Foundation
import FirebaseFirestoreSwift

enum TransactionType: String, Codable, CaseIterable {
    case deposit, withdrawal
}

struct Transaction: Codable, Identifiable {
    @DocumentID var id: String?
    let userId: String
    let title: String
    let type: TransactionType
    let amount: Int
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case type
        case amount
        case date
    }
}
