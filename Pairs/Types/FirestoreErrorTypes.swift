//
//  FirestoreErrorTypes.swift
//  Pairs
//
//  Created by Irakli Lomidze on 10.08.21.
//

import Foundation
import UIKit


enum FirestoreErrorTypes: String {
    case noDocumentFound = "No Document Was Found"
    case wrongValueType = "The value type is different - check the FireStore database values"
}
