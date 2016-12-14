//
//  SudokuBoard.swift
//  Dev
//
//  Created by YU HONG on 2016-12-01.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation

class SudokuBoard {
    /**
    * Sudoku board size.
    */
    static let BOARD_SIZE: Int = 9;
    /**
    * Sudoku board sub-square size.
    */
    static let BOARD_SUB_SQURE_SIZE: Int = 3;
    /**
    * Number of 9x3 column segments or 3x9 row segments.
    */
    static let BOARD_SEGMENTS_NUMBER: Int = 3;
    /**
    * We will use array indexes from 1.,.n, instead 0...n-1
    */
    static let BOARD_MAX_INDEX: Int = BOARD_SIZE + 1;
    /**
    * Number of cells on the Sudoku board.
    */
    static let BOARD_CELLS_NUMBER: Int = BOARD_SIZE * BOARD_SIZE;
    /**
    * Sudoku board was successfully loaded.
    */
    static let BOARD_STATE_EMPTY: Int = 1;
    /**
    * Sudoku board was successfully loaded.
    */
    static let BOARD_STATE_LOADED: Int = 2;
    /**
    * Sudoku board is ready to start solving process.
    */
    static let BOARD_STATE_READY: Int = 3;
    /**
    * Sudoku board is ready to start solving process.
    */
    static let BOARD_STATE_ERROR: Int = SudokuErrorCodes.SUDOKUSOLVER_BOARD_ERROR;
    /**
    * Path number gives the information on how many routes
    * were verified until solutions was found.
    */
    var pathNumber: Int!
    /**
    * Sudoku board array.
    */
    var board: [[Int]]!
    /**
    * Default constructor.
    */
    init() {
        board = [[Int]]()
        for i in 0..<SudokuBoard.BOARD_SIZE {
            board.append([Int]())
            for _ in 0..<SudokuBoard.BOARD_SIZE {
                board[i].append(SudokuBoardCell.EMPTY)
            }
        }
        pathNumber = -1;
    }
}