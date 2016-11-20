//
//  AtomListIndex.swift
//  iOSMathSwift
//
//  Created by Anh Phan Tran on 11/20/16.
//  Copyright © 2016 Anh Phan Tran. All rights reserved.
//

import Foundation

class AtomListIndex {
    enum AtomListSubIndexType: Int {
        case none = 0
        case nucleus
        case superScript
        case subScript
        case numerator
        case denominator
        case radicand
        case degree
    }
    
    /// The index of the associated atom.
    var atomIndex: Int
    
    /// The type of subindex, e.g. superscript, numerator etc.
    var subIndexType: AtomListSubIndexType = .none
    
    /// The index into the sublist.
    var subIndex: AtomListIndex?
    
    var finalIndex: Int {
        if self.subIndexType == .none {
            return self.atomIndex
        } else {
            return self.subIndex?.finalIndex ?? 0
        }
    }
    
    func prevIndex() -> AtomListIndex? {
        if self.subIndexType == .none {
            if self.atomIndex > 0 {
                return AtomListIndex(level0Index: self.atomIndex - 1)
            }
        } else {
            if let prevSubIndex = self.subIndex?.prevIndex() {
                return AtomListIndex(at: self.atomIndex, with: prevSubIndex, type: self.subIndexType)
            }
        }
        return nil
    }
    
    func nextIndex() -> AtomListIndex {
        if self.subIndexType == .none {
            return AtomListIndex(level0Index: self.atomIndex + 1)
        } else if self.subIndexType == .nucleus {
            return AtomListIndex(at: self.atomIndex + 1, with: self.subIndex, type: self.subIndexType)
        } else {
            return AtomListIndex(at: self.atomIndex, with: self.subIndex?.nextIndex(), type: self.subIndexType)
        }
    }
    
    /**
     * Returns true if this index represents the beginning of a line. Note there may be multiple lines in a MTMathList,
     * e.g. a superscript or a fraction numerator. This returns true if the innermost subindex points to the beginning of a
     * line.
     */
    func isBeginningOfLine() -> Bool {
        return self.finalIndex == 0
    }
    
    func isAtSameLevel(with index: AtomListIndex?) -> Bool {
        if self.subIndexType != index?.subIndexType {
            return false
        } else if self.subIndexType == .none {
            // No subindexes, they are at the same level.
            return true
        } else if (self.atomIndex != index?.atomIndex) {
            return false
        } else {
            return self.subIndex?.isAtSameLevel(with: index?.subIndex) ?? false
        }
    }
    
    /** Returns the type of the innermost sub index. */
    func finalSubIndexType() -> AtomListSubIndexType {
        if self.subIndex?.subIndex != nil {
            return self.subIndex!.finalSubIndexType()
        } else {
            return self.subIndexType
        }
    }
    
    /** Returns true if any of the subIndexes of this index have the given type. */
    func hasSubIndex(ofType type: AtomListSubIndexType) -> Bool {
        if self.subIndexType == type {
            return true
        } else {
            return self.subIndex?.hasSubIndex(ofType: type) ?? false
        }
    }
    
    func levelUp(with subIndex: AtomListIndex?, type: AtomListSubIndexType) -> AtomListIndex {
        if self.subIndexType == .none {
            return AtomListIndex(at: self.atomIndex, with: subIndex, type: type)
        }
        
        return AtomListIndex(at: self.atomIndex, with: self.subIndex?.levelUp(with: subIndex, type: type), type: self.subIndexType)
    }
    
    func levelDown() -> AtomListIndex? {
        if self.subIndexType == .none {
            return nil
        }
        
        if let subIndexDown = self.subIndex?.levelDown() {
            return AtomListIndex(at: self.atomIndex, with: subIndexDown, type: self.subIndexType)
        } else {
            return AtomListIndex(level0Index: self.atomIndex)
        }
    }
    
    /** Factory function to create a `MTMathListIndex` with no subindexes.
     @param index The index of the atom that the `MTMathListIndex` points at.
     */
    init(level0Index: Int) {
        self.atomIndex = level0Index
    }
    
    convenience init(at location: Int, with subIndex: AtomListIndex?, type: AtomListSubIndexType) {
        self.init(level0Index: location)
        self.subIndexType = type
        self.subIndex = subIndex
    }
}

extension AtomListIndex: CustomStringConvertible {
    var description: String {
        if self.subIndex != nil {
            return "[\(self.atomIndex), \(self.subIndexType.rawValue):\(self.subIndex!)]"
        }
        return "[\(self.atomIndex)]"
    }
}

extension AtomListIndex: Hashable {
    var hashValue: Int {
        let prime = 31
        var hash = self.atomIndex
        
        hash = hash * prime + self.subIndexType.rawValue
        hash = hash * prime + (self.subIndex?.hashValue ?? 0)
        
        return hash
    }
}

extension AtomListIndex: Equatable {
    static func ==(lhs: AtomListIndex, rhs: AtomListIndex) -> Bool {
        if lhs.atomIndex != rhs.atomIndex || lhs.subIndexType != rhs.subIndexType {
            return false
        }
        
        if rhs.subIndex != nil {
            return rhs.subIndex == lhs.subIndex
        } else {
            return lhs.subIndex == nil
        }
    }
}
