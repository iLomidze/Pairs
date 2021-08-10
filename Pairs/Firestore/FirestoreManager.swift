//
//  Firestore.swift
//  Pairs
//
//  Created by Irakli Lomidze on 08.08.21.
//

import FirebaseFirestore
import Foundation
import UIKit

class FirestoreManager {
    static let sharedInstance = FirestoreManager()
    
    let firestore = Firestore.firestore()
    
    ///
    func saveHighScore(for userName: String, score: Int) {
        let docRef = firestore.document("HighScores/"+userName)
        docRef.setData(["HighScore" : score], merge: false)
    }
    
    ///
    func fetchAllTheHighScores(completion: @escaping ([String: Int]) -> Void ) {
        var result: [String: Int] = [:]
        
        firestore.collection("HighScores").getDocuments { querySnapshot, error in
            if let error = error {
                print("Firestore - Error getting documents: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    guard let score = document.get("HighScore") as? Int else {
                        print(FirestoreErrorTypes.wrongValueType.rawValue)
                        return
                    }
                    result[document.documentID] = score
                }
            }
            completion(result)
        }
    }
    
    
    ///
    func fetchHighScores(from startIndex: Int, get numOfElements: Int, completion: @escaping ([String: Int]) -> Void ) {
        var result: [String: Int] = [:]
        
        firestore.collection("HighScores").getDocuments { querySnapshot, error in
            if let error = error {
                print("Firestore - Error getting documents: \(error.localizedDescription)")
            } else {
                for (index, document) in querySnapshot!.documents.enumerated() {
                    if index < startIndex || index >= (startIndex + numOfElements) { continue }
                    guard let score = document.get("HighScore") as? Int else {
                        print(FirestoreErrorTypes.wrongValueType.rawValue)
                        return
                    }
                    result[document.documentID] = score
                }
            }
            completion(result)
        }
    }
    
    ///
    func getNumberOfUsers(completion: @escaping (Int) -> Void) {
        firestore.collection("HighScores").getDocuments { querySnapshot, error in
            completion(querySnapshot?.count ?? 0)
        }
    }
    
    ///
    func setScoreIfHigher(for userName: String, score: Int) {
        firestore.document("HighScores/"+userName).getDocument { [weak self] doc, err in
            guard let oldScore = doc?.get("HighScore") as? Int else {
                self?.saveHighScore(for: userName, score: score)
                return
            }
            
            if score < oldScore {
                self?.saveHighScore(for: userName, score: score)
            }
        }
    }
    
    // END CLASS
}
