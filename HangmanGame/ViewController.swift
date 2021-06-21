//
//  ViewController.swift
//  HangmanGame
//
//  Created by Felipe Gil on 2021-06-18.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var correctWord: UILabel!
    @IBOutlet weak var lblWrongGuess: UILabel!
    @IBOutlet weak var imgHead: UIImageView!
    @IBOutlet weak var imgBody: UIImageView!
    @IBOutlet weak var imgLeftArm: UIImageView!
    @IBOutlet weak var imgRightArm: UIImageView!
    @IBOutlet weak var imgLeftLeg: UIImageView!
    @IBOutlet weak var imgRightLeg: UIImageView!
    @IBOutlet weak var btnGuess: UIButton!
    @IBOutlet weak var textBox: UITextField!
    
    var score = 0 {
        didSet {
            lblScore.text = "Score \(score)"
        }
    }
    
    var wrongLetters = [String]()
    var questionMark = [String]()
    var words = ["MOOSEUM","ROADHOG","TRUNK","MILKSHAKE","BABOOM","BULLDOZER","HISSTORY"]
    var selectedWord = ""
    var letters = [Any]()
    var numberOfLetters = 0
    var wrongTempLetter = ""
    var rightTempLetter = ""
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        words.shuffle()
        loadLevel()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadLevel))
        navigationController?.isToolbarHidden = false
        
    }
    
    private func divideLetters() {
        selectedWord = words[1]
        numberOfLetters = selectedWord.count
        letters = Array(selectedWord)
        questionMark.removeAll()
        correctWord.text = ""
        for index in 0...numberOfLetters-1{
            questionMark.append("?")
            correctWord.text! += questionMark[index]
        }
    }
    
    private func hideImages() {
        imgHead.isHidden = true
        imgBody.isHidden = true
        imgLeftArm.isHidden = true
        imgRightArm.isHidden = true
        imgLeftLeg.isHidden = true
        imgRightLeg.isHidden = true
    }
    
    private func clearFields() {
        lblWrongGuess.text = ""
    }
    
    private func showImages() {
        switch(counter) {
        case 1:
            imgHead.isHidden = false
            break
        case 2:
            imgBody.isHidden = false
            break
        case 3:
            imgLeftArm.isHidden = false
            break
        case 4:
            imgRightArm.isHidden = false
            break
        case 5:
            imgLeftLeg.isHidden = false
            break
        case 6:
            imgRightLeg.isHidden = false
            gameOver()
            break
        default:
            break
        }
    }
    
    private func alertMsg(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func gameOver() {
        score -= 1
        alertMsg(title: "Game Over", message: "You have lost 1 point")
        loadLevel()
    }
    
    @objc private func loadLevel() {
        clearFields()
        hideImages()
        words.shuffle()
        divideLetters()
    }
    private func victory() {
        alertMsg(title: "Victory", message: "You've got 1 point")
        score += 1
    }
    
    @IBAction func btnTryClicked(_ sender: UIButton) {
        if textBox.text == ""{
            alertMsg(title: "Error", message: "Please type something")
        } else {
            guard var typed = textBox.text?.uppercased() else { return }
            if typed.count > 1 {
                alertMsg(title: "Too many arguments", message: "Please type only 1 character")
            } else {
                if selectedWord.contains(typed) {
                    for index in 0...numberOfLetters-1 {
                        if typed == "\(letters[index])"{
                            questionMark[index] = typed
                            correctWord.text = ""
                            rightTempLetter = ""
                            for item in questionMark {
                                rightTempLetter += item
                            }
                            correctWord.text = rightTempLetter
                            if questionMark.contains("?"){ } else {
                                victory()
                            }
                        }
                    }
                } else {
                    if wrongLetters.contains(typed){
                        typed = ""
                    } else {
                        wrongLetters.append(typed)
                        wrongTempLetter += typed
                        lblWrongGuess.text = wrongTempLetter
                        counter += 1
                        showImages()
                    }
                }
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector(("dismissKeyboardView")))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
}
