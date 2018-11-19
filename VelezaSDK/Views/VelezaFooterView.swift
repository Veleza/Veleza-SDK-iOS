//
//  VelezaFooterView.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 08/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import UIKit

@IBDesignable class VelezaFooterView: UIView {
    
    var text: String = "Posts and ratings by member from" {
        didSet {
            label.text = text
        }
    }
    
    fileprivate var logo: UIImageView = UIImageView()
    fileprivate var label: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    fileprivate func setup() {
        let bundle = Bundle(for: type(of: self))
        
        logo.image = UIImage(named: "veleza-logo", in: bundle, compatibleWith: nil)
        logo.contentMode = .center
        logo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logo)
        
        logo.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        logo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        logo.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 16).isActive = true

        label.text = text
        label.textColor = VelezaSDK.colorGreyLight
        label.font = VelezaSDK.fontRegularSmall
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingHead
        addSubview(label)
        
        label.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: logo.leftAnchor, constant: -6).isActive = true
        label.centerYAnchor.constraint(equalTo: logo.centerYAnchor, constant: 2).isActive = true
    }

}
