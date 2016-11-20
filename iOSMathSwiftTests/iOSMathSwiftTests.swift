//
//  iOSMathSwiftTests.swift
//  iOSMathSwiftTests
//
//  Created by Anh Phan Tran on 11/20/16.
//  Copyright © 2016 Anh Phan Tran. All rights reserved.
//

import XCTest
import iOSMathSwift

class iOSMathSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSubscript() {
        let string = "-52x^{13+y}_{15-} + (-12.3* )\\frac{-12}{15.2}"
        let list = AtomListBuilder.build(fromString: string)
        
        let finalized = list!.finalized
        
        self.testCheckListContents(finalized: finalized)
        
        self.testCheckListContents(finalized: finalized.finalized)
    }
    
    func testCheckListContents(finalized: AtomList) {
        // check
        XCTAssertEqual((finalized.atoms.count), 10, "Num atoms");
        
        var atom = finalized.atoms[0];
        
        
        XCTAssert(atom.type == AtomType.unaryOperator, "Atom 0");
        XCTAssertEqual(atom.nucleus, "−", "Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 1)), "Range");
        atom = finalized.atoms[1];
        XCTAssertEqual(atom.type, AtomType.number, "Atom 1");
        XCTAssertEqual(atom.nucleus, "52", "Atom 1 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(1, 2)), "Range");
        atom = finalized.atoms[2];
        XCTAssertEqual(atom.type, AtomType.variable, "Atom 2");
        XCTAssertEqual(atom.nucleus, "x", "Atom 2 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(3, 1)), "Range");
        
        var superScr = atom.superScript!;
        XCTAssertEqual((superScr.atoms.count), 3, "Super script");
        atom = superScr.atoms[0];
        XCTAssertEqual(atom.type, AtomType.number, "Super Atom 0");
        XCTAssertEqual(atom.nucleus, "13", "Super Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 2)), "Range");
        atom = superScr.atoms[1];
        XCTAssertEqual(atom.type, AtomType.binaryOperator, "Super Atom 1");
        XCTAssertEqual(atom.nucleus, "+", "Super Atom 1 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(2, 1)), "Range");
        atom = superScr.atoms[2];
        XCTAssertEqual(atom.type, AtomType.variable, "Super Atom 2");
        XCTAssertEqual(atom.nucleus, "y", "Super Atom 2 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(3, 1)), "Range");
        
        atom = finalized.atoms[2];
        var subScr = atom.subScript!;
        XCTAssertEqual((subScr.atoms.count), 2, "Sub script");
        atom = subScr.atoms[0];
        XCTAssertEqual(atom.type, AtomType.number, "Sub Atom 0");
        XCTAssertEqual(atom.nucleus, "15", "Sub Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 2)), "Range");
        atom = subScr.atoms[1];
        XCTAssertEqual(atom.type, AtomType.unaryOperator, "Sub Atom 1");
        XCTAssertEqual(atom.nucleus, "−", "Sub Atom 1 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(2, 1)), "Range");
        
        atom = finalized.atoms[3];
        XCTAssertEqual(atom.type, AtomType.binaryOperator, "Atom 3");
        XCTAssertEqual(atom.nucleus, "+", "Atom 3 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(4, 1)), "Range");
        atom = finalized.atoms[4];
        XCTAssertEqual(atom.type, AtomType.open, "Atom 4");
        XCTAssertEqual(atom.nucleus, "(", "Atom 4 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(5, 1)), "Range");
        atom = finalized.atoms[5];
        XCTAssertEqual(atom.type, AtomType.unaryOperator, "Atom 5");
        XCTAssertEqual(atom.nucleus, "−", "Atom 5 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(6, 1)), "Range");
        atom = finalized.atoms[6];
        XCTAssertEqual(atom.type, AtomType.number, "Atom 6");
        XCTAssertEqual(atom.nucleus, "12.3", "Atom 6 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(7, 4)), "Range");
        atom = finalized.atoms[7];
        XCTAssertEqual(atom.type, AtomType.unaryOperator, "Atom 7");
        XCTAssertEqual(atom.nucleus, "*", "Atom 7 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(11, 1)), "Range");
        atom = finalized.atoms[8];
        XCTAssertEqual(atom.type, AtomType.close, "Atom 8");
        XCTAssertEqual(atom.nucleus, ")", "Atom 8 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(12, 1)), "Range");
        
        var frac = finalized.atoms[9] as! AtomFraction;
        XCTAssertEqual(frac.type, AtomType.fraction, "Atom 9");
        XCTAssertEqual(frac.nucleus, "", "Atom 9 value");
        XCTAssertTrue(NSEqualRanges(frac.indexRange, NSMakeRange(13, 1)), "Range");
        
        var numer = frac.numerator!;
        XCTAssertNotNil(numer, "Numerator");
        XCTAssertEqual((numer.atoms.count), 2, "Numer script");
        atom = numer.atoms[0];
        XCTAssertEqual(atom.type, AtomType.unaryOperator, "Numer Atom 0");
        XCTAssertEqual(atom.nucleus, "−", "Numer Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 1)), "Range");
        atom = numer.atoms[1];
        XCTAssertEqual(atom.type, AtomType.number, "Numer Atom 1");
        XCTAssertEqual(atom.nucleus, "12", "Numer Atom 1 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(1, 2)), "Range");
        
        
        var denom = frac.denominator!;
        XCTAssertNotNil(denom, "Denominator");
        XCTAssertEqual((denom.atoms.count), 1, "Denom script");
        atom = denom.atoms[0];
        XCTAssertEqual(atom.type, AtomType.number, "Denom Atom 0");
        XCTAssertEqual(atom.nucleus, "15.2", "Denom Atom 0 value");
        XCTAssertTrue(NSEqualRanges(atom.indexRange, NSMakeRange(0, 4)), "Range");
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
