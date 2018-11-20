//
//  VelezaSurveysListView.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 12/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import UIKit

@IBDesignable class VelezaSurveysListView: UIView {
    
    @IBInspectable var visibleSurveys = 4 {
        didSet {
            render()
        }
    }
    
    @IBInspectable var expanded = false {
        didSet {
            render()
        }
    }
    
    weak var layoutDelegate: VelezaWidgetLayoutDelegate?

    var trackingData: [String: String] = [:]

    var surveys: [Any] = [
        [
            "question" : "It blends well",
            "value" : "93.1034",
        ],
        [
            "question": "It is easy to remove",
            "value": "74.1071"
        ],
        [
            "question": "It smears easily",
            "value": "84.8214"
        ],
        [
            "question": "It stays long after application",
            "value": "81.4159"
        ],
        [
            "question": "It is pigmented",
            "value": "59.0909"
        ],
        [
            "question": "It is waterproof",
            "value": "58.5586"
        ],
        [
            "question": "It is easy to use",
            "value": "100.0000"
        ]
    ] {
        didSet {
            render()
        }
    }
    
    private var stackView = UIStackView()
    private var container = UIView()
    private var containerHeightConstraint: NSLayoutConstraint?

    private var viewAllButton = UIButton(type: .custom)
    private var viewAllButtonBottomConstraint: NSLayoutConstraint?
    

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
        clipsToBounds = true
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        addSubview(container)
        
        container.topAnchor.constraint(equalTo: topAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        containerHeightConstraint = container.heightAnchor.constraint(equalToConstant: 0)
        containerHeightConstraint?.isActive = true
        
        let containerBottomConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor)
        #if swift(>=4)
            containerBottomConstraint.priority = UILayoutPriority(rawValue: 999)
        #else
            containerBottomConstraint.priority = 999
        #endif
        containerBottomConstraint.isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        container.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.setTitle("More like this", for: .normal)
        viewAllButton.setTitleColor(VelezaSDK.colorGreyLight, for: .normal)
        viewAllButton.titleLabel?.font = VelezaSDK.fontRegular
        viewAllButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        viewAllButton.addTarget(self, action: #selector(toggleExpanded), for: .touchUpInside)
        addSubview(viewAllButton)
        
        viewAllButton.topAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        viewAllButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        viewAllButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        viewAllButtonBottomConstraint = viewAllButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        UIView.performWithoutAnimation {
            render()
        }
    }
    
    func render() {
        let count = expanded ? surveys.count : min(surveys.count, max(visibleSurveys, 1))
        
        while (self.stackView.subviews.count < count) {
            let item = VelezaProgressBar()
            stackView.addArrangedSubview(item)
            item.alpha = 0
        }
        
        for i in count ..< stackView.subviews.count {
            let view = stackView.subviews[i]
            stackView.removeArrangedSubview(view)
            view.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
            view.topAnchor.constraint(equalTo: stackView.topAnchor, constant: view.frame.origin.y).isActive = true
        }
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.2, animations: {
            let arrangedViews = self.stackView.arrangedSubviews as! [VelezaProgressBar]
            for view in self.stackView.subviews as! [VelezaProgressBar] {
                if !arrangedViews.contains(view) {
                    view.alpha = 0
                }
                else {
                    view.alpha = 1
                }
            }
            
            for view in arrangedViews {
                if let index = arrangedViews.firstIndex(of: view) {
                    view.survey = self.surveys[index] as? [String: String]
                }
            }
            
            if (!self.expanded && self.surveys.count > count) {
                self.viewAllButton.alpha = 1
                self.viewAllButtonBottomConstraint?.isActive = true
            }
            else {
                self.viewAllButton.alpha = 0
                self.viewAllButtonBottomConstraint?.isActive = false
            }
        
            self.containerHeightConstraint?.constant = CGFloat(count) * 41.0

            self.layoutDelegate?.velezaWidgetNeedsLayoutUpdate()
            self.window?.layoutIfNeeded()
        }) { (finished) in
            let arrangedViews = self.stackView.arrangedSubviews
            for view in self.stackView.subviews {
                if !arrangedViews.contains(view) {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    @IBAction func toggleExpanded() {
        self.expanded = !self.expanded
        VelezaSDK.amplitude?.logEvent("Surveys - Show all", withEventProperties: self.trackingData)
    }
    
}
