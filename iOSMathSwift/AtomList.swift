//
//  AtomList.swift
//  iOSMathSwift
//
//  Created by Anh Phan Tran on 11/18/16.
//  Copyright © 2016 Anh Phan Tran. All rights reserved.
//

import Foundation

// represent list of math objects
extension AtomList: CustomStringConvertible {
    public var description: String {
        var description = ""
        for atom in self.atoms {
            description += atom.description
        }
        return description
    }
}

public class AtomList {
    public var atoms: [Atom]
    
    public var finalized: AtomList {
        let finalizedList = AtomList()
        let zeroRange = NSMakeRange(0, 0)
        
        var prevNode: Atom? = nil
        for atom in self.atoms {
            let newNode = atom.finalized
            
            if NSEqualRanges(zeroRange, atom.indexRange) {
                let index = prevNode == nil ? 0 : prevNode!.indexRange.location + prevNode!.indexRange.length
                newNode.indexRange = NSMakeRange(index, 1)
            }
            
            switch newNode.type {
            case .binaryOperator:
                if prevNode == nil || prevNode!.isNotBinaryOperator()  {
                    newNode.type = .unaryOperator
                }
                break
            case .relation, .punctuation, .close:
                if prevNode != nil &&
                    prevNode!.type == .binaryOperator {
                    prevNode!.type = .unaryOperator
                }
                break
            case .number:
                if prevNode != nil &&
                    prevNode!.type == .number &&
                    prevNode!.subScript == nil &&
                    prevNode!.superScript == nil {
                    prevNode!.fuse(with: newNode)
                    continue
                }
                break
            default: break
            }
            
            finalizedList.add(newNode)
            prevNode = newNode
        }
        
        if prevNode != nil && prevNode!.type == .binaryOperator {
            prevNode!.type = .unaryOperator
            finalizedList.removeLastAtom()
            finalizedList.add(prevNode!)
        }
        
        return finalizedList
    }
    
    public init(atoms: [Atom]) {
        self.atoms = atoms
    }
    
    public init() {
        self.atoms = []
    }
    
    func add(_ atom: Atom) {
        if self.shouldAllow(atom: atom) {
            self.atoms.append(atom)
        } else {
            print("error, cannot add atom of type \(atom.type.rawValue) into atomlist")
        }
    }
    
    func insert(_ atom: Atom, at index: Int) {
        if self.shouldAllow(atom: atom) {
            self.atoms.insert(atom, at: index)
        } else {
            print("error, cannot add atom of type \(atom.type.rawValue) into atomlist")
        }
    }
    
    func append(_ list: AtomList) {
        self.atoms += list.atoms
    }
    
    func removeLastAtom() {
        if self.atoms.count > 0 {
            self.atoms.removeLast()
        }
    }
    
    func removeAtom(at index: Int) {
        self.atoms.remove(at: index)
    }
    
    func removeAtom(in range: ClosedRange<Int>) {
        self.atoms.removeSubrange(range)
    }
    
    func shouldAllow(atom: Atom) -> Bool {
        return atom.type != .boundary
    }
}
