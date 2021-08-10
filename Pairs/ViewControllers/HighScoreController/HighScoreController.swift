//
//  HighScoreController.swift
//  Pairs
//
//  Created by Irakli Lomidze on 10.08.21.
//

import UIKit

class HighScoreController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var highScoresLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var languagePicked: String?
    var numberOfScores = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScoresLabel.text = "High Scores".localized(lang: languagePicked)
        
        FirestoreManager.sharedInstance.getNumberOfUsers { [weak self] count in
            self?.numberOfScores = count
        }
    }
    
    // END CLASS
}


extension HighScoreController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfScores
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        FirestoreManager.sharedInstance.fetchHighScores(from: indexPath.row, get: 1) { result in
            guard let user = result.keys.first else { return }
            cell.textLabel?.text = "\(user) - \(result[user] ?? 0)"
        }
        return cell
    }
    
    
}
