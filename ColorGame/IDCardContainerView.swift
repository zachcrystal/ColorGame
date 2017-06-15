//
//  IDCardContainerView.swift
//  ColorGame
//
//  Created by Zach Crystal on 2017-06-13.
//  Copyright © 2017 Zach Crystal. All rights reserved.
//

import UIKit

class IDCardContainerView: UIView {
    
    var person: Person? {
        didSet {
            guard let person = person else { return }
            for (key, value) in person.avatarDictionary {
                IDCard.identificationImageKey = key
                IDCard.identificationImageView.image = value
            }
            
            IDCard.nameLabel.text = "\(person.firstName) \(person.lastName)"
            IDCard.expiryLabel.text = "EXPIRATION DATE\n\(person.expiryDateString)"
            IDCard.addressLabel.text = person.address
            IDCard.idBadgeImageView.image = person.idBadge
            IDCard.setupAttributedText(dob: person.dob, expiry: person.expiryDateString)
        }
    }
    
    let IDCard: IDCardView = {
        let view = IDCardView()
        return view
    }()
    


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadStyleAndLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadStyleAndLayout() {
        self.frame.size = CGSize(width: 280, height: 240)
        
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
        clipsToBounds = true
        
        
        var transform = CATransform3DIdentity
        let divider: CGFloat = 500
        let degree: Double = 43
        let x: CGFloat = 1
        let y: CGFloat = 0
        let z: CGFloat = 0
        let anchorPointX = 0.5
        let anchorPointY = 0.5
        
        self.layer.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
        
        transform = CATransform3DIdentity
        transform.m34 = -1.0/divider
        
        let rotateAngle = CGFloat((degree * Double.pi) / 180.0)
        transform = CATransform3DRotate(transform, rotateAngle, x, y, z)
        
        self.layer.transform = transform
        self.layer.zPosition = 100

        
        IDCard.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        addSubview(IDCard)
    }
}
