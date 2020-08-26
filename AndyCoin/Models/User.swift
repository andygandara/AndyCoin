//
//  User.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/24/20.
//

import Foundation
import  FirebaseFirestoreSwift

struct ACUser: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
}
