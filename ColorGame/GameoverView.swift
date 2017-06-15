//
//  GameoverView.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-15.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class GameoverView: UIView {
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "You let somebody in with an expired ID!"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 7"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var highscoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Highscore: 20"
        return label
    }()
    
    var playAgainButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = UIColor(red:0.40, green:0.22, blue:0.94, alpha:0.4)
        
        let anchorPointX = 0.0
        let anchorPointY = 0.0
        
        self.layer.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        let stackView = UIStackView(arrangedSubviews: [messageLabel, scoreLabel, highscoreLabel, playAgainButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
    }
}
