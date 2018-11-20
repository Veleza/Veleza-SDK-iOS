//
//  VelezaWidget.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 12/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import UIKit

@objc public protocol VelezaWidgetDelegate: AnyObject {
    
    func velezaWidget(_ widget: VelezaWidget, shouldBeDisplayed: Bool)
    
    func velezaWidget(needsLayoutUpdateFor widget: VelezaWidget)
    
}

@objc public protocol VelezaWidgetLayoutDelegate: AnyObject {
    
    func velezaWidgetNeedsLayoutUpdate()
    
}

public class VelezaWidget: UIView, VelezaWidgetLayoutDelegate {
    
    @IBInspectable public var identifier: String? {
        didSet {
            if let len = identifier?.count, len > 0 {
                request()
            }
        }
    }
    
    @IBOutlet public weak var delegate: VelezaWidgetDelegate?

    var trackingData: [String: String] = [:]
    
    var footer = VelezaFooterView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        setup()
    }
    
    func request() {
        
    }
    
    func setup() {
        footer.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func velezaWidgetNeedsLayoutUpdate() {
        self.delegate?.velezaWidget(needsLayoutUpdateFor: self)
    }
    
}
