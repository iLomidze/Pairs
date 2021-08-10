//
//  ViewController.swift
//  Pairs
//
//  Created by Irakli Lomidze on 05.08.21.
//

import UIKit

class GameController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var card1: UIButton!
    @IBOutlet weak var card2: UIButton!
    @IBOutlet weak var card3: UIButton!
    @IBOutlet weak var card4: UIButton!
    @IBOutlet weak var card5: UIButton!
    @IBOutlet weak var card6: UIButton!
    @IBOutlet weak var card7: UIButton!
    @IBOutlet weak var card8: UIButton!
    @IBOutlet weak var card9: UIButton!
    @IBOutlet weak var card10: UIButton!
    @IBOutlet weak var card11: UIButton!
    @IBOutlet weak var card12: UIButton!
    @IBOutlet weak var card13: UIButton!
    @IBOutlet weak var card14: UIButton!
    
    
    
    
    // MARK: - Properties
    
    let numOfRows: CGFloat = 7
    let numOfCols: CGFloat = 2
    
    let fileName = "pairWords"
    
    var cardsArray: [UIButton]!
    
    var pairsDict: [String: String] = [:]
    
    var tappedCard: UIButton?
    var wordsForButton = [String?](repeating: nil, count: 14) // numOfCols*numOfRows
    
    var triesMade = 0
    var wordsMatched = 0 {
        didSet {
            if wordsMatched == 14 {
                gameOver()
            }
        }
    }
    
    // For now they isFirebaseLogedIn is not really necessary
    var isFirebaseLogedIn = false
    var emailAddress: String?
    
    
    
    // MARK: - Executive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu".localized(), style: .done, target: self, action: #selector(menuButtonTapped))
        
        cardsArray = [card1, card2, card3, card4, card5, card6, card7, card8, card9, card10, card11, card12, card13, card14]
        
        getPairsFromFile(named: fileName)
        placeWords()
    }

    override func viewDidLayoutSubviews() {
        setUIConstraints()
    }

    
    // MARK: - Methods
    
    /// reads pairs file and saves in property
    func getPairsFromFile(named fileName: String) {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                let text = try String(contentsOfFile: filePath, encoding: .utf8)
                if let data = text.data(using: .utf8) {
                    saveTextInDocumentsIfNotExist(named: fileName, data: data )
                }
            } catch {
                assertionFailure("GameController - Pairs file from bundle reading error")
            }
        }
        savePairsFromDirectoryFile(named: fileName)
    }
    
    /// saves pairs from text into the property
    func savePairsFromDirectoryFile(named: String) {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        var text: String = ""
        
        if let fileURL = directoryURL?.appendingPathComponent(fileName+".txt") {
            do {
                text = try String(contentsOf: fileURL)
            } catch {
                fatalError("Cant get words from pair words file in directory")
            }
        }
        
        let textLines = text.components(separatedBy: .newlines)
        for (index, line) in textLines.enumerated() {
            var words = line.components(separatedBy: .whitespaces)
           
            if words.count > 2 {
                assertionFailure("The word count was more than 2 on line \(index+1)")
                words = [words[0], words[1]]
            } else if words.count == 1 {
                if words.first == "" { continue }
                fatalError("The word count was 1 on line \(index+1)")
            }
            pairsDict[words.first!] = words[1]
        }
    }
    
    /// Saves text document to the app directory if doesn't exist
    func saveTextInDocumentsIfNotExist(named: String, data: Data) {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        if let fileURL = directoryURL?.appendingPathComponent(fileName+".txt") {
            let filePath = fileURL.path
            if !fileManager.fileExists(atPath: filePath) {
                do {
                    try data.write(to: fileURL)
                } catch {
                    print("Cant write data in to the directory")
                }
            }
        }
    }
    
    /// places random pair words  on random buttons
    func placeWords() {
        var randWordsArr: [String] = []
        var cardIndexes = getEnumeratedSequenceOf(size: Int(2*numOfRows))
        while !cardIndexes.isEmpty {
            guard let randPair = pairsDict.randomElement() else { fatalError("pairDict was empty") }
            let key = randPair.key
            let val = randPair.value
            
            if randWordsArr.contains(key) {
                continue
            } else {
                randWordsArr.append(key)
                
                let index1 = Int.random(in: 0..<cardIndexes.count)
                let index1Val = cardIndexes[index1]
                cardIndexes.remove(at: index1)
                
                let index2 = Int.random(in: 0..<cardIndexes.count)
                let index2Val = cardIndexes[index2]
                cardIndexes.remove(at: index2)

                wordsForButton[index1Val] = key
                wordsForButton[index2Val] = val
            }
        }
    }
    
    /// gets array of ints from 0 to SIZE [0, 1, 2, ... size-1]
    func getEnumeratedSequenceOf(size: Int) -> [Int] {
        var array: [Int] = []
        for i in 0..<size {
            array.append(i)
        }
        return array
    }
    
    ///
    func showWords(for card1: UIButton, and card2: UIButton) {
        let card1Num = card1.tag - 1
        let card2Num = card2.tag - 1
        
        card1.setTitle(wordsForButton[card1Num], for: .normal)
        card2.setTitle(wordsForButton[card2Num], for: .normal)
        
        card2.backgroundColor = .orange
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let word1 = self?.wordsForButton[card1Num], let word2 = self?.wordsForButton[card2Num] else {
                fatalError("wordsForButton words doesn't correspond card buttons indexes")
            }
            if self?.isPairMatch(word1: word1, word2: word2) ?? false {
                card1.isHidden = true
                card2.isHidden = true
                self?.wordsMatched += 2
            } else {
                card1.backgroundColor = .lightGray
                card2.backgroundColor = .lightGray
                card1.setTitle("", for: .normal)
                card2.setTitle("", for: .normal)
            }
            self?.tappedCard = nil
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    func isPairMatch(word1: String, word2: String) -> Bool {
        triesMade += 1
        if pairsDict[word1] != nil && pairsDict[word1] == word2 { return true }
        if pairsDict[word2] != nil && pairsDict[word2] == word1 { return true }
        return false
    }
    
    func gameOver() {
        let ac = UIAlertController(title: "You Won", message: "You made \(triesMade) tries", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { [weak self] action in
            guard let cardsArray = self?.cardsArray else { return }
            for card in cardsArray {
                card.isHidden = false
                card.backgroundColor = .lightGray
                card.setTitle("", for: .normal)
                self?.wordsMatched = 0
                self?.triesMade = 0
                self?.placeWords()
                
            }
        }))
        present(ac, animated: true, completion: nil)
        
        guard let emailAddress = emailAddress else { return }
        FirestoreManager.sharedInstance.setScoreIfHigher(for: emailAddress, score: triesMade)
    }
    
    @objc func menuButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK: - Outlet Actions
    
    @IBAction func cardTapped(_ sender: UIButton) {
        if tappedCard == nil {
            tappedCard = sender
            sender.backgroundColor = .orange
            return
        }
        if sender == tappedCard {
            return
        }
        showWords(for: tappedCard!, and: sender)
    }
    
    // END CLASS
}

