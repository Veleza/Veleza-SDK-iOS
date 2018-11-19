//
//  VelezaProgressBar.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 12/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import UIKit

@IBDesignable class VelezaProgressBar: UIView {
    
    fileprivate var titleLabel = UILabel()
    fileprivate var progressLabel = UILabel()
    fileprivate var progressContainer = UIView()
    fileprivate var progress = UIView()
    fileprivate var progressContraint: NSLayoutConstraint?
    
    var survey: [String: String]? {
        didSet {
            if let question = survey?["question"], let value = survey?["value"] {
                titleLabel.text = question
                progressLabel.text = String(format: "%.0f%%", Float(value) ?? 0)
                
                if let constraint = progressContraint {
                    progress.removeConstraint(constraint)
                    progressContainer.removeConstraint(constraint)
                    constraint.isActive = false
                }
                progressContraint = progress.widthAnchor.constraint(equalTo: progressContainer.widthAnchor, multiplier: CGFloat((Float(value) ?? 0.0) / 100.0), constant: 0)
                progressContraint?.isActive = true
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = VelezaSDK.fontSemiboldSmall
        titleLabel.textColor = VelezaSDK.colorBlack
        titleLabel.text = "Question"
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.font = VelezaSDK.fontSemiboldSmall
        progressLabel.textColor = VelezaSDK.colorBrand
        progressLabel.text = "17%"
        addSubview(progressLabel)
        
        #if swift(>=4)
            progressLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal);
        #else
            progressLabel.setContentCompressionResistancePriority(1000, for: .horizontal);
        #endif
        progressLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        progressLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        progressLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        progressLabel.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 10).isActive = true
        
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.backgroundColor = VelezaSDK.colorSeparator
        progressContainer.layer.cornerRadius = 3.0
        progressContainer.clipsToBounds = true
        addSubview(progressContainer)
        
        progressContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        progressContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        progressContainer.heightAnchor.constraint(equalToConstant: 10).isActive = true
        progressContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        progressContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.backgroundColor = VelezaSDK.colorBrand
        progressContainer.addSubview(progress)
        
        progress.leftAnchor.constraint(equalTo: progressContainer.leftAnchor).isActive = true
        progress.topAnchor.constraint(equalTo: progressContainer.topAnchor).isActive = true
        progress.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor).isActive = true
        
        progressContraint = progress.widthAnchor.constraint(equalTo: progressContainer.widthAnchor, multiplier: 0, constant: 0)
        progressContraint?.isActive = true
    }
    
}
