//
//  AdminID.swift
//  AndyCoin
//
//  Created by Andy Gandara on 8/26/20.
//

import Foundation
import FirebaseFirestoreSwift

struct AdminID: Codable{
    @DocumentID var id: String?
}
