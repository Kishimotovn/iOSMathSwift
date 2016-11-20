//
//  AtomListRange.swift
//  iOSMathSwift
//
//  Created by Anh Phan Tran on 11/20/16.
//  Copyright © 2016 Anh Phan Tran. All rights reserved.
//

import Foundation

public class AtomListRange {
    var start: AtomListIndex
    var length: Int
    
    var finalRange: NSRange {
        return NSMakeRange(self.start.finalIndex, self.length)
    }
    
    func subIndexRange() -> AtomListRange? {
        if self.start.subIndexType != .none && self.start.subIndex != nil {
            return AtomListRange(start: self.start.subIndex!, length: self.length)
        }
        return nil
    }
    
    func union(with range: AtomListRange) -> AtomListRange? {
        if !self.start.isAtSameLevel(with: range.start) {
            assert(false, "Cannot union ranges at different levels: \(self), \(range)")
            print("Can't union ranges at different levels: \(self), \(range)")
            return nil
        }
        
        let r1 = self.finalRange
        let r2 = range.finalRange
        
        let unionRange = NSUnionRange(r1, r2)
        
        let start: AtomListIndex
        
        if unionRange.location == r1.location {
            start = self.start
        } else if unionRange.location == r2.location {
            start = range.start
        } else {
            assert(unionRange.location == r2.location)
            return nil
        }
        
        return AtomListRange(start: start, length: unionRange.length)
    }
    
    public static func union(ranges: [AtomListRange]) -> AtomListRange? {
        if ranges.count == 0 {
            assert(ranges.count > 0, "Need to union atleast 1 range")
            print("Need to union atleast 1 range")
            return nil
        }
        
        var unioned = ranges[0]
        for i in 1..<ranges.count {
            if let u = unioned.union(with: ranges[i]) {
                unioned = u
            }
        }
        return unioned
    }
    
    /// Creates a valid range.
    public init(start: AtomListIndex, length: Int) {
        self.start = start
        self.length = length
    }
    
    /// Creates a range at level 0 from the give range.
    public convenience init(range: NSRange) {
        self.init(start: AtomListIndex(level0Index: range.location), length: range.length)
    }
    
    /// Makes a range of length 1
    public convenience init(start: AtomListIndex) {
        self.init(start: start, length: 1)
    }
    
    /// Makes a range of length 1 at the level 0 index start
    public convenience init(startIndex: Int) {
        self.init(start: AtomListIndex(level0Index: startIndex))
    }
}

extension AtomListRange: CustomStringConvertible {
    public var description: String {
        return "(\(self.start), \(self.length))"
    }
}
