//
//  Font.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 12/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import Foundation

extension UIFont {
    
    public static func registerFontWithFilenameString(filenameString: String, bundle: Bundle) {
        
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }
        
        #if swift(>=4)
            guard let fontRef = CGFont(dataProvider) else {
                print("UIFont+:  Failed to register font - could not create font from provider.")
                return
            }
        #else
            let fontRef = CGFont(dataProvider)
        #endif
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
