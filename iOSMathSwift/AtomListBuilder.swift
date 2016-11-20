//
//  AtomListBuilder.swift
//  iOSMathSwift
//
//  Created by Anh Phan Tran on 11/19/16.
//  Copyright © 2016 Anh Phan Tran. All rights reserved.
//

import Foundation

/** `MTMathListBuilder` is a class for parsing LaTeX into an `MTMathList` that
 can be rendered and processed mathematically.
 */
class EnvProperties {
    var envName: String?
    var ended: Bool
    var numOfRows: Int
    
    init(name: String?) {
        self.envName = name
        self.numOfRows = 0
        self.ended = false
    }
}

public class AtomListBuilder {
    var string: String
    var currentCharIndex: Int
    var currentInnerAtom: AtomInner?
    var currentEnv: EnvProperties?
    
    var hasCharacters: Bool {
        return currentCharIndex < self.string.characters.count
    }
    
    public static let spaceToCommands: [CGFloat: String] = [
        3 : ",",
        4 : ">",
        5 : ";",
        (-3) : "!",
        18 : "quad",
        36 : "qquad",
    ]
    
    public static let styleToCommands: [AtomLineStyle: String] = [
        AtomLineStyle.display: "displaystyle",
        AtomLineStyle.text: "textstyle",
        AtomLineStyle.script: "scriptstyle",
        AtomLineStyle.scriptOfScript: "scriptscriptstyle"
    ]
    
    init(string: String) {
        self.string = string
        self.currentCharIndex = 0
    }
    
    func build() -> AtomList? {
        if let list = self.buildInternal(oneCharOnly: false) {
            if self.hasCharacters {
                print("Mismatched braces: \(self.string)")
                return nil
            }
            
            return list
        } else {
            return nil
        }
    }
    
    public static func build(fromString string: String) -> AtomList? {
        let builder = AtomListBuilder(string: string)
        return builder.build()
    }
    
    public static func convertToString(_ atomList: AtomList) -> String {
        var output = ""
        
        for atom in atomList.atoms {
            switch atom.type {
            case .fraction:
                if let frac = atom as? AtomFraction {
                    if frac.hasRule {
                        output += "\\frac{\(AtomListBuilder.convertToString(frac.numerator!))}{\(AtomListBuilder.convertToString(frac.denominator!))}"
                    } else {
                        var command: String? = nil
                        
                        if frac.leftDelimiter == nil && frac.rightDelimiter == nil {
                            command = "atop"
                        } else if frac.leftDelimiter == "(" && frac.rightDelimiter == ")" {
                            command = "choose"
                        } else if frac.leftDelimiter == "{" && frac.rightDelimiter == "}" {
                            command = "brace"
                        } else if frac.leftDelimiter == "[" && frac.rightDelimiter == "]" {
                            command = "brack"
                        } else {
                            command = "atopwithdelims\(frac.leftDelimiter)\(frac.rightDelimiter)"
                        }
                        
                        output += "{\(convertToString(frac.numerator!)) \\\(command) \(convertToString(frac.denominator!))}"
                    }
                }
                break
            case .radical:
                output += "\\sqrt"
                if let rad = atom as? AtomRadical {
                    if rad.degree != nil {
                        output += "[\(convertToString(rad.degree!))]"
                    }
                    output += "{\(convertToString(rad.radicand!))}"
                }
                break
            case .inner:
                if let inner = atom as? AtomInner {
                    if inner.leftBoundary != nil || inner.rightBoundary != nil {
                        if inner.leftBoundary != nil {
                            output += "\\left\(delimToString(delim: inner.leftBoundary!))"
                        } else {
                            output += "\\left. "
                        }
                        
                        output += convertToString(inner.innerList!)
                        
                        if inner.rightBoundary != nil {
                            output += "\\right\(delimToString(delim: inner.rightBoundary!))"
                        } else {
                            output += "\\right. "
                        }
                    } else {
                        output += "{\(convertToString(inner.innerList!))}"
                    }
                }
                break
            case .table:
                if let table = atom as? AtomTable {
                    if table.environment != nil {
                        output += "\\begin{\(table.environment!)}"
                    }
                    
                    for i in 0..<table.numberOfRows() {
                        for j in 0..<table.cells[i].count {
                            let cell = table.cells[i][j]
                            
                            if table.environment == "matrix" {
                                if cell.atoms.count >= 1 && cell.atoms[0].type == .style {
                                    // remove first atom
                                    cell.atoms.removeFirst()
                                }
                            }
                            if table.environment == "eqalign" || table.environment == "aligned" || table.environment == "split" {
                                if j == 1 && cell.atoms.count >= 1 && cell.atoms[0].type == .ordinary && cell.atoms[0].nucleus.characters.count == 0 {
                                    // remove empty nucleus added for spacing
                                    cell.atoms.removeFirst()
                                }
                            }
                            
                            output += convertToString(cell)
                            
                            if j < table.cells[i].count {
                                output += "&"
                            }
                        }
                        if i < table.numberOfRows() - 1 {
                            output += "\\\\ "
                        }
                    }
                    
                    if table.environment != nil {
                        output += "\\end{\(table.environment!)}"
                    }
                }
                break
            case .overline:
                if let overline = atom as? AtomOverLine {
                    output += "\\overline"
                    output += "{\(convertToString(overline.innerList!))}"
                }
                break
            case .underline:
                if let underline = atom as? AtomUnderLine {
                    output += "\\underline"
                    output += "{\(convertToString(underline.innerList!))}"
                }
                break
            case .accent:
                if let accent = atom as? AtomAccent {
                    output += "\\\(AtomFactory.getName(of: accent)){\(convertToString(accent.innerList!))}"
                }
                break
            case .space:
                if let space = atom as? AtomSpace {
                    if let command = AtomListBuilder.spaceToCommands[space.space] {
                        output += "\\\(command)"
                    } else {
                        output += String.init(format: "\\mkern%.1fmu", space.space)
                    }
                }
                break
            case .style:
                if let style = atom as? AtomStyle {
                    if let command = AtomListBuilder.styleToCommands[style.style] {
                        output += "\\\(command)"
                    }
                }
                break
            default:
                if atom.nucleus.characters.count == 0 {
                    output += "{}"
                } else if atom.nucleus == "\u{2236}" {
                    output += ":"
                } else if atom.nucleus == "\u{2212}" {
                    output += "-"
                } else {
                    if let command = AtomFactory.latexSymbolName(for: atom) {
                        output += "\\\(command)"
                    } else {
                        output += "\(atom.nucleus)"
                    }
                }
                break
            }
            
            if atom.superScript != nil {
                output += "^{\(convertToString(atom.superScript!))}"
            }
            
            if atom.subScript != nil {
                output += "_{\(convertToString(atom.subScript!))}"
            }
        }
        
        return output
    }
    
    public static func delimToString(delim: Atom) -> String {
        if let command = AtomFactory.getDelimiterName(of: delim) {
            let singleChars = [ "(", ")", "[", "]", "<", ">", "|", ".", "/"]
            if singleChars.contains(command) {
                return command
            } else if command == "||" {
                return "\\|"
            } else {
                return "\\\(command)"
            }
        }
        
        return ""
    }
    
    func getNextCharacter() -> String? {
        assert(self.hasCharacters, "Retrieving character at index \(self.currentCharIndex) beyond length \(self.string.characters.count)")
        if self.hasCharacters {
            let currentStringIndex = self.string.index(self.string.startIndex, offsetBy: self.currentCharIndex)
            self.currentCharIndex += 1
            return self.string.substring(with:
                currentStringIndex..<self.string.index(after: currentStringIndex)
            )
        }
        return nil
    }
    
    func unlookCharacter() {
        assert(self.currentCharIndex > 0, "Unlooking when at the first character.")
        if self.currentCharIndex > 0 {
            self.currentCharIndex -= 1
        } else {
            print("unlooking at first character")
        }
    }
    
    func buildInternal(oneCharOnly: Bool) -> AtomList? {
        return self.buildInternal(oneCharOnly: oneCharOnly, stopChar: nil)
    }
    
    func buildInternal(oneCharOnly: Bool, stopChar: String?) -> AtomList? {
        let list = AtomList()
        
        assert(!(oneCharOnly && (stopChar != nil)), "Cannot set both oneCharOnly and stopChar.")
        
        if oneCharOnly && stopChar != nil {
            print("Cant set both oneCharOnly and stopChar")
            return nil
        }
        
        var prevAtom: Atom? = nil
        
        while self.hasCharacters {
            var atom: Atom? = nil
            let char = self.getNextCharacter()!
            
            if oneCharOnly {
                if char == "^" ||
                    char == "}" ||
                    char == "_" ||
                    char == "&" {
                    self.unlookCharacter()
                    return list
                }
            }
            
            if stopChar != nil && char == stopChar {
                return list
            }
            
            if char == "^" {
                assert(!oneCharOnly, "This should have been handled before")
                if (prevAtom == nil || prevAtom!.superScript != nil || !prevAtom!.isScriptsAllowed()) {
                    // If there is no previous atom, or if it already has a superscript
                    // or if scripts are not allowed for it, then add an empty node.
                    prevAtom = Atom(type: .ordinary, value: "")
                    list.add(prevAtom!)
                }
                
                prevAtom!.setSuperScript(self.buildInternal(oneCharOnly: true))
                continue
            } else if char == "_" {
                assert(!oneCharOnly, "This should have been handled before")
                if (prevAtom == nil || prevAtom!.subScript != nil || !prevAtom!.isScriptsAllowed()) {
                    // If there is no previous atom, or if it already has a subcript
                    // or if scripts are not allowed for it, then add an empty node.
                    prevAtom = Atom(type: .ordinary, value: "")
                    list.add(prevAtom!)
                }
                prevAtom!.setSubScript(self.buildInternal(oneCharOnly: true))
                continue
            } else if char == "{" {
                // this puts us in a recursive routine, and sets oneCharOnly to false and no stop character
                if let subList = self.buildInternal(oneCharOnly: false, stopChar: "}") {
                    prevAtom = subList.atoms.last
                    list.append(subList)
                    if oneCharOnly {
                        return list
                    }
                    continue
                } else {
                    print("open brackets but inner...")
                    return nil
                }
            } else if char == "}" {
                assert(!oneCharOnly, "This should have been handled before")
                assert(stopChar == nil, "This should have been handled before")
                // We encountered a closing brace when there is no stop set, that means there was no
                // corresponding opening brace.
                print("Mismatched braces")
                return nil
            } else if char == "\\" {
                let command = self.readCommand()
                
                if let done = self.stop(command: command, list: list, stopChar: stopChar) {
                    return done
                }
                else {
                    atom = self.atom(forCommand: command)
                    
                    if atom == nil {
                        print("Internal error")
                        return nil
                    }
                }
            } else if char == "&" {
                assert(!oneCharOnly, "This should have been handled before")
                if self.currentEnv != nil {
                    return list
                } else {
                    if let table = self.buildTable(env: nil, firstList: list, isRow: false) {
                        return AtomList(atoms: [table])
                    }
                }
            } else {
                atom = AtomFactory.atom(for: char)
                
                if atom == nil {
                    continue
                }
            }
            
            assert(atom != nil, "Atom shouldn't be nil")
            
            if atom == nil {
                print("wtf atom why nil?")
                return nil
            }
            
            list.add(atom!)
            prevAtom = atom
            
            if oneCharOnly {
                return list
            }
        }
        
        if stopChar != nil {
            if stopChar == "}" {
                print("Missing Closing Brace")
            } else {
                print("Expected Character not found: \(stopChar)")
            }
        }
        
        return list
    }
    
    func atom(forCommand command: String) -> Atom? {
        if let atom = AtomFactory.atom(forLatexSymbol: command) {
            return atom
        }
        
        if let accent = AtomFactory.getAccent(withName: command) {
            accent.innerList = self.buildInternal(oneCharOnly: true)
            return accent
        } else if command == "frac" {
            let frac = AtomFraction()
            frac.numerator = self.buildInternal(oneCharOnly: true)
            frac.denominator = self.buildInternal(oneCharOnly: true)
            return frac
        } else if command == "binom" {
            let frac = AtomFraction(hasRule: false)
            frac.numerator = self.buildInternal(oneCharOnly: true)
            frac.denominator = self.buildInternal(oneCharOnly: true)
            frac.leftDelimiter = "("
            frac.rightDelimiter = ")"
            return frac
        } else if command == "sqrt" {
            let rad = AtomRadical()
            let char = self.getNextCharacter()
            
            if char == "[" {
                rad.degree = self.buildInternal(oneCharOnly: false, stopChar: "]")
                rad.radicand = self.buildInternal(oneCharOnly: true)
            } else {
                self.unlookCharacter()
                rad.radicand = self.buildInternal(oneCharOnly: true)
            }
            return rad
        } else if command == "left" {
            let oldInner = self.currentInnerAtom
            
            self.currentInnerAtom = AtomInner()
            if let leftBoundary = self.getBoundary(delimiterType: "left") {
                self.currentInnerAtom!.leftBoundary = leftBoundary
            } else {
                return nil
            }
            
            self.currentInnerAtom?.innerList = self.buildInternal(oneCharOnly: false)
            
            if self.currentInnerAtom?.rightBoundary == nil {
                print("Missing \\right")
                return nil
            }
            
            let newInner = self.currentInnerAtom
            currentInnerAtom = oldInner
            return newInner
        } else if command == "overline" {
            let over = AtomOverLine()
            over.innerList = self.buildInternal(oneCharOnly: true)
            
            return over
        } else if command == "underline" {
            let under = AtomUnderLine()
            under.innerList = self.buildInternal(oneCharOnly: true)
            
            return under
        } else if command == "begin" {
            if let env = self.readEnvironment() {
                let table = self.buildTable(env: env, firstList: nil, isRow: false)
                return table
            } else {
                return nil
            }
        } else {
            print("Invalid Command")
            return nil
        }
    }
    
    func stop(command: String, list: AtomList, stopChar: String?) -> AtomList? {
        let fractionCommands = [
            "over": [],
            "atop": [],
            "choose": ["(", ")"],
            "brack": ["[", "]"],
            "brace": ["{", "}"]
        ]
        
        if command == "right" {
            if self.currentInnerAtom == nil {
                print("missing left")
                return nil
            }
            
            if let rightBoundary = self.getBoundary(delimiterType: "right") {
                self.currentInnerAtom!.rightBoundary = rightBoundary
                
                return list
            } else {
                return nil
            }
        } else if let delims = fractionCommands[command] {
            let frac: AtomFraction
            if command == "over" {
                frac = AtomFraction()
            } else {
                frac = AtomFraction(hasRule: false)
            }
            
            if delims.count == 2 {
                frac.leftDelimiter = delims[0]
                frac.rightDelimiter = delims[1]
            }
            
            frac.numerator = list
            frac.denominator = self.buildInternal(oneCharOnly: false, stopChar: stopChar)
            
            let fracList = AtomList()
            fracList.add(frac)
            return fracList
        } else if command == "\\" ||
            command == "cr" {
            if currentEnv != nil {
                currentEnv!.numOfRows += 1
                return list
            } else {
                if let table = self.buildTable(env: nil, firstList: list, isRow: true) {
                    return AtomList(atoms: [table])
                } else {
                    return nil
                }
            }
        } else if command == "end" {
            if self.currentEnv == nil {
                print("Missing \\begin")
                return nil
            }
            
            if let env = self.readEnvironment() {
                if env != self.currentEnv?.envName {
                    print("Begin environment name \(currentEnv?.envName) does not match end name: \(env)")
                    return nil
                }
                
                currentEnv?.ended = true
                
                return list
            } else {
                return nil
            }
        }
        return nil
    }
    
    func readEnvironment() -> String? {
        if !self.expectCharacter("{") {
            // We didn't find an opening brace, so no env found.
            print("Missing {")
            return nil
        }
        
        self.skipSpace()
        let env = self.readString()
        
        if !self.expectCharacter("}") {
            // We didn't find an closing brace, so invalid format.
            print("Missing {")
            return nil;
        }
        return env
    }
    
    func expectCharacter(_ char: String) -> Bool {
        self.skipSpace()
        
        if self.hasCharacters {
            let nextChar = self.getNextCharacter()!
            
            if nextChar == char {
                return true
            } else {
                self.unlookCharacter()
                return false
            }
        }
        return false
    }
    
    func buildTable(env: String?, firstList: AtomList?, isRow: Bool) -> Atom? {
        // Save the current env till an new one gets built.
        let oldEnv = self.currentEnv
        
        currentEnv = EnvProperties(name: env)
        
        var currentRow = 0
        var currentCol = 0
        
        var rows = [[AtomList]]()
        
        if firstList != nil {
            rows[currentRow][currentCol] = firstList!
            
            if isRow {
                currentEnv?.numOfRows += 1
                currentRow += 1
            } else {
                currentCol += 1
            }
        }
        
        while !currentEnv!.ended && self.hasCharacters {
            if let list = self.buildInternal(oneCharOnly: false) {
                rows[currentRow][currentCol] = list
                currentCol += 1
                if self.currentEnv!.numOfRows > currentRow {
                    currentRow = self.currentEnv!.numOfRows
                    currentCol = 0
                }
            } else {
                return nil
            }
        }
        
        if !currentEnv!.ended && currentEnv?.envName == nil {
            print("Missing \\end")
            return nil
        }
        
        if let table = AtomFactory.table(withEnvironment: currentEnv?.envName, rows: rows) {
            self.currentEnv = oldEnv
            return table
        } else {
            return nil
        }
    }
    
    func getBoundary(delimiterType: String) -> Atom? {
        if let delim = self.readDelimiter() {
            if let boundary = AtomFactory.boundary(forDelimiter: delim) {
                return boundary
            } else {
                print("Invalid delimiter for \(delimiterType): \(delim)")
                return nil
            }
        } else {
            print("Missing delimiter for \(delimiterType)")
            return nil
        }
    }
    
    func readDelimiter() -> String? {
        self.skipSpace()
        
        while self.hasCharacters {
            let char = self.getNextCharacter()!
            
            if char == "\\" {
                let command = self.readCommand()
                if command == "|" {
                    return "||"
                }
                return command
            } else {
                return char
            }
        }
        
        return nil
    }
    
    func skipSpace() {
        while self.hasCharacters {
            let char = self.getNextCharacter()
            
            let asciiCharacterSet = CharacterSet(charactersIn: UnicodeScalar(0x21)...UnicodeScalar(0x7e))
            
            if char!.rangeOfCharacter(from: asciiCharacterSet) != nil {
                self.unlookCharacter()
                return
            } else {
                continue
            }
        }
    }
    
    func readCommand() -> String {
        let singleChars = [
            "{",
            "}",
            "$",
            "#",
            "%",
            "_",
            "|",
            " ",
            ",",
            ">",
            ";",
            "!",
            "\\"
        ]
        
        if self.hasCharacters {
            if let char = self.getNextCharacter() {
                if singleChars.contains(char) {
                    return char
                } else {
                    self.unlookCharacter()
                }
            }
        }
        
        return self.readString()
    }
    
    func readString() -> String {
        // a string of all upper and lower case characters.
        var output = ""
        while self.hasCharacters {
            if let char = self.getNextCharacter() {
                if char.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil ||
                    char.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil {
                    output += char
                } else {
                    self.unlookCharacter()
                    break
                }
            }
        }
        
        return output
    }
}
