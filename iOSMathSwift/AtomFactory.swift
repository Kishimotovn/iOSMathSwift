//
//  AtomFactory.swift
//  iOSMathSwift
//
//  Created by Anh Phan Tran on 11/18/16.
//  Copyright © 2016 Anh Phan Tran. All rights reserved.
//

import Foundation

class AtomFactory {
    static let aliases = [
        "lnot" : "neg",
        "land" : "wedge",
        "lor" : "vee",
        "ne" : "neq",
        "le" : "leq",
        "ge" : "geq",
        "lbrace" : "{",
        "rbrace" : "}",
        "Vert" : "|",
        "gets" : "leftarrow",
        "to" : "rightarrow",
        "iff" : "Longleftrightarrow",
        "AA" : "angstrom"
    ]
    
    static let delimiters = [
        "." : "", // . means no delimiter
        "(" : "(",
        ")" : ")",
        "[" : "[",
        "]" : "]",
        "<" : "\u{2329}",
        ">" : "\u{232A}",
        "/" : "/",
        "\\\\" : "\\\\",
        "|" : "|",
        "lgroup" : "\u{27EE}",
        "rgroup" : "\u{27EF}",
        "||" : "\u{2016}",
        "Vert" : "\u{2016}",
        "vert" : "|",
        "uparrow" : "\u{2191}",
        "downarrow" : "\u{2193}",
        "updownarrow" : "\u{2195}",
        "Uparrow" : "\u{21D1}",
        "Downarrow" : "\u{21D3}",
        "Updownarrow" : "\u{21D5}",
        "backslash" : "\\\\",
        "rangle" : "\u{232A}",
        "langle" : "\u{2329}",
        "rbrace" : "}",
        "}" : "}",
        "{" : "{",
        "lbrace" : "{",
        "lceil" : "\u{2308}",
        "rceil" : "\u{2309}",
        "lfloor" : "\u{230A}",
        "rfloor" : "\u{230B}"
    ]
    
    var _delimValueToName: [String: String]? = nil
    var delimValueToName: [String: String] {
        if _delimValueToName == nil {
            var output = [String: String]()
            
            for (key, value) in AtomFactory.delimiters {
                if let existingValue = output[value] {
                    if key.characters.count > existingValue.characters.count {
                        continue
                    } else if key.characters.count == existingValue.characters.count {
                        if key.compare(existingValue) == .orderedDescending {
                            continue
                        }
                    }
                }
                
                output[value] = key
            }
            _delimValueToName = output
        }
        return _delimValueToName!
    }
    
    static let accents = [
        "grave" :  "\u{0300}",
        "acute" :  "\u{0301}",
        "hat" :  "\u{0302}",  // In our implementation hat and widehat behave the same.
        "tilde" :  "\u{0303}", // In our implementation tilde and widetilde behave the same.
        "bar" :  "\u{0304}",
        "breve" :  "\u{0306}",
        "dot" :  "\u{0307}",
        "ddot" :  "\u{0308}",
        "check" :  "\u{030C}",
        "vec" :  "\u{20D7}",
        "widehat" :  "\u{0302}",
        "widetilde" :  "\u{0303}"
    ]
    
    var _accentValueToName: [String: String]? = nil
    var accentValueToName: [String: String] {
        if _accentValueToName == nil {
            var output = [String: String]()
            
            for (key, value) in AtomFactory.accents {
                if let existingValue = output[value] {
                    if key.characters.count > existingValue.characters.count {
                        continue
                    } else if key.characters.count == existingValue.characters.count {
                        if key.compare(existingValue) == .orderedDescending {
                            continue
                        }
                    }
                }
                
                output[value] = key
            }
            
            _accentValueToName = output
        }
        
        return _accentValueToName!
    }
    
    var supportedLatexSymbols: [String: Atom] = [
        "square" : AtomFactory.placeholder(),
        
         // Greek characters
        "alpha" : Atom(type: .variable, value: "\u{03B1}"),
        "beta" : Atom(type: .variable, value: "\u{03B2}"),
        "gamma" : Atom(type: .variable, value: "\u{03B3}"),
        "delta" : Atom(type: .variable, value: "\u{03B4}"),
        "varepsilon" : Atom(type: .variable, value: "\u{03B5}"),
        "zeta" : Atom(type: .variable, value: "\u{03B6}"),
        "eta" : Atom(type: .variable, value: "\u{03B7}"),
        "theta" : Atom(type: .variable, value: "\u{03B8}"),
        "iota" : Atom(type: .variable, value: "\u{03B9}"),
        "kappa" : Atom(type: .variable, value: "\u{03BA}"),
        "lambda" : Atom(type: .variable, value: "\u{03BB}"),
        "mu" : Atom(type: .variable, value: "\u{03BC}"),
        "nu" : Atom(type: .variable, value: "\u{03BD}"),
        "xi" : Atom(type: .variable, value: "\u{03BE}"),
        "omicron" : Atom(type: .variable, value: "\u{03BF}"),
        "pi" : Atom(type: .variable, value: "\u{03C0}"),
        "rho" : Atom(type: .variable, value: "\u{03C1}"),
        "varsigma" : Atom(type: .variable, value: "\u{03C1}"),
        "sigma" : Atom(type: .variable, value: "\u{03C3}"),
        "tau" : Atom(type: .variable, value: "\u{03C4}"),
        "upsilon" : Atom(type: .variable, value: "\u{03C5}"),
        "varphi" : Atom(type: .variable, value: "\u{03C6}"),
        "chi" : Atom(type: .variable, value: "\u{03C7}"),
        "psi" : Atom(type: .variable, value: "\u{03C8}"),
        "omega" : Atom(type: .variable, value: "\u{03C9}"),
        // We mark the following greek chars as ordinary so that we don't try
        // to automatically italicize them as we do with variables.
        // These characters fall outside the rules of italicization that we have defined.
        "epsilon" : Atom(type: .ordinary, value: "\u{0001D716}"),
        "vartheta" : Atom(type: .ordinary, value: "\u{0001D717}"),
        "phi" : Atom(type: .ordinary, value: "\u{0001D719}"),
        "varrho" : Atom(type: .ordinary, value: "\u{0001D71A}"),
        "varpi" : Atom(type: .ordinary, value: "\u{0001D71B}"),

        // Capital greek characters
        "Gamma" : Atom(type: .variable, value: "\u{0393}"),
        "Delta" : Atom(type: .variable, value: "\u{0394}"),
        "Theta" : Atom(type: .variable, value: "\u{0398}"),
        "Lambda" : Atom(type: .variable, value: "\u{039B}"),
        "Xi" : Atom(type: .variable, value: "\u{039E}"),
        "Pi" : Atom(type: .variable, value: "\u{03A0}"),
        "Sigma" : Atom(type: .variable, value: "\u{03A3}"),
        "Upsilon" : Atom(type: .variable, value: "\u{03A5}"),
        "Phi" : Atom(type: .variable, value: "\u{03A6}"),
        "Psi" : Atom(type: .variable, value: "\u{03A8}"),
        "Omega" : Atom(type: .variable, value: "\u{03A9}"),

        // Open
        "lceil" : Atom(type: .open, value: "\u{2308}"),
        "lfloor" : Atom(type: .open, value: "\u{230A}"),
        "langle" : Atom(type: .open, value: "\u{27E8}"),
        "lgroup" : Atom(type: .open, value: "\u{27EE}"),

        // Close
        "rceil" : Atom(type: .close, value: "\u{2309}"),
        "rfloor" : Atom(type: .close, value: "\u{230B}"),
        "rangle" : Atom(type: .close, value: "\u{27E9}"),
        "rgroup" : Atom(type: .close, value: "\u{27EF}"),

        // Arrows
        "leftarrow" : Atom(type: .relation, value: "\u{2190}"),
        "uparrow" : Atom(type: .relation, value: "\u{2191}"),
        "rightarrow" : Atom(type: .relation, value: "\u{2192}"),
        "downarrow" : Atom(type: .relation, value: "\u{2193}"),
        "leftrightarrow" : Atom(type: .relation, value: "\u{2194}"),
        "updownarrow" : Atom(type: .relation, value: "\u{2195}"),
        "nwarrow" : Atom(type: .relation, value: "\u{2196}"),
        "nearrow" : Atom(type: .relation, value: "\u{2197}"),
        "searrow" : Atom(type: .relation, value: "\u{2198}"),
        "swarrow" : Atom(type: .relation, value: "\u{2199}"),
        "mapsto" : Atom(type: .relation, value: "\u{21A6}"),
        "Leftarrow" : Atom(type: .relation, value: "\u{21D0}"),
        "Uparrow" : Atom(type: .relation, value: "\u{21D1}"),
        "Rightarrow" : Atom(type: .relation, value: "\u{21D2}"),
        "Downarrow" : Atom(type: .relation, value: "\u{21D3}"),
        "Leftrightarrow" : Atom(type: .relation, value: "\u{21D4}"),
        "Updownarrow" : Atom(type: .relation, value: "\u{21D5}"),
        "longleftarrow" : Atom(type: .relation, value: "\u{27F5}"),
        "longrightarrow" : Atom(type: .relation, value: "\u{27F6}"),
        "longleftrightarrow" : Atom(type: .relation, value: "\u{27F7}"),
        "Longleftarrow" : Atom(type: .relation, value: "\u{27F8}"),
        "Longrightarrow" : Atom(type: .relation, value: "\u{27F9}"),
        "Longleftrightarrow" : Atom(type: .relation, value: "\u{27FA}"),


        // Relations
        "leq" : Atom(type: .relation, value: UnicodeSymbol.lessEqual),
        "geq" : Atom(type: .relation, value: UnicodeSymbol.greaterEqual),
        "neq" : Atom(type: .relation, value: UnicodeSymbol.notEqual),
        "in" : Atom(type: .relation, value: "\u{2208}"),
        "notin" : Atom(type: .relation, value: "\u{2209}"),
        "ni" : Atom(type: .relation, value: "\u{220B}"),
        "propto" : Atom(type: .relation, value: "\u{221D}"),
        "mid" : Atom(type: .relation, value: "\u{2223}"),
        "parallel" : Atom(type: .relation, value: "\u{2225}"),
        "sim" : Atom(type: .relation, value: "\u{223C}"),
        "simeq" : Atom(type: .relation, value: "\u{2243}"),
        "cong" : Atom(type: .relation, value: "\u{2245}"),
        "approx" : Atom(type: .relation, value: "\u{2248}"),
        "asymp" : Atom(type: .relation, value: "\u{224D}"),
        "doteq" : Atom(type: .relation, value: "\u{2250}"),
        "equiv" : Atom(type: .relation, value: "\u{2261}"),
        "gg" : Atom(type: .relation, value: "\u{226A}"),
        "ll" : Atom(type: .relation, value: "\u{226B}"),
        "prec" : Atom(type: .relation, value: "\u{227A}"),
        "succ" : Atom(type: .relation, value: "\u{227B}"),
        "subset" : Atom(type: .relation, value: "\u{2282}"),
        "supset" : Atom(type: .relation, value: "\u{2283}"),
        "subseteq" : Atom(type: .relation, value: "\u{2286}"),
        "supseteq" : Atom(type: .relation, value: "\u{2287}"),
        "sqsubset" : Atom(type: .relation, value: "\u{228F}"),
        "sqsupset" : Atom(type: .relation, value: "\u{2290}"),
        "sqsubseteq" : Atom(type: .relation, value: "\u{2291}"),
        "sqsupseteq" : Atom(type: .relation, value: "\u{2292}"),
        "models" : Atom(type: .relation, value: "\u{22A7}"),
        "perp" : Atom(type: .relation, value: "\u{27C2}"),

        // operators
        "times" : AtomFactory.times(),
        "div"   : AtomFactory.divide(),
        "pm"    : Atom(type: .binaryOperator, value: "\u{00B1}"),
        "dagger" : Atom(type: .binaryOperator, value: "\u{2020}"),
        "ddagger" : Atom(type: .binaryOperator, value: "\u{2021}"),
        "mp"    : Atom(type: .binaryOperator, value: "\u{2213}"),
        "setminus" : Atom(type: .binaryOperator, value: "\u{2216}"),
        "ast"   : Atom(type: .binaryOperator, value: "\u{2217}"),
        "circ"  : Atom(type: .binaryOperator, value: "\u{2218}"),
        "bullet" : Atom(type: .binaryOperator, value: "\u{2219}"),
        "wedge" : Atom(type: .binaryOperator, value: "\u{2227}"),
        "vee" : Atom(type: .binaryOperator, value: "\u{2228}"),
        "cap" : Atom(type: .binaryOperator, value: "\u{2229}"),
        "cup" : Atom(type: .binaryOperator, value: "\u{222A}"),
        "wr" : Atom(type: .binaryOperator, value: "\u{2240}"),
        "uplus" : Atom(type: .binaryOperator, value: "\u{228E}"),
        "sqcap" : Atom(type: .binaryOperator, value: "\u{2293}"),
        "sqcup" : Atom(type: .binaryOperator, value: "\u{2294}"),
        "oplus" : Atom(type: .binaryOperator, value: "\u{2295}"),
        "ominus" : Atom(type: .binaryOperator, value: "\u{2296}"),
        "otimes" : Atom(type: .binaryOperator, value: "\u{2297}"),
        "oslash" : Atom(type: .binaryOperator, value: "\u{2298}"),
        "odot" : Atom(type: .binaryOperator, value: "\u{2299}"),
        "star"  : Atom(type: .binaryOperator, value: "\u{22C6}"),
        "cdot"  : Atom(type: .binaryOperator, value: "\u{22C5}"),
        "amalg" : Atom(type: .binaryOperator, value: "\u{2A3F}"),

        // No limit operators
        "log" : AtomFactory.getOperator(withName: "log", limits: false),
        "lg" : AtomFactory.getOperator(withName: "lg", limits: false),
        "ln" : AtomFactory.getOperator(withName: "ln", limits: false),
        "sin" : AtomFactory.getOperator(withName: "sin", limits: false),
        "arcsin" : AtomFactory.getOperator(withName: "arcsin", limits: false),
        "sinh" : AtomFactory.getOperator(withName: "sinh", limits: false),
        "cos" : AtomFactory.getOperator(withName: "cos", limits: false),
        "arccos" : AtomFactory.getOperator(withName: "arccos", limits: false),
        "cosh" : AtomFactory.getOperator(withName: "cosh", limits: false),
        "tan" : AtomFactory.getOperator(withName: "tan", limits: false),
        "arctan" : AtomFactory.getOperator(withName: "arctan", limits: false),
        "tanh" : AtomFactory.getOperator(withName: "tanh", limits: false),
        "cot" : AtomFactory.getOperator(withName: "cot", limits: false),
        "coth" : AtomFactory.getOperator(withName: "coth", limits: false),
        "sec" : AtomFactory.getOperator(withName: "sec", limits: false),
        "csc" : AtomFactory.getOperator(withName: "csc", limits: false),
        "arg" : AtomFactory.getOperator(withName: "arg", limits: false),
        "ker" : AtomFactory.getOperator(withName: "ker", limits: false),
        "dim" : AtomFactory.getOperator(withName: "dim", limits: false),
        "hom" : AtomFactory.getOperator(withName: "hom", limits: false),
        "exp" : AtomFactory.getOperator(withName: "exp", limits: false),
        "deg" : AtomFactory.getOperator(withName: "deg", limits: false),

        // Limit operators
        "lim" : AtomFactory.getOperator(withName: "lim", limits: true),
        "limsup" : AtomFactory.getOperator(withName: "lim sup", limits: true),
        "liminf" : AtomFactory.getOperator(withName: "lim inf", limits: true),
        "max" : AtomFactory.getOperator(withName: "max", limits: true),
        "min" : AtomFactory.getOperator(withName: "min", limits: true),
        "sup" : AtomFactory.getOperator(withName: "sup", limits: true),
        "inf" : AtomFactory.getOperator(withName: "inf", limits: true),
        "det" : AtomFactory.getOperator(withName: "det", limits: true),
        "Pr" : AtomFactory.getOperator(withName: "Pr", limits: true),
        "gcd" : AtomFactory.getOperator(withName: "gcd", limits: true),

        // Large operators
        "prod" : AtomFactory.getOperator(withName: "\u{220F}", limits: true),
        "coprod" : AtomFactory.getOperator(withName: "\u{2210}", limits: true),
        "sum" : AtomFactory.getOperator(withName: "\u{2211}", limits: true),
        "int" : AtomFactory.getOperator(withName: "\u{222B}", limits: false),
        "oint" : AtomFactory.getOperator(withName: "\u{222E}", limits: false),
        "bigwedge" : AtomFactory.getOperator(withName: "\u{22C0}", limits: true),
        "bigvee" : AtomFactory.getOperator(withName: "\u{22C1}", limits: true),
        "bigcap" : AtomFactory.getOperator(withName: "\u{22C2}", limits: true),
        "bigcup" : AtomFactory.getOperator(withName: "\u{22C3}", limits: true),
        "bigodot" : AtomFactory.getOperator(withName: "\u{2A00}", limits: true),
        "bigoplus" : AtomFactory.getOperator(withName: "\u{2A01}", limits: true),
        "bigotimes" : AtomFactory.getOperator(withName: "\u{2A02}", limits: true),
        "biguplus" : AtomFactory.getOperator(withName: "\u{2A04}", limits: true),
        "bigsqcup" : AtomFactory.getOperator(withName: "\u{2A06}", limits: true),

        // Latex command characters
        "{" : Atom(type: .open, value: "{"),
        "}" : Atom(type: .close, value: "}"),
        "$" : Atom(type: .ordinary, value: "{"),
        "&" : Atom(type: .ordinary, value: "&"),
        "#" : Atom(type: .ordinary, value: "#"),
        "%" : Atom(type: .ordinary, value: "%"),
        "_" : Atom(type: .ordinary, value: "_"),
        " " : Atom(type: .ordinary, value: " "),
        "backslash" : Atom(type: .ordinary, value: "\\\\"),

        // Punctuation
        // Note: \colon is different from : which is a relation
        "colon" : Atom(type: .punctuation, value: ":"),
        "cdotp" : Atom(type: .punctuation, value: "\u{00B7}"),

        // Other symbols
        "degree" : Atom(type: .ordinary, value: "\u{00B0}"),
        "neg" : Atom(type: .ordinary, value: "\u{00AC}"),
        "angstrom" : Atom(type: .ordinary, value: "\u{00C5}"),
        "|" : Atom(type: .ordinary, value: "\u{2016}"),
        "vert" : Atom(type: .ordinary, value: "|"),
        "ldots" : Atom(type: .ordinary, value: "\u{2026}"),
        "prime" : Atom(type: .ordinary, value: "\u{2032}"),
        "hbar" : Atom(type: .ordinary, value: "\u{210F}"),
        "Im" : Atom(type: .ordinary, value: "\u{2111}"),
        "ell" : Atom(type: .ordinary, value: "\u{2113}"),
        "wp" : Atom(type: .ordinary, value: "\u{2118}"),
        "Re" : Atom(type: .ordinary, value: "\u{211C}"),
        "mho" : Atom(type: .ordinary, value: "\u{2127}"),
        "aleph" : Atom(type: .ordinary, value: "\u{2135}"),
        "forall" : Atom(type: .ordinary, value: "\u{2200}"),
        "exists" : Atom(type: .ordinary, value: "\u{2203}"),
        "emptyset" : Atom(type: .ordinary, value: "\u{2205}"),
        "nabla" : Atom(type: .ordinary, value: "\u{2207}"),
        "infty" : Atom(type: .ordinary, value: "\u{221E}"),
        "angle" : Atom(type: .ordinary, value: "\u{2220}"),
        "top" : Atom(type: .ordinary, value: "\u{22A4}"),
        "bot" : Atom(type: .ordinary, value: "\u{22A5}"),
        "vdots" : Atom(type: .ordinary, value: "\u{22EE}"),
        "cdots" : Atom(type: .ordinary, value: "\u{22EF}"),
        "ddots" : Atom(type: .ordinary, value: "\u{22F1}"),
        "triangle" : Atom(type: .ordinary, value: "\u{25B3}"),
        "imath" : Atom(type: .ordinary, value: "\u{0001D6A4}"),
        "jmath" : Atom(type: .ordinary, value: "\u{0001D6A5}"),
        "partial" : Atom(type: .ordinary, value: "\u{0001D715}"),

        // Spacing
        "," : AtomSpace(space: 3),
        ">" : AtomSpace(space: 4),
        ";" : AtomSpace(space: 5),
        "!" : AtomSpace(space: -3),
        "quad" : AtomSpace(space: 18),  // quad = 1em = 18mu
        "qquad" : AtomSpace(space: 36), // qquad = 2em

        // Style
        "displaystyle" : AtomStyle(style: .display),
        "textstyle" : AtomStyle(style: .text),
        "scriptstyle" : AtomStyle(style: .script),
        "scriptscriptstyle" : AtomStyle(style: .scriptOfScript),
    ]
    
    var latexSymbolNames = [String]()
    
    var _textToLatexSymbolName: [String: String]? = nil
    var textToLatexSymbolName: [String: String] {
        get {
            if self._textToLatexSymbolName == nil {
                var output = [String: String]()
                
                for (key, atom) in self.supportedLatexSymbols {
                    if atom.nucleus.characters.count == 0 {
                        continue
                    }
                    
                    if let existingText = output[atom.nucleus] {
                        // If there are 2 key for the same symbol, choose one deterministically.
                        if key.characters.count > existingText.characters.count {
                            // Keep the shorter command
                            continue
                        } else if key.characters.count == existingText.characters.count {
                            // If the length is the same, keep the alphabetically first
                            if key.compare(existingText) == .orderedDescending {
                                continue
                            }
                        }
                    }
                    
                    output[atom.nucleus] = key
                }
                
                self._textToLatexSymbolName = output
            }
            
            return self._textToLatexSymbolName!
        }
        set {
            self._textToLatexSymbolName = newValue
        }
    }
    
    static let sharedInstance = AtomFactory()
    
    private init() { }
    
    // Return an atom for times sign \times or *
    static func times() -> Atom {
        return Atom(type: .binaryOperator, value: UnicodeSymbol.multiplication)
    }
    
    // Return an atom for division sign \div or /
    static func divide() -> Atom {
        return Atom(type: .binaryOperator, value: UnicodeSymbol.division)
    }
    
    // Return an atom aka placeholder square
    static func placeholder() -> Atom {
        return Atom(type: .placeholder, value: UnicodeSymbol.whiteSquare)
    }
    
    static func placeholderFraction() -> AtomFraction {
        let frac = AtomFraction()
        
        frac.numerator = AtomList()
        frac.numerator?.add(placeholder())
        frac.denominator = AtomList()
        frac.denominator?.add(placeholder())
        
        return frac
    }
    
    static func placeholderSquareRoot() -> AtomRadical {
        let rad = AtomRadical()
        
        rad.radicand = AtomList()
        rad.radicand?.add(placeholder())
        
        return rad
    }
    
    static func placeholderRadical() -> AtomRadical {
        let rad = AtomRadical()
        
        rad.radicand = AtomList()
        rad.degree = AtomList()
        
        rad.radicand?.add(placeholder())
        rad.degree?.add(placeholder())
        
        return rad
    }
    
    /** Gets the atom with the right type for the given character. If an atom
     cannot be determined for a given character this returns nil.
     This function follows latex conventions for assigning types to the atoms.
     The following characters are not supported and will return nil:
     - Any non-ascii character.
     - Any control character or spaces (< 0x21)
     - Latex control chars: $ % # & ~ '
     - Chars with special meaning in latex: ^ _ { } \
     All other characters will have a non-nil atom returned.
     */
    static func atom(for char: String) -> Atom? {
        let atomCharacterSet = CharacterSet(charactersIn: UnicodeScalar(0x75)!...UnicodeScalar(0x21)!)
        if char.rangeOfCharacter(from: atomCharacterSet) != nil {
            switch char {
            case "$", "%", "#", "&", "~", "\'", "^", "_", "{", "}", "\\\\":
                return nil
            case "(", "[":
                return Atom(type: .open, value: char)
            case ")", "]", "!", "?":
                return Atom(type: .close, value: char)
            case ",", ";":
                return Atom(type: .punctuation, value: char)
            case "=", ">", "<":
                return Atom(type: .relation, value: char)
            case ":":
                // Math colon is ratio. Regular colon is \colon
                return Atom(type: .relation, value: "\u{2236}")
            case "-":
                return Atom(type: .binaryOperator, value: "\u{2212}")
            case "+", "*":
                return Atom(type: .binaryOperator, value: char)
            case ".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                return Atom(type: .number, value: char)
            case _ where
                    (char.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil) ||
                    (char.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil) :
                return Atom(type: .variable, value: char)
            case "\"", "/", "@", "`", "|":
                return Atom(type: .ordinary, value: char)
            default:
                print("Unknown characters: \(char)")
                return nil
            }
        }
        return nil
    }
    
    /** Returns a `MTMathList` with one atom per character in the given string. This function
     does not do any LaTeX conversion or interpretation. It simply uses `atomForCharacter` to
     convert the characters to atoms. Any character that cannot be converted is ignored. */
    static func atomList(for string: String) -> AtomList {
        let list = AtomList()
        
        for character in string.characters {
            if let newAtom = atom(for: "\(character)") {
                list.add(newAtom)
            }
        }
        
        return list
    }
    
    /** Returns an atom with the right type for a given latex symbol (e.g. theta)
     If the latex symbol is unknown this will return nil. This supports LaTeX aliases as well.
     */
    static func atom(forLatexSymbol name: String) -> Atom? {
        var _name = name
        
        if let canonicalName = AtomFactory.aliases[name] {
            _name = canonicalName
        }
        
        if let atom = AtomFactory.sharedInstance.supportedLatexSymbols[_name] {
            return atom
        }
        
        return nil
    }
    
    /** Finds the name of the LaTeX symbol name for the given atom. This function is a reverse
     of the above function. If no latex symbol name corresponds to the atom, then this returns `nil`
     If nucleus of the atom is empty, then this will return `nil`.
     @note: This is not an exact reverse of the above in the case of aliases. If an LaTeX alias
     points to a given symbol, then this function will return the original symbol name and not the
     alias.
     @note: This function does not convert MathSpaces to latex command names either.
     */
    static func latexSymbolName(for atom: Atom) -> String? {
        if atom.nucleus.characters.count == 0 {
            return nil
        }
        
        return AtomFactory.sharedInstance.textToLatexSymbolName[atom.nucleus]
    }
    
    /** Define a latex symbol for rendering. This function allows defining custom symbols that are
     not already present in the default set, or override existing symbols with new meaning.
     e.g. to define a symbol for "lcm" one can call:
     `[MTMathAtomFactory addLatexSymbol:@"lcm" value:[MTMathAtomFactory operatorWithName:@"lcm" limits: false)]` */
    
    static func define(latexSymbol name: String, value: Atom) {
        AtomFactory.sharedInstance.supportedLatexSymbols[name] = value
        AtomFactory.sharedInstance.textToLatexSymbolName[value.nucleus] = name
    }
    
    /** Returns a large opertor for the given name. If limits is true, limits are set up on
     the operator and displyed differently. */
    static func getOperator(withName name: String, limits: Bool) -> AtomLargeOperator {
        return AtomLargeOperator(value: name, limits: limits)
    }
    
    /** Returns an accent with the given name. The name of the accent is the LaTeX name
     such as `grave`, `hat` etc. If the name is not a recognized accent name, this
     returns nil. The `innerList` of the returned `MTAccent` is nil.
     */
    static func getAccent(withName name: String) -> AtomAccent? {
        if let accentValue = AtomFactory.accents[name] {
            return AtomAccent(value: accentValue)
        }
        return nil
    }
    
    /** Returns the accent name for the given accent. This is the reverse of the above
     function. */
    static func getName(of accent: AtomAccent) -> String? {
        return AtomFactory.sharedInstance.accentValueToName[accent.nucleus]
    }
    
    /** Creates a new boundary atom for the given delimiter name. If the delimiter name
     is not recognized it returns nil. A delimiter name can be a single character such
     as '(' or a latex command such as 'uparrow'.
     @note In order to distinguish between the delimiter '|' and the delimiter '\|' the delimiter '\|'
     the has been renamed to '||'.
     */
    static func boundary(forDelimiter name: String) -> Atom? {
        if let delimValue = AtomFactory.delimiters[name] {
            return Atom(type: .boundary, value: delimValue)
        }
        return nil
    }
    
    /** Returns the delimiter name for a boundary atom. This is a reverse of the above function.
     If the atom is not a boundary atom or if the delimiter value is unknown this returns `nil`.
     @note This is not an exact reverse of the above function. Some delimiters have two names (e.g.
     `<` and `langle`) and this function always returns the shorter name.
     */
    static func getDelimiterName(of boundary: Atom) -> String? {
        if boundary.type != .boundary {
            return nil
        }
        return AtomFactory.sharedInstance.delimValueToName[boundary.nucleus]
    }
    
    /** Returns a fraction with the given numerator and denominator. */
    static func fraction(withNumerator num: AtomList, denominator denom: AtomList) -> AtomFraction {
        let frac = AtomFraction()
        
        frac.numerator = num
        frac.denominator = denom
        
        return frac
    }
    
    /** Simplification of above function when numerator and denominator are simple strings.
     This function uses `mathListForCharacters` to convert the strings to `MTMathList`s. */
    static func fraction(withNumeratorString numStr: String, denominatorString denomStr: String) -> AtomFraction {
        let num = AtomFactory.atomList(for: numStr)
        let denom = AtomFactory.atomList(for: denomStr)
        
        return AtomFactory.fraction(withNumerator: num, denominator: denom)
    }
    
    /** Builds a table for a given environment with the given rows. Returns a `MTMathAtom` containing the
     table and any other atoms necessary for the given environment. Returns nil and sets error
     if the table could not be built.
     @param env The environment to use to build the table. If the env is nil, then the default table is built.
     @note The reason this function returns a `MTMathAtom` and not a `MTMathTable` is because some
     matrix environments are have builtin delimiters added to the table and hence are returned as inner atoms.
     */
    static func table(withEnvironment env: String?, rows: [[AtomList]]) -> Atom? {
        let table = AtomTable(environment: env)
        
        for i in 0..<rows.count {
            let row = rows[i]
            for j in 0..<row.count {
                table.set(cell: row[j], at: IndexPath(row: i, section: j))
            }
        }
        
        let matrixEnvs = [
            "matrix": [],
            "pmatrix": ["(", ")"],
            "bmatrix": ["[", "]"],
            "Bmatrix": ["{", "}"],
            "vmatrix": ["vert", "vert"],
            "Vmatrix": ["Vert", "Vert"]
        ]
        
        if env == nil {
            table.interColumnSpacing = 0
            table.interRowAdditionalSpacing = 1
            for i in 0..<table.numberOfCols() {
                table.set(alignment: .left, forCol: i)
            }
            return table
        } else {
            if let delims = matrixEnvs[env!] {
                table.environment = "matrix"
                table.interRowAdditionalSpacing = 0
                table.interColumnSpacing = 18
                
                let style = AtomStyle(style: .text)
                
                for i in 0..<table.cells.count {
                    for j in 0..<table.cells[i].count {
                        table.cells[i][j].insert(style, at: 0)
                    }
                }
                
                if delims.count == 2 {
                    let inner = AtomInner()
                    inner.leftBoundary = AtomFactory.boundary(forDelimiter: delims[0])
                    inner.rightBoundary = AtomFactory.boundary(forDelimiter: delims[1])
                    inner.innerList = AtomList(atoms: [table])
                    return inner
                } else {
                    return table
                }
            } else if env == "eqalign" || env == "split" || env == "aligned" {
                if table.numberOfCols() != 2 {
                    print("\(env) environment can only have 2 columns")
                    return nil
                }
                
                let spacer = Atom(type: .ordinary, value: "")
                
                for i in 0..<table.cells.count {
                    if table.cells[i].count >= 1 {
                        table.cells[i][1].insert(spacer, at: 0)
                    }
                }
                
                table.interRowAdditionalSpacing = 1
                table.interColumnSpacing = 0
                
                table.set(alignment: .right, forCol: 0)
                table.set(alignment: .left, forCol: 1)
                
                return table
            } else if env == "displaylines" || env == "gather" {
                if table.numberOfCols() != 1 {
                    print("\(env) environment can only have 1 columns")
                    return nil
                }
                
                table.interRowAdditionalSpacing = 1
                table.interColumnSpacing = 0
                
                table.set(alignment: .center, forCol: 0)
                
                return table
            } else if env == "eqnarray" {
                if table.numberOfCols() != 3 {
                    print("\(env) environment can only have 3 columns")
                    return nil
                }
                
                table.interRowAdditionalSpacing = 1
                table.interColumnSpacing = 18
                
                table.set(alignment: .right, forCol: 0)
                table.set(alignment: .center, forCol: 1)
                table.set(alignment: .left, forCol: 2)
                
                return table
            } else if env == "cases" {
                if table.numberOfCols() != 2 {
                    print("\(env) environment can only have 2 columns")
                    return nil
                }
                
                table.interRowAdditionalSpacing = 0
                table.interColumnSpacing = 18
                
                table.set(alignment: .left, forCol: 0)
                table.set(alignment: .left, forCol: 1)
                
                let style = AtomStyle(style: .text)
                
                
                for i in 0..<table.cells.count {
                    for j in 0..<table.cells[i].count {
                        table.cells[i][j].insert(style, at: 0)
                    }
                }
                
                let inner = AtomInner()
                inner.leftBoundary = AtomFactory.boundary(forDelimiter: "{")
                inner.rightBoundary = AtomFactory.boundary(forDelimiter: ".")
                let space = AtomFactory.atom(forLatexSymbol: ",")!
                
                inner.innerList = AtomList(atoms: [space, table])
                
                return inner
            } else {
                print("Unknown table environment")
                return nil
            }
        }
    }
}
