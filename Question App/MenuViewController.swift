import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var geographyButton: UIButton!
    @IBOutlet weak var storyButton: UIButton!
    @IBOutlet weak var scienceButton: UIButton!
    @IBOutlet weak var artButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var cinemaButton: UIButton!
    @IBOutlet weak var technologyButton: UIButton!
    @IBOutlet weak var literatureButton: UIButton!
    @IBOutlet weak var scoreText: UILabel!
    var score:  Int = UserDefaults.standard.integer(forKey: "puntiGiocatore")
    var questionIsDo : [String] = UserDefaults.standard.stringArray(forKey: "domandeFatte")  ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreText.text = String("Score: \(score)")
        print(questionIsDo)
        NotificationCenter.default.addObserver(self, selector: #selector(updateScore(_:)), name: .scoreDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateArguments(_:)), name: .argumentsDidChange, object: nil)
        
        styleBtn(btn: geographyButton)
        styleBtn(btn: storyButton)
        styleBtn(btn: scienceButton)
        styleBtn(btn: artButton)
        styleBtn(btn: musicButton)
        styleBtn(btn: cinemaButton)
        styleBtn(btn: technologyButton)
        styleBtn(btn: literatureButton)
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                        animations: {
                            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)// Riduce il pulsante
                        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity // Torna alla dimensione originale
            }
        }
        
        let buttonText = sender.titleLabel!.text!
       
        performSegue(withIdentifier: "segueToViewController", sender: buttonText)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let buttonText = sender.titleLabel!.text!
        if segue.identifier == "segueToViewController" {
            if let destinationVC = segue.destination as? ViewController {
                // Passa il testo del pulsante al secondo ViewController
                destinationVC.receivedText = sender as? String
            }
        }
    }
    
    func styleBtn(btn: UIButton){
        if questionIsDo.contains(btn.titleLabel!.text!) {
            btn.layer.borderColor = UIColor.gray.cgColor
            btn.backgroundColor = UIColor.systemGray
            btn.isEnabled = false
            btn.layer.cornerRadius = 10
            btn.layer.shadowRadius = 4
            btn.layer.cornerRadius = 10
            btn.layer.borderWidth = 2
        } else {
            btn.layer.shadowColor = UIColor.black.cgColor
            btn.layer.shadowOpacity = 0.5
            btn.layer.shadowOffset = CGSize(width: 4, height: 4)
            btn.layer.shadowRadius = 4
            btn.layer.cornerRadius = 10
            btn.layer.borderWidth = 2
        }
    }
    
    @objc func updateScore(_ notification: Notification) {
        if let updatedScore = notification.userInfo?["newScore"] as? Int {
            score = updatedScore
            scoreText.text = "Score: \(score)"
        }
    }
    
    @objc func updateArguments(_ notification: Notification) {
        if let updatedquestionIsDo = notification.userInfo?["argumentDo"] as? [String] {
            questionIsDo = updatedquestionIsDo
            UserDefaults.standard.set(questionIsDo, forKey: "domandeFatte")
        }
        styleAllButtons()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func styleAllButtons() {
        styleBtn(btn: geographyButton)
        styleBtn(btn: storyButton)
        styleBtn(btn: scienceButton)
        styleBtn(btn: artButton)
        styleBtn(btn: musicButton)
        styleBtn(btn: cinemaButton)
        styleBtn(btn: technologyButton)
        styleBtn(btn: literatureButton)
    }
}

extension Notification.Name {
    static let scoreDidChange = Notification.Name("scoreDidChange")
    static let argumentsDidChange = Notification.Name("argumentsDidChange")
}


