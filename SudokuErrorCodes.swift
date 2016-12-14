//
//  SudokuErrorCodes.swift
//  Dev
//
//  Created by YU HONG on 2016-12-01.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation

class SudokuErrorCodes {
    /**
    * Sudoku board loading failed.
    *
    * @see SudokuSolver
    * @see SudokuSolver#loadBoard(int)
    * #see SudokuSolver#loadBoard(int[][])
    * @see SudokuSolver#loadBoard(String)
    */
    static let SUDOKUSOLVER_LOADBOARD_LOADING_FAILED: Int = -100;
    /**
    * Sudoku solving requested, but not started.
    *
    * @see SudokuSolver
    * @see SudokuSolver#solve()
    */
    static let SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED: Int = -101;
    /**
    * Sudoku solving requested, but falied.
    *
    * @see SudokuSolver
    * @see SudokuSolver#solve()
    */
    static let SUDOKUSOLVER_SOLVE_SOLVING_FAILED: Int = -102;
    /**
    * Finding all Sudoku solutions requested, but not started.
    *
    * @see SudokuSolver
    * @see SudokuSolver#findAllSolutions()
    */
    static let SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED: Int = -103;
    /**
    * Finding all Sudoku solutions requested, but not started.
    *
    * @see SudokuSolver
    * @see SudokuSolver#findAllSolutions()
    */
    static let SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED: Int = -104;
    /**
    * Incorrect cell definition while calling setCell method (incorrect index or incorrect digit).
    * @see SudokuSolver
    * @see SudokuSolver#setCell(int, int, int)
    */
    static let SUDOKUSOLVER_SETCELL_INCORRECT_DEFINITION: Int = -105;
    /**
    * Incorrect cell definition while calling getCell method (incorrect index).
    * @see SudokuSolver
    * @see SudokuSolver#getCellDigit(int, int)
    */
    static let SUDOKUSOLVER_GETCELLDIGIT_INCORRECT_INDEX: Int = -106;
    /**
    * Incorrect segment index while calling {@link SudokuStore#boardSegmentStartIndex(int)}
    *
    * @see SudokuStore
    * @see SudokuStore#boardSegmentStartIndex(int)
    */
    static let SUDOKUSTORE_BOARDSEGMENTSTARTINDEX_INCORRECT_SEGMENT: Int = -107;
    /**
    * Negative or zero parameter while calling {@link SudokuStore#randomIndex(int)}
    *
    * @see SudokuStore
    * @see SudokuStore#randomIndex(int)
    */
    static let SUDOKUSTORE_RANDOMINDEX_INCORRECT_PARAMETER: Int = -108;
    /**
    * Negative or zero parameter while calling {@link SudokuStore#randomNumber(int)}
    *
    * @see SudokuStore
    * @see SudokuStore#randomNumber(int)
    */
    static let SUDOKUSTORE_RANDOMNUMBER_INCORRECT_PARAMETER: Int = -109;
    /**
    * Board contains an error.
    * @see SudokuSolver
    */
    static let SUDOKUSOLVER_BOARD_ERROR: Int = -110;
    /**
    * Obvious puzzle error.
    *
    * @see SudokuStore
    * @see SudokuStore#calculatePuzzleRating(int[][])
    */
    static let SUDOKUSTORE_CALCULATEPUZZLERATING_PUZZLE_ERROR: Int = -111;
    /**
    * Puzzle solution does not exist.
    *
    * @see SudokuStore
    * @see SudokuStore#calculatePuzzleRating(int[][])
    */
    static let SUDOKUSTORE_CALCULATEPUZZLERATING_NO_SOLUTION: Int = -112;
    /**
    * Puzzle has non-unique solution.
    *
    * @see SudokuStore
    * @see SudokuStore#calculatePuzzleRating(int[][])
    */
    static let SUDOKUSTORE_CALCULATEPUZZLERATING_NON_UNIQUE_SOLUTION: Int = -113;
    /**
    * Threads join failed.
    *
    * @see SudokuStore
    * @see SudokuStore#calculatePuzzleRating(int[][])
    */
    static let SUDOKUSTORE_CALCULATEPUZZLERATING_THREADS_JOIN_FAILED: Int = -114;
    /**
    * Sudoku board loading failed.
    *
    * @see SudokuSolver
    * @see SudokuSolver#loadBoard(int)
    * @see SudokuSolver#loadBoard(int[][])
    * @see SudokuSolver#loadBoard(String)
    */
    static let SUDOKUSOLVER_LOADBOARD_LOADING_FAILED_MSG: String =  "Failed loading sudoku board.";
    /**
    * Sudoku solving requested, but not started.
    *
    * @see SudokuSolver
    * @see SudokuSolver#solve()
    */
    static let SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED_MSG: String = "Sudoku solving process not started - board is not ready.";
    /**
    * Sudoku solving requested, but falied.
    *
    * @see SudokuSolver
    * @see SudokuSolver#solve()
    */
    static let SUDOKUSOLVER_SOLVE_SOLVING_FAILED_MSG: String = "Sudoku solving process started, but failed - board contains an error?";
    /**
    * Finding all Sudoku solutions requested, but not started.
    *
    * @see SudokuSolver
    * @see SudokuSolver#findAllSolutions()
    */
    static let SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED_MSG: String = "Searching for all solutions not started = board is not ready.";
    /**
    * Finding all Sudoku solutions requested, but not started.
    *
    * @see SudokuSolver
    * @see SudokuSolver#findAllSolutions()
    */
    static let SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED_MSG: String = "Checking if only unique solution exists not started - board is not ready.";
    /**
    * Incorrect cell definition while calling setCell method (incorrect index or incorrect digit).
    * @see SudokuSolver
    * @see SudokuSolver#setCell(int, int, int)
    */
    static let SUDOKUSOLVER_SETCELL_INCORRECT_DEFINITION_MSG: String = "Trying to access the cell, but definition contains an error.";
    /**
    * Incorrect cell definition while calling getCell method (incorrect index).
    * @see SudokuSolver
    * @see SudokuSolver#getCellDigit(int, int)
    */
    static let SUDOKUSOLVER_GETCELLDIGIT_INCORRECT_INDEX_MSG: String = "Trying to access the cell, but index out of board range.";
    /**
    * Incorrect segment index while calling {@link SudokuStore#boardSegmentStartIndex(int)}
    *
    * @see SudokuStore
    * @see SudokuStore#boardSegmentStartIndex(int)
    */
    static let SUDOKUSTORE_BOARDSEGMENTSTARTINDEX_INCORRECT_SEGMENT_MSG: String = "Incorrect board segment index - should be betweem 0 and 2.";
    /**
    * Negative or zero parameter while calling {@link SudokuStore#randomIndex(int)}
    *
    * @see SudokuStore
    * @see SudokuStore#randomIndex(int)
    */
    static let SUDOKUSTORE_RANDOMINDEX_INCORRECT_PARAMETER_MSG: String = "Parameter can not be negative.";
    /**
    * Negative or zero parameter while calling {@link SudokuStore#randomNumber(int)}
    *
    * @see SudokuStore
    * @see SudokuStore#randomNumber(int)
    */
    static let SUDOKUSTORE_RANDOMNUMBER_INCORRECT_PARAMETER_MSG: String = "Parameter has to be positive.";
    /**
    * Board contains an error.
    * @see SudokuSolver
    */
    static let SUDOKUSOLVER_BOARD_ERROR_MSG: String = "Sudoku board contains an error.";
    /**
    * Puzzle contains obvious puzzle error.
    *
    * @see SudokuStore
    * @see SudokuStore#calculatePuzzleRating(int[][])
    */
    static let SUDOKUSTORE_CALCULATEPUZZLERATING_PUZZLE_ERROR_MSG: String = "Puzzle contains obvious puzzle error.";
    /**
    * Puzzle solution does not exist.
    *
    * @see SudokuStore
    * @see SudokuStore#calculatePuzzleRating(int[][])
    */
    static let SUDOKUSTORE_CALCULATEPUZZLERATING_NO_SOLUTION_MSG: String = "Puzzle solution does not exist.";
    /**
    * Puzzle has non-unique solution.
    *
    * @see SudokuStore
    * @see SudokuStore#calculatePuzzleRating(int[][])
    */
    static let SUDOKUSTORE_CALCULATEPUZZLERATING_NON_UNIQUE_SOLUTION_MSG: String = "Puzzle has non-unique solution.";
    /**
    * Threads join failed.
    *
    * @see SudokuStore
    * @see SudokuStore#calculatePuzzleRating(int[][])
    */
    static let SUDOKUSTORE_CALCULATEPUZZLERATING_THREADS_JOIN_FAILED_MSG: String = "Threads join failed.";
    
    
    /**
    * Error code unknown
    * @see #getErrorDescription(int)
    */
    static let ERROR_CODE_UNKNOWN_MSG: String = "Incorrect error code.";
    /**
    * Return error code description.
    *
    * @param errorCode      Error code
    * @return               Error code description if error code known,
    *                       otherwise {@link #ERROR_CODE_UNKNOWN_MSG}.
    */
    static func getErrorDescription(errorCode: Int) -> String {
    switch errorCode {
    case SUDOKUSOLVER_LOADBOARD_LOADING_FAILED: return SUDOKUSOLVER_LOADBOARD_LOADING_FAILED_MSG;
    case SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED:return SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED_MSG;
    case SUDOKUSOLVER_SOLVE_SOLVING_FAILED: return SUDOKUSOLVER_SOLVE_SOLVING_FAILED_MSG;
    case SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED: return SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED_MSG;
    case SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED: return SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED_MSG;
    case SUDOKUSOLVER_SETCELL_INCORRECT_DEFINITION: return SUDOKUSOLVER_SETCELL_INCORRECT_DEFINITION_MSG;
    case SUDOKUSOLVER_GETCELLDIGIT_INCORRECT_INDEX: return SUDOKUSOLVER_GETCELLDIGIT_INCORRECT_INDEX_MSG;
    case SUDOKUSTORE_BOARDSEGMENTSTARTINDEX_INCORRECT_SEGMENT: return SUDOKUSTORE_BOARDSEGMENTSTARTINDEX_INCORRECT_SEGMENT_MSG;
    case SUDOKUSTORE_RANDOMINDEX_INCORRECT_PARAMETER: return SUDOKUSTORE_RANDOMINDEX_INCORRECT_PARAMETER_MSG;
    case SUDOKUSTORE_RANDOMNUMBER_INCORRECT_PARAMETER: return SUDOKUSTORE_RANDOMNUMBER_INCORRECT_PARAMETER_MSG;
    case SUDOKUSOLVER_BOARD_ERROR: return SUDOKUSOLVER_BOARD_ERROR_MSG;
    case SUDOKUSTORE_CALCULATEPUZZLERATING_PUZZLE_ERROR: return SUDOKUSTORE_CALCULATEPUZZLERATING_PUZZLE_ERROR_MSG;
    case SUDOKUSTORE_CALCULATEPUZZLERATING_NO_SOLUTION: return SUDOKUSTORE_CALCULATEPUZZLERATING_NO_SOLUTION_MSG;
    case SUDOKUSTORE_CALCULATEPUZZLERATING_NON_UNIQUE_SOLUTION: return SUDOKUSTORE_CALCULATEPUZZLERATING_NON_UNIQUE_SOLUTION_MSG;
    case SUDOKUSTORE_CALCULATEPUZZLERATING_THREADS_JOIN_FAILED: return SUDOKUSTORE_CALCULATEPUZZLERATING_THREADS_JOIN_FAILED_MSG;
    default: return ERROR_CODE_UNKNOWN_MSG
    }
    //return ERROR_CODE_UNKNOWN_MSG;
    }
    /**
    * Checks whether error code exists.
    *
    * @param errorCode      Error code
    * @return               True if error code exists, otherwise false.
    */
    static func errorCodeExists(errorCode: Int) -> Bool {
    switch errorCode {
    case SUDOKUSOLVER_LOADBOARD_LOADING_FAILED: return true;
    case SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED:return true;
    case SUDOKUSOLVER_SOLVE_SOLVING_FAILED: return true;
    case SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED: return true;
    case SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED: return true;
    case SUDOKUSOLVER_SETCELL_INCORRECT_DEFINITION: return true;
    case SUDOKUSOLVER_GETCELLDIGIT_INCORRECT_INDEX: return true;
    case SUDOKUSTORE_BOARDSEGMENTSTARTINDEX_INCORRECT_SEGMENT: return true;
    case SUDOKUSTORE_RANDOMINDEX_INCORRECT_PARAMETER: return true;
    case SUDOKUSTORE_RANDOMNUMBER_INCORRECT_PARAMETER: return true;
    case SUDOKUSOLVER_BOARD_ERROR: return true;
    default: return false
    }
    //return false;
    }
    
    static func consolePrintlnIfError(errorCode: Int) {
        if (errorCodeExists(errorCode)) {
            SudokuStore.consolePrintln(getErrorDescription(errorCode));
        }
    }
}