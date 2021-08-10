//
//  FirebaseAuthErrorTypes.swift
//  Pairs
//
//  Created by Irakli Lomidze on 09.08.21.
//

import Foundation
import UIKit


enum FirebaseAuthErrorTypes: String {
    case incorrectPassword = "The password is invalid or the user does not have a password."
    case manyPasswordTimes = "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."
}
