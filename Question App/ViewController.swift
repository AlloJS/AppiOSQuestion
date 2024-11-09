import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var buttonTrue: UIButton!
    @IBOutlet weak var buttonFalse: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    var currentQuestion : Int = 0
    var maxQuestion: Int = 0
    var rightAnswers: Int = 0
    var wrongAnswers: Int = 0
    var receivedText: String?
    var arrayQuestions: [Question] = []
    var score: Int = UserDefaults.standard.integer(forKey: "puntiGiocatore")
    var audioPlayer: AVAudioPlayer?
    var questionIsDo : [String] = UserDefaults.standard.stringArray(forKey: "domandeFatte")  ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBar.progress = 0
        progressBar.progressTintColor = .pastelGreen
        navigationItem.title = "Domande su \(receivedText!)"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        progressBar.layer.cornerRadius = 10 // Arrotonda i bordi
        progressBar.clipsToBounds = true
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3) // Scala l'altezza
        
        chooseArray (argument:"Geografia",arr: geographyQuestions)
        chooseArray (argument:"Storia",arr: historyQuestions)
        chooseArray (argument:"Scienza",arr: scienceQuestions)
        chooseArray (argument:"Arte e cultura",arr: artAndCultureQuestions)
        chooseArray (argument:"Musica",arr: musicQuestions)
        chooseArray (argument:"Cinema e TV",arr: cinemaTVQuestions)
        chooseArray (argument:"Tecnologia",arr: tecnologiaQuestions)
        chooseArray (argument:"Letteratura",arr: letteraturaQuestions)
        maxQuestion = arrayQuestions.count
        styleBtn(btn: buttonTrue)
        styleBtn(btn: buttonFalse)
        textLabel.text = arrayQuestions[0].text
    }

    @IBAction func chooseAnswer(_ sender: UIButton) {
        if currentQuestion + 1 < maxQuestion {
            progressBar.progress = Float(currentQuestion + 1) / Float(maxQuestion)
           
            UIView.animate(withDuration: 0.1,
                            animations: {
                                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)// Riduce il pulsante
                            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    sender.transform = .identity // Torna alla dimensione originale
                }
            }
            
            let userAnswer: String! = sender.titleLabel!.text!
            
            if userAnswer == arrayQuestions[currentQuestion].answer.uppercased() {
                rightAnswers += 1
                changeColorButtonTemporarily(button: sender, color: .pastelGreen, duration: 1.0)
                playErrorSound("ok")
            } else {
                wrongAnswers += 1
                changeColorButtonTemporarily(button: sender, color: .pastelRed, duration: 1.0)
                playErrorSound("error")
            }
        
            currentQuestion += 1
            textLabel.text = arrayQuestions[currentQuestion].text
            
        } else if currentQuestion + 1 == maxQuestion{
            currentQuestion += 1
            let totalPercent: Double =  percentAnswer()
            let formattedNumber = String(format: "%.2f", totalPercent)
            var result: String = "Complimenti!!!"

            if totalPercent < 60 {
                result = "Peccato, riprova."
                playErrorSound("fail")
            } else {
                playErrorSound("win")
            }
            
            score += rightAnswers
            
            if score > 0 {
                score -= wrongAnswers
            }
            
            
            UserDefaults.standard.set(score, forKey: "puntiGiocatore")
            
            NotificationCenter.default.post(name: .scoreDidChange, object: nil, userInfo: ["newScore": score])
           
            
            textLabel.text = "Hai risosto esattamente a \(rightAnswers) domande\ne a \(wrongAnswers) sbagliate.\nTotalizzando su \(maxQuestion) domande una percentuale di \(formattedNumber)% risposte esatte.\n\(result) \nCon il tuo totale punti di \(score)"
            
            progressBar.progress = 1
            
            questionIsDo.append(receivedText!)
            UserDefaults.standard.set(questionIsDo, forKey: "domandeFatte")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .argumentsDidChange, object: nil, userInfo: ["argumentDo": questionIsDo])
        }
    }
    
    func changeColorButtonTemporarily(button: UIButton, color: UIColor,duration: TimeInterval) {
       
        button.backgroundColor = color
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            button.backgroundColor = .customOriginalColor
                }
    }
    
    func percentAnswer() -> Double {
        return Double(rightAnswers) / Double(maxQuestion) * 100
    }
    
    func chooseArray (argument:String,arr: [Question]){
        if receivedText == argument {
            arrayQuestions = arr
        }
    }
    
    func styleBtn(btn: UIButton){
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowRadius = 4
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 2
    }
    
    func playErrorSound(_ nameSoud: String) {
        guard let soundURL = Bundle.main.url(forResource: nameSoud, withExtension: "mp3") else {
            print("File audio non trovato.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Errore nella riproduzione del suono: \(error.localizedDescription)")
        }
    }
    
}

extension UIColor {
    static let pastelGreen = UIColor(red: 119/255, green: 221/255, blue: 119/255, alpha: 1.0) // Verde pastello
    static let pastelRed = UIColor(red: 255/255, green: 105/255, blue: 97/255, alpha: 1.0)   // Rosso pastello
    static let customOriginalColor = UIColor(red: 127/255, green: 158/255, blue: 193/255, alpha: 1.0) // #7F9EC1
}
