//
//  SudokuBoardCell.swift
//  Dev
//
//  Created by YU HONG on 2016-11-30.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation

class SudokuBoardCell {
    
    /**
    * Empty cell.
    */
    //public static final int EMPTY = EmptyCell.CELL_ID;
    static let EMPTY: Int = EmptyCell.CELL_ID
    /**
    * Cell is not pointing to any cells on the board.
    */
    //public static final int INDEX_NULL = -1;
    static let INDEX_NULL: Int = -1
    /**
    * Row index of board entry.
    */
    //public int rowIndex;
    var rowIndex: Int = 0
    /**
    * Column index of board entry.
    */
    //public int colIndex;
    var colIndex: Int = 0
    /**
    * Entry digit.
    */
    //public int digit;
    var digit: Int = 0
    /**
    * Random seed.
    */
    //double randomSeed;
    var randomSeed: Double = 0
    /**
    * Digits still free number.
    */
    //int digitsStillFreeNumber;
    var digitsStillFreeNumber: Int = 0
    /**
    * Default constructor - uninitialized entry.
    */
    /**
    * Marker if analyzed digit 0...9 is still not used.
    */
    //static final int DIGIT_STILL_FREE = 1;
    static let DIGIT_STILL_FREE: Int = 1
    /**
    * Digit 0...9 can not be used in that place.
    */
    //static final int DIGIT_IN_USE = 2;
    static let DIGIT_IN_USE: Int = 2
    /**
    * Cell is not pointing to any cells on the board.
    */
    init() {
        rowIndex = SudokuBoardCell.INDEX_NULL;
        colIndex = SudokuBoardCell.INDEX_NULL;
        digit = SudokuBoardCell.EMPTY;
        //randomSeed = Math.random();
        //randomSeed = UInt32(NSDate().timeIntervalSinceReferenceDate)
        //srand(randomSeed)
        randomSeed = Double(arc4random()) / Double(UINT32_MAX)
        digitsStillFreeNumber = -1
    }
    /**
    * Constructor - initialized entry.
    * @param rowIndex   Row index.
    * @param colIndex   Column index.
    * @param digit    Entry digit.
    */
    
    init(rowIndex: Int, colIndex: Int, digit: Int) {
        self.rowIndex = rowIndex
        self.colIndex = colIndex
        self.digit = digit
        randomSeed = SudokuStore.getRandomNumber()
        digitsStillFreeNumber = -1
    }
    
    func set(rowIndex: Int, colIndex: Int, digit: Int) {
        self.rowIndex = rowIndex
        self.colIndex = colIndex
        self.digit = digit
        randomSeed = SudokuStore.getRandomNumber()
        digitsStillFreeNumber = -1
    }

    
    /**
    * Package level method
    * @return
    */
    
    func order() -> Int {
        return digitsStillFreeNumber
    }
    /**
    * Package level method
    * @return
    */
    
    func orderPlusRndSeed() -> Double {
        return Double(digitsStillFreeNumber) + randomSeed
    }
    
}
