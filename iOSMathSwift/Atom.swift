//
//  AtomFactory.swift
//  iOSMathSwift
//
//  Created by Anh Phan Tran on 11/18/16.
//  Copyright © 2016 Anh Phan Tran. All rights reserved.
//

import Foundation

// type defines spacing and how it is rendered
public enum AtomType: String {
    case ordinary = "Ordinary" // number or text
    case number = "Number" // number
    case variable = "Variable"// text in italic
    case largeOperator = "Large Operator"// sin/cos, integral
    case binaryOperator = "Binary Operator"// \bin
    case unaryOperator = "Unary Operator" //
    case relation = "Relation"// = < >
    case open = "Open"// open bracket
    case close = "Close"// close bracket
    case fraction = "Fraction"// \frac
    case radical = "Radical"// \sqrt
    case punctuation = "Punctuation"// ,
    case placeholder = "Placeholder"// inner atom
    case inner = "Inner"// embedded list
    case underline = "Underline"// underlined atom
    case overline = "Overline"// overlined atom
    case accent = "Accent"// accented atom
    
    // these atoms do not support subscripts/superscripts:
    case boundary = "Boundary"
    case space = "Space"
    case style = "Style"
    case table = "Table"
}

public class Atom: Any, CustomStringConvertible {
    public var type: AtomType
    public var subScript: AtomList?
    public var superScript: AtomList?
    
    public func setSuperScript(_ list: AtomList?) {
        if self.isScriptsAllowed() {
            self.superScript = list
        } else {
            print("superscripts not allowed for atom \(self.type.rawValue)")
            self.superScript = nil
        }
    }
    
    public func setSubScript(_ list: AtomList?) {
        if self.isScriptsAllowed() {
            self.subScript = list
        } else {
            print("subscripts not allowed for atom \(self.type.rawValue)")
            self.subScript = nil
        }
    }
    
    public var description: String {
        var string = ""
        
        string += self.nucleus
        if self.superScript != nil {
            string += "^{\(self.superScript!.description)}"
        }
        if self.subScript != nil {
            string += "_{\(self.subScript!.description)}"
        }
        
        return string
    }
    
    public var nucleus: String = ""
    public var finalized: Atom {
        let finalized = self
        if finalized.superScript != nil {
            finalized.superScript = finalized.superScript!.finalized
        }
        if finalized.subScript != nil {
            finalized.subScript = finalized.subScript!.finalized
        }
        return finalized
    }
    
    // atoms that fused to create this one
    public var childAtoms = [Atom]()
    
    // indexRange in list that this atom tracks:
    public var indexRange: NSRange = NSRange(location: 0, length: 0)
    
    func fuse(with atom: Atom) {
        assert(self.subScript == nil, "Cannot fuse into an atom which has a subscript: \(self)");
        assert(self.superScript == nil, "Cannot fuse into an atom which has a superscript: \(self)");
        assert(atom.type == self.type, "Only atoms of the same type can be fused. \(self), \(atom)");
        guard self.subScript == nil,
            self.superScript == nil,
            self.type == atom.type
        else {
            print("Can't fuse these 2 atom")
            return
        }
        
        self.childAtoms.append(self)
        if atom.childAtoms.count > 0 {
            self.childAtoms += atom.childAtoms
        } else {
            self.childAtoms.append(atom)
        }
        
        // Update nucleus:
        self.nucleus += atom.nucleus
        
        // Update range:
        self.indexRange.length += atom.indexRange.length
        
        // Update super/subscript:
        self.superScript = atom.superScript
        self.subScript = atom.subScript
    }
    
    func isScriptsAllowed() -> Bool {
        return self.type != .boundary &&
            self.type != .space &&
            self.type != .style &&
            self.type != .table
    }
    
    public init(type: AtomType, value: String) {
        self.type = type
        self.nucleus = value
    }
}

extension Atom {
    func isNotBinaryOperator() -> Bool {
        if self.type == .binaryOperator ||
            self.type == .punctuation ||
            self.type == .largeOperator ||
            self.type == .relation ||
            self.type == .open {
            return true
        } else {
            return false
        }
    }
}

public class AtomFraction: Atom {
    public var hasRule: Bool = true
    public var leftDelimiter: String?
    public var rightDelimiter: String?
    public var numerator: AtomList? = AtomList()
    public var denominator: AtomList? = AtomList()
    
    override public var description: String {
        var string = ""
        if self.hasRule {
            string += "\\atop"
        } else {
            string += "\\frac"
        }
        if self.leftDelimiter != nil {
            string += "[\(self.leftDelimiter)]"
        }
        if self.rightDelimiter != nil {
            string += "[\(self.rightDelimiter)]"
        }
        
        string += "{\(self.numerator?.description ?? "placeholder")}{\(self.denominator?.description ?? "placeholder")}"
        
        if self.superScript != nil {
            string += "^{\(self.superScript!.description)}"
        }
        if self.subScript != nil {
            string += "_{\(self.subScript!.description)}"
        }
        
        return string
    }
    
    override public var finalized: Atom {
        let finalized: AtomFraction = super.finalized as! AtomFraction
        
        finalized.numerator = finalized.numerator?.finalized
        finalized.denominator = finalized.denominator?.finalized
        
        return finalized
    }
    
    convenience init(hasRule: Bool = true) {
        self.init(type: .fraction, value: "")
        self.hasRule = hasRule
    }
}

public class AtomRadical: Atom {
    // Under the roof
    var radicand: AtomList? = AtomList()
    
    // Value on radical sign
    var degree: AtomList?
    
    convenience init() {
        self.init(type: .radical, value: "")
    }
    
    override public var description: String {
        var string = "\\sqrt"
        
        if self.degree != nil {
            string += "[\(self.degree!.description)]"
        }
        
        if self.radicand != nil {
            string += "{\(self.radicand?.description ?? "placeholder")}"
        }
        
        if self.superScript != nil {
            string += "^{\(self.superScript!.description)}"
        }
        if self.subScript != nil {
            string += "_{\(self.subScript!.description)}"
        }
        
        return string
    }
    
    override public var finalized: Atom {
        let finalized: AtomRadical = super.finalized as! AtomRadical
        
        finalized.radicand = finalized.radicand?.finalized
        finalized.degree = finalized.degree?.finalized
        
        return finalized
    }
}

public class AtomLargeOperator: Atom {
    var limits: Bool = false
    
    convenience init(value: String, limits: Bool = false) {
        self.init(type: .largeOperator, value: value)
        self.limits = limits
    }
}

public class AtomInner: Atom {
    var innerList: AtomList?
    var leftBoundary: Atom? {
        get {
            return self.leftBoundary
        }
        set {
            if newValue == nil {
                self.leftBoundary = nil
            } else if newValue != nil && newValue!.type ==  .boundary {
                self.leftBoundary = newValue
            } else {
                print("left boundary mus be of type boundary")
            }
        }
    }
    var rightBoundary: Atom? {
        get {
            return self.leftBoundary
        }
        set {
            if newValue == nil {
                self.rightBoundary = nil
            } else if newValue != nil && newValue!.type ==  .boundary {
                self.rightBoundary = newValue
            } else {
                print("left boundary mus be of type boundary")
            }
        }
    }
    
    override public var description: String {
        var string = "\\inner"
        
        if self.leftBoundary != nil {
            string += "[\(self.leftBoundary!.nucleus)]"
        }
        string += "{\(self.innerList?.description)}"
        
        if self.rightBoundary != nil {
            string += "[\(self.rightBoundary!.nucleus)]"
        }
        
        if self.superScript != nil {
            string += "^{\(self.superScript!.description)}"
        }
        if self.subScript != nil {
            string += "_{\(self.subScript!.description)}"
        }
        
        return string
    }
    
    override public var finalized: Atom {
        let finalized: AtomInner = super.finalized as! AtomInner
        
        finalized.innerList = finalized.innerList?.finalized
        
        return finalized
    }
    
    convenience init() {
        self.init(type: .inner, value: "")
    }
}

public class AtomOverLine: Atom {
    var innerList: AtomList?
    
    override public var finalized: Atom {
        let finalized: AtomOverLine = super.finalized as! AtomOverLine
        
        finalized.innerList = finalized.innerList?.finalized
        
        return finalized
    }
    
    convenience init() {
        self.init(type: .overline, value: "")
    }
}

public class AtomUnderLine: Atom {
    var innerList: AtomList?
    
    override public var finalized: Atom {
        let finalized: AtomUnderLine = super.finalized as! AtomUnderLine
        
        finalized.innerList = finalized.innerList?.finalized
        
        return finalized
    }
    
    convenience init() {
        self.init(type: .underline, value: "")
    }
}

public class AtomAccent: Atom {
    var innerList: AtomList?
    
    override public var finalized: Atom {
        let finalized: AtomAccent = super.finalized as! AtomAccent
        
        finalized.innerList = finalized.innerList?.finalized
        
        return finalized
    }
    
    convenience init(value: String) {
        self.init(type: .accent, value: value)
    }
}

public class AtomSpace: Atom {
    var space: CGFloat = 0
    
    convenience init(space: CGFloat) {
        self.init(type: .space, value: "")
        self.space = space
    }
}

public enum AtomLineStyle {
    case display
    case text
    case script
    case scriptOfScript
}

public class AtomStyle: Atom {
    var style: AtomLineStyle = .display
    
    convenience init(style: AtomLineStyle = .display) {
        self.init(type: .space, value: "")
        self.style = style
    }
}

public enum AtomTableColumnAlignment {
    case left
    case center
    case right
}

public class AtomTable: Atom {
    var alignments = [AtomTableColumnAlignment]()
    var cells = [[AtomList]]()
    
    var environment: String?
    var interColumnSpacing: CGFloat = 0
    var interRowAdditionalSpacing: CGFloat = 0
    
    override public var finalized: Atom {
        let finalized: AtomTable = super.finalized as! AtomTable
        
        for var row in finalized.cells {
            for i in 0..<row.count {
                row[i] = row[i].finalized
            }
        }
        
        return finalized
    }
    
    convenience init(environment: String? = nil) {
        self.init(type: .table, value: "")
        self.environment = environment
    }
    
    func set(cell: AtomList, at indexPath: IndexPath) {
        if self.cells.count <= indexPath.row {
            for _ in self.cells.count...indexPath.row {
                self.cells.append([])
            }
        }
        
        var rowArray = self.cells[indexPath.row]
        
        if rowArray.count <= indexPath.section {
            for _ in rowArray.count...indexPath.section {
                rowArray.append(AtomList())
            }
        }
        
        rowArray[indexPath.section] = cell
        
        self.cells[indexPath.row] = rowArray
    }
    
    func set(alignment: AtomTableColumnAlignment, forCol col: Int) {
        if self.alignments.count <= col {
            for _ in self.alignments.count...col {
                self.alignments.append(AtomTableColumnAlignment.center)
            }
        }
        
        self.alignments[col] = alignment
    }
    
    func getAlignmentOf(col: Int) -> AtomTableColumnAlignment {
        if self.alignments.count <= col {
            return AtomTableColumnAlignment.center
        } else {
            return self.alignments[col]
        }
    }
    
    func numberOfCols() -> Int {
        var numberOfCols = 0
        
        for row in self.cells {
            numberOfCols = max(numberOfCols, row.count)
        }
        
        return numberOfCols
    }
    
    func numberOfRows() -> Int {
        return self.cells.count
    }
}
