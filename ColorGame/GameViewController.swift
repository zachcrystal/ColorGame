//
//  GameViewController.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-12.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    
    func playMusic() {
        guard let sound = NSDataAsset(name: "MusicLoop3") else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            audioPlayer!.play()
            audioPlayer!.numberOfLoops = -1
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func stopAudio() {
        if audioPlayer != nil {
            audioPlayer?.stop()
            audioPlayer = nil
        }
    }
    
    var people: [Person]?
    
    var idIsExpired: Bool?
    var legalAge: Bool?
    
    var lives = 3 {
        didSet {
            if lives == 0 {
                // do something
            }
        }
    }
    
    var peopleLetIn: Int = 0 {
        didSet {
            letInLabel.text = "People let in: \(peopleLetIn)"
        }
    }
    
    var countdown = 30 {
        didSet {
            if countdown == 0 {
                endOfRound()
            }
        }
    }
    
    func endOfRound() {
        let endOfRoundTitle = "Your shift for the night is finally over! Lets see how you did..."
        let endOfRoundMessage = "You let in \(peopleLetIn) people"
        let answerAlert = UIAlertController(title: endOfRoundTitle, message: endOfRoundMessage, preferredStyle: .alert)
        let nextRoundAction = UIAlertAction(title: "Start next shift", style: .default) { (_) in
            self.startNewRound()
        }
        answerAlert.addAction(nextRoundAction)
        
        present(answerAlert, animated: true, completion: nil)
        
    }
    
    func startNewRound() {
        countdown = 30
        updateCounter()
        peopleLetIn = 0
        lives = 3
        selectRandomPerson()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var letInLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0 people let in"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "30"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    var personImageKey: String?
    var personImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "placeholder")
        return iv
    }()
    
    let IDCard: IDCardView = {
        let view = IDCardView()
        return view
    }()
    
    let denyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "deny"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.tag = 0
        return button
    }()
    
    let approveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "approve"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    
    
    let dynamicButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "next"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    
    func handleMatch(sender: UIButton!) {
        // getLost tag = 0, comeOnIn tag = 1
        print(sender.tag)
        //        let IDCard = IDCardView()
        
        var isMatch = Bool()
        guard let IDCardViewKey = IDCard.identificationImageKey else { return }
        
        if personImageKey == IDCardViewKey && idIsExpired == false && legalAge == true {
            isMatch = true
        } else {
            isMatch = false
        }
        
        if isMatch == true && sender.tag == 0 {
            lives -= 1
            showIncorrectResponseAlert(getLost: true)
        }
        
        if isMatch == true && sender.tag == 1  {
            selectRandomPerson()
            peopleLetIn += 1
        }
        
        if isMatch == false && sender.tag == 0 {
            selectRandomPerson()
        }
        
        if isMatch == false && sender.tag == 1 {
            lives -= 1
            showIncorrectResponseAlert(getLost: false)
        }
    }
    
    func showIncorrectResponseAlert(getLost: Bool) {
        
        let getLostTitle = "Hey! What did you do that for?! You're costing us money!"
        let wrongLetInTitle = "Hey! You let someone in you weren't supposed to!"
        let answerAlert = UIAlertController(title: getLost ? getLostTitle : wrongLetInTitle, message: nil, preferredStyle: .alert)
        let nextRoundAction = UIAlertAction(title: "Sorry! It won't happen again!", style: .default) { (_) in
            self.selectRandomPerson()
        }
        answerAlert.addAction(nextRoundAction)
        
        present(answerAlert, animated: true, completion: nil)
        
    }
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "background")
        return iv
    }()
    
    let tableImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "tableonly")
        return iv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        fetchPeople()
        
        view.addSubview(backgroundImageView)
        view.addSubview(tableImageView)
        
        view.addSubview(dynamicButton)
        view.addSubview(personImage)
        view.addSubview(approveButton)
        view.addSubview(denyButton)
        view.addSubview(letInLabel)
        view.addSubview(timerLabel)
        
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        selectRandomPerson()
        
        backgroundImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tableImageView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 275)
        
        personImage.anchor(top: nil, left: nil, bottom: tableImageView.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 300, height: 300)
        personImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dynamicButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 45, paddingRight: 0, width: 50, height: 50)
        dynamicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        denyButton.anchor(top: dynamicButton.topAnchor, left: nil, bottom: view.bottomAnchor, right: dynamicButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 4, paddingRight: -4, width: 90, height: 0)
        
        approveButton.anchor(top: dynamicButton.topAnchor, left: dynamicButton.rightAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: -4, paddingBottom: 4, paddingRight: 0, width: 90, height: 0)
        
        showIDCard()
        
        
        letInLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 36, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        timerLabel.anchor(top: letInLabel.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
//        playMusic()
    }
    
    fileprivate func showIDCard() {
        
        
        view.addSubview(IDCard)
        IDCard.anchor(top: tableImageView.topAnchor , left: nil, bottom: nil , right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 240, height: 180)
        IDCard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        var transform = CATransform3DIdentity
        let divider: CGFloat = 500
        let degree: Double = 43
        let x: CGFloat = 1
        let y: CGFloat = 0
        let z: CGFloat = 0
        let anchorPointX = 0.5
        let anchorPointY = 0.5
        
        IDCard.layer.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
        
        transform = CATransform3DIdentity
        transform.m34 = -1.0/divider
        
        let rotateAngle = CGFloat((degree * Double.pi) / 180.0)
        transform = CATransform3DRotate(transform, rotateAngle, x, y, z)
        
        IDCard.layer.transform = transform
        IDCard.layer.zPosition = 100
        
    }
    
    
    
    func fetchPeople() {
        guard let path = Bundle.main.path(forResource: "People", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            guard let personDictionaries = json as? [[String: Any]] else { return }
            
            self.people = []
            for personDictionary in personDictionaries {
                let person = Person(jsonDictionary: personDictionary)
                self.people?.append(person)
            }
            
        } catch {
            print(error)
        }
    }
    
    func updateCounter() {
        if countdown > 0 {
            countdown -= 1
            timerLabel.text = "\(countdown)"
        }
    }
    
    // first make a copy of people array so we can remove the random person selected for the large square. The person is removed because we handle the option that the people match using a random number between 1 and 100. If the number less than 80, the smaller square is set to the same color as the large square (a match) and if the number is greater than 60, a random color is chosen from the 15 remaining colors in the array.
    
    var randomPerson: Person?
    
    fileprivate func selectRandomPerson() {
        
        guard let people = people else { return }
        var internalPersonArray = people
        // randomItem is a static func that picks a random element in an array.
        randomPerson = internalPersonArray.randomItem()
        guard let randomPerson = randomPerson else { return }
        
        for (key, value) in randomPerson.avatarDictionary {
            personImage.image = value
            personImageKey = key
        }
        
        let probabilityValue = arc4random_uniform(100) + 1
        if probabilityValue > 80 {
            // since the number is greater than 60, the colors are not going to be a match, therefore we need to remove the color of the large square from the array so we don't get a match
            
            if let index = internalPersonArray.index(of: randomPerson) {
                internalPersonArray.remove(at: index)
            }
            
            let anotherRandomPerson = internalPersonArray.randomItem()
            IDCard.person = anotherRandomPerson
        } else {
            IDCard.person = randomPerson
        }
        
        checkIfPersonCanEnter(person: randomPerson)
    }
    
    fileprivate func checkIfPersonCanEnter(person: Person) {
        
        guard let randomPerson = randomPerson else { return }
        
        let currentTimestamp = Date().timeIntervalSince1970
        let expiryTimestamp = randomPerson.expiryDateTimeStamp
        
        if expiryTimestamp > currentTimestamp {
            idIsExpired = false
        } else if expiryTimestamp < currentTimestamp {
            idIsExpired = true
        }
        
        if randomPerson.age >= 21 {
            legalAge = true
        } else {
            legalAge = false
        }
    }
}
