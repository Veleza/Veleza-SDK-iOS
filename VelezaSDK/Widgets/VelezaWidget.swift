//
//  VelezaWidget.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 12/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import UIKit

public class VelezaWidget: UIView {
    
    @IBInspectable var identifier: String? {
        didSet {
            if let len = identifier?.count, len > 0 {
                request()
            }
        }
    }
    
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
    
}
