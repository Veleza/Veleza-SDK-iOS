//
//  VelezaSDK.swift
//  Pods-VelezaSDKTest
//
//  Created by Vytautas Povilaitis on 12/11/2018.
//

import Foundation
import Amplitude_iOS

public class VelezaSDK {
    
    static var clientId: String?
    static var roundedCornerSize: CGFloat = 4.0
    
    static var amplitude: Amplitude?
    
    fileprivate static var initialized = false
    
    
    static var colorBlack = UIColor(red: 0.165, green: 0.165, blue: 0.188, alpha: 1)
    static var colorBrand = UIColor(red: 0.984, green: 0.337, blue: 0.455, alpha: 1)
    static var colorGreyDark = UIColor(red: 0.510, green: 0.514, blue: 0.573, alpha: 1)
    static var colorGreyLight = UIColor(red: 0.729, green: 0.733, blue: 0.804, alpha: 1)
    static var colorSeparator = UIColor(red: 0.922, green: 0.922, blue: 0.965, alpha: 1)
    
    fileprivate static var _fontRegular: UIFont?
    static var fontRegular: UIFont {
        get {
            if (_fontRegular == nil) {
                _initialize()
            }
            return _fontRegular!
        }
    }
    
    fileprivate static var _fontSemibold: UIFont?
    static var fontSemibold: UIFont {
        get {
            if (_fontSemibold == nil) {
                _initialize()
            }
            return _fontSemibold!
        }
    }

    fileprivate static var _fontRegularSmall: UIFont?
    static var fontRegularSmall: UIFont {
        get {
            if (_fontRegularSmall == nil) {
                _initialize()
            }
            return _fontRegularSmall!
        }
    }
    
    fileprivate static var _fontSemiboldSmall: UIFont?
    static var fontSemiboldSmall: UIFont {
        get {
            if (_fontSemiboldSmall == nil) {
                _initialize()
            }
            return _fontSemiboldSmall!
        }
    }
    
    fileprivate static var _fontRegularLarge: UIFont?
    static var fontRegularLarge: UIFont {
        get {
            if (_fontRegularLarge == nil) {
                _initialize()
            }
            return _fontRegularLarge!
        }
    }
    
    fileprivate static var _fontSemiboldLarge: UIFont?
    static var fontSemiboldLarge: UIFont {
        get {
            if (_fontSemiboldLarge == nil) {
                _initialize()
            }
            return _fontSemiboldLarge!
        }
    }
    
    public static func initialize(clientId: String) {
        self.clientId = clientId
        
        amplitude = Amplitude.instance(withName: "Veleza")
        amplitude?.initializeApiKey("3243104f8b53aaf7601f8d5d2313f294")
        amplitude?.trackingSessionEvents = false
        
        _initialize()
    }
    
    fileprivate static func _initialize() {
        if (initialized) {
            return
        }
        
        initialized = true
        
        let bundle = Bundle(for: self)
        
        UIFont.registerFontWithFilenameString(filenameString: "OpenSans-Regular.ttf", bundle: bundle)
        UIFont.registerFontWithFilenameString(filenameString: "OpenSans-Semibold.ttf", bundle: bundle)
        
        _fontRegular = UIFont(name: "OpenSans", size: 14)
        _fontSemibold = UIFont(name: "OpenSans-Semibold", size: 14)
        
        _fontRegularSmall = UIFont(name: "OpenSans", size: 12)
        _fontSemiboldSmall = UIFont(name: "OpenSans-Semibold", size: 12)
        
        _fontRegularLarge = UIFont(name: "OpenSans", size: 16)
        _fontSemiboldLarge = UIFont(name: "OpenSans-Semibold", size: 16)
    }
    
}
