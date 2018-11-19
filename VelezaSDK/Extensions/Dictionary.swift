//
//  Dictionary.swift
//  Veleza
//
//  Created by Vytautas Povilaitis on 19/11/2018.
//  Copyright © 2018 Veleza. All rights reserved.
//

import Foundation

extension Dictionary {
    public static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
    }
}
