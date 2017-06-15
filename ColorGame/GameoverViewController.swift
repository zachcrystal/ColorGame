//
//  GameverScreenView.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-15.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class GameoverViewController: UIViewController {
    
    struct Gameover {
        let message: String? //enum?
        let score: Int?
        let highScore: Int?
    }
    
    let gameoverView: GameoverView = {
        let view = GameoverView()
        view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.alpha = 0

        
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(blurEffectView)
        blurEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
        gameoverView.frame.size = CGSize(width: 300, height: 250)
        gameoverView.center = self.view.center

        view.addSubview(gameoverView)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.view.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 0
        }
    }
    
    
    
    
}


