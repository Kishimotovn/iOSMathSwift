//
//  UnicodeSymbol.swift
//  iOSMathSwift
//
//  Created by Anh Phan Tran on 11/20/16.
//  Copyright © 2016 Anh Phan Tran. All rights reserved.
//

import Foundation

public struct UnicodeSymbol {
    static let multiplication = "\u{00D7}"
    static let division = "\u{00F7}"
    static let fractionSlash = "\u{2044}"
    static let whiteSquare = "\u{25A1}"
    static let blackSquare = "\u{25A0}"
    static let lessEqual = "\u{2264}"
    static let greaterEqual = "\u{2265}"
    static let notEqual = "\u{2260}"
    static let squareRoot = "\u{221A}" // \sqrt
    static let cubeRoot = "\u{221B}"
    static let infinity = "\u{221E}" // \infty
    static let angle = "\u{2220}" // \angle
    static let degree = "\u{00B0}" // \circ
    
    static let capitalGreekStart = 0x0391
    static let capitalGreekEnd = 0x03A9
    static let greekStart = 0x03B1
    static let greekEnd = 0x03C9
    static let planksConstant = 0x210e
    static let italicStart = 0x1D44E
    static let capitalItalicStart = 0x1D434
    static let greekItalicStart = 0x1D6FC
    static let greekCapitalItalicStart = 0x1D6E2
}

extension String {
    public func unicodeLength() -> Int {
        return self.lengthOfBytes(using: String.Encoding.utf32)/4
    }
}
