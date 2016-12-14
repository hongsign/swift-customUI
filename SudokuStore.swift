//
//  SudokuStore.swift
//  Dev
//
//  Created by YU HONG on 2016-12-01.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation

class SudokuStore {
    /**
    * Sudoku solver version.
    */
    static let JANET_SUDOKU_VERSION: String = "1.1.1";
    /**
    * Sudoku solver name.
    */
    static let JANET_SUDOKU_NAME: String = "Janet-Sudoku";
    /**
    * Number of Sudoku puzzles examples.
    *
    * @see SudokuPuzzles
    * @see SudokuPuzzles#NUMBER_OF_PUZZLE_EXAMPLES
    */
    static let NUMBER_OF_PUZZLE_EXAMPLES: Int = SudokuPuzzles.NUMBER_OF_PUZZLE_EXAMPLES;
    /**
    * Board size derived form SudokuBoard class.
    */
    static let BOARD_SIZE: Int = SudokuBoard.BOARD_SIZE;
    /**
    * Sudoku board sub-square size derived from SudokuBoard class.
    */
    static let BOARD_SUB_SQURE_SIZE: Int = SudokuBoard.BOARD_SUB_SQURE_SIZE;
    /**
    * Number of 9x3 column segments or 3x9 row segments.
    * derived from SudokuBoard class.
    */
    static let BOARD_SEGMENTS_NUMBER: Int = SudokuBoard.BOARD_SEGMENTS_NUMBER;
    /**
    * Number of available random board transformations.
    *
    * @see SudokuStore#randomBoardTransf(int[][])
    * @see SudokuStore#seqOfRandomBoardTransf(int[][])
    * @see SudokuStore#seqOfRandomBoardTransf(int[][], int)
    */
    static let AVAILABLE_RND_BOARD_TRANSF: Int = 17;
    /**
    * Default sequence length of random board transformations.
    *
    * @see SudokuStore#randomBoardTransf(int[][])
    * @see SudokuStore#seqOfRandomBoardTransf(int[][])
    * @see SudokuStore#seqOfRandomBoardTransf(int[][], int)
    */
    static let DEFAULT_RND_TRANSF_SEQ_LENGTH: Int = 1000;
    /**
    * System specific new line separator
    */
    static let NEW_LINE_SEPARATOR: String = "\n" //System.getProperty("line.separator");
    /**
    * Threads number.
    */
    static let THREADS_NUMBER: Int = 4 //Runtime.getRuntime().availableProcessors();
    /**
    * Default number of iterations while calculating
    * puzzle rating.
    */
    static let RATING_DEF_NUM_OF_ITERATIONS: Int = 1000;
    /*
    * ======================================================
    *     Loading / getting board methods
    * ======================================================
    */
    /**
    * Gets Sudoku example for the Sudoku Store.
    * @param exampleNumber     Example number.
    * @return                  Sudoku example is exists, otherwise null.
    * @see SudokuPuzzles#NUMBER_OF_PUZZLE_EXAMPLES
    * @see SudokuPuzzles#getPuzzleExample(int)
    */
    static func getPuzzleExample(exampleNumber: Int) -> [[Int]] {
    return SudokuPuzzles.getPuzzleExample(exampleNumber);
    }
    /**
    * Gets Sudoku example for the Sudoku Store.
    * @return                  Sudoku example is exists, otherwise null.
    * @see SudokuPuzzles#NUMBER_OF_PUZZLE_EXAMPLES
    * @see SudokuPuzzles#getPuzzleExample(int)
    */
    static func getPuzzleExample() -> [[Int]] {
    return SudokuPuzzles.getPuzzleExample( SudokuStore.randomIndex(SudokuPuzzles.NUMBER_OF_PUZZLE_EXAMPLES) );
    }
    /**
    * Returns pre-calculated puzzle example difficulty rating based on
    * the average number of steps-back performed while recursive
    * solving sudoku board.
    *
    * @param exampleNumber   The example number {@link SudokuPuzzles#NUMBER_OF_PUZZLE_EXAMPLES}
    * @return Puzzle example difficulty rating if example exists, otherwise -1.
    */
    static func getPuzzleExampleRating(exampleNumber: Int) -> Double {
    return SudokuPuzzles.getPuzzleExampleRating(exampleNumber);
    }
    /**
    * Calculates difficulty of Sudoku puzzle. Returned difficulty level is an average
    * of number of closed routes while performing recursive steps in order to find solution.
    * This is multi-threading procedure.
    *
    * @param sudokuPuzzle   Sudoku puzzle to be rated.
    * @return               If puzzle does not contain an error then difficulty rating is returned.
    *                       If puzzle contains obvious error then {@link ErrorCodes#SUDOKUSTORE_CALCULATEPUZZLERATING_PUZZLE_ERROR}.
    *                       If puzzle has no solutions then {@link ErrorCodes#SUDOKUSTORE_CALCULATEPUZZLERATING_NO_SOLUTION}.
    *                       If solution is non-unique then {@link ErrorCodes#SUDOKUSTORE_CALCULATEPUZZLERATING_NON_UNIQUE_SOLUTION}.
    */
    static func calculatePuzzleRating(sudokuPuzzle: [[Int]]) -> Int {
    
        if checkPuzzle(sudokuPuzzle) == false {
            return SudokuErrorCodes.SUDOKUSTORE_CALCULATEPUZZLERATING_PUZZLE_ERROR
        }
        let s = SudokuSolver(sudokuBoard: sudokuPuzzle)
        let solType: Int = s.checkIfUniqueSolution();
        if solType == SudokuSolver.SOLUTION_NOT_EXISTS {
            return SudokuErrorCodes.SUDOKUSTORE_CALCULATEPUZZLERATING_NO_SOLUTION
        }
        if solType == SudokuSolver.SOLUTION_NON_UNIQUE {
            return SudokuErrorCodes.SUDOKUSTORE_CALCULATEPUZZLERATING_NON_UNIQUE_SOLUTION
        }
        
        s.solve();
        return s.getClosedRoutesNumber()
        
        /*
        /*
        * Multi-threading implementation
        */
        var threadIterNum: Int = RATING_DEF_NUM_OF_ITERATIONS / THREADS_NUMBER;
        var results: [[Int]] = [[Int]]() //int[THREADS_NUMBER][threadIterNum];
        /**
        * Runner implementation.
        */
        class Runner implements Runnable {
    /**
			 * Thread id.
			 */
    int threadId;
    /**
			 * Number of iterations.
			 */
    int iterNum;
    /**
			 * Default constructor.
			 * @param threadId       Thread id.
			 * @param assigments     Test assigned to that thread.
			 */
    Runner(int threadId, int iterNum) {
				this.threadId = threadId;
				this.iterNum = iterNum;
    }
    /**
			 * Synchronized method to store test results.
			 * @param t          Test id.
			 * @param result     TEst result.
			 */
    private void setTestResult(int i, int result) {
				synchronized(results) {
    results[threadId][i] = result;
				}
    }
    public void run() {
				for (int i = 0; i < iterNum; i++) {
    SudokuSolver s = new SudokuSolver(sudokuPuzzle);
    s.solve();
    setTestResult(i, s.getClosedRoutesNumber());
				}
    }
    }
    Runner[] runners = new Runner[THREADS_NUMBER];
    Thread[] threads = new Thread[THREADS_NUMBER];
    for (int t = 0; t < THREADS_NUMBER; t++) {
    runners[t] = new Runner(t, threadIterNum);
    threads[t] = new Thread(runners[t]);
    }
    for (int t = 0; t < THREADS_NUMBER; t++) {
    threads[t].start();
    }
    for (int t = 0; t < THREADS_NUMBER; t++) {
    try {
				threads[t].join();
    } catch (InterruptedException e) {
				e.printStackTrace();
				return ErrorCodes.SUDOKUSTORE_CALCULATEPUZZLERATING_THREADS_JOIN_FAILED;
    }
    }
    int sum = 0;
    for (int t = 0; t < THREADS_NUMBER; t++)
    for (int i = 0; i < threadIterNum; i++)
				sum+=results[t][i];
    return sum / (THREADS_NUMBER * threadIterNum);
    */
    }
    /**
    * Loads Sudoku board from text file.
    *
    * Format:
    * Any character different than '1-9' and '.' is being removed.
    * Any line starting with '#' is being removed.
    * Any empty line is being removed.
    * Any final line having less than 9 characters is being removed.
    *
    * If number of final lines is less then 9 then null is returned.
    *
    * Finally 9 starting characters for first 9 lines is the
    * loaded board definition.
    *
    * @param filePath  Path to the file with Sudoku board definition.
    * @return  Array representing loaded Sudoku board,
    *          null - if problem occurred while loading.
    */
    static func loadBoard(filePath: String) -> [[Int]]? {
        
        let persistenceFileName = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] ).stringByAppendingString(filePath)
        
        var str: String = ""
        do {
            str = try NSString(contentsOfFile: persistenceFileName, encoding: NSUTF8StringEncoding) as String
            let fileLines: Array<String> = str.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
            return loadBoard(fileLines)
        }
        catch let error as NSError {
            print("PERSISTANCE: " + error.description)
            return nil
        }
    }
    /**
    * Loads Sudoku board from list of strings (each string as a
    * one row)
    *
    * Format:
    * Any character different than '1-9' and '.' is being removed.
    * Any line starting with '#' is being removed.
    * Any empty line is being removed.
    * Any final line having less than 9 characters is being removed.
    *
    * If number of final lines is less then 9 then null is returned.
    *
    * Finally 9 starting characters for first 9 lines is the
    * loaded board definition.
    *
    * @param boardDefinition  Board definition (list of strings).
    * @return  Array representing loaded Sudoku board,
    *          null - if problem occurred while loading.
    */
    static func loadBoard(boardDefinition: Array<String>) -> [[Int]] {
        return loadBoard([String](boardDefinition))
    }
    /**
    * Loads Sudoku board from array of strings (each string as a
    * one row)
    *
    * Format:
    * Any character different than '1-9' and '.' is being removed.
    * Any line starting with '#' is being removed.
    * Any empty line is being removed.
    * Any final line having less than 9 characters is being removed.
    *
    * If number of final lines is less then 9 then null is returned.
    *
    * Finally 9 starting characters for first 9 lines is the
    * loaded board definition.
    *
    * @param boardDefinition  Board definition (array of strings).
    * @return  Array representing loaded Sudoku board,
    *          null - if problem occurred while loading.
    */
    static func loadBoard(boardDefinition: [String]?) -> [[Int]]? {
        var sudokuRows: Array<String> = Array<String>();
        guard let boarddef = boardDefinition else {
            return nil
        }
        if boarddef.count < BOARD_SIZE {
            return nil
        }
        for line in boarddef {
            if line.characters.count > 0 {
				if (String(line.characters.first) != "#") {
                    var sudokuRow: String = ""
                    
                    for c in line.characters {
                    
                        if (
                        (c == "1") ||
                        (c == "2") ||
                        (c == "3") ||
                        (c == "4") ||
                        (c == "5") ||
                        (c == "6") ||
                        (c == "7") ||
                        (c == "8") ||
                        (c == "9") ||
                        (c == "0") ||
                            (c == ".")) {
                        sudokuRow = sudokuRow + String(c);
                        }
                    }
                    if sudokuRow.characters.count >= BOARD_SIZE {
                        sudokuRows.append(sudokuRow.substringToIndex(sudokuRow.startIndex.advancedBy(BOARD_SIZE)))
                    }
				}
            }
        }
        if sudokuRows.count < BOARD_SIZE {
            return nil
        }
        var sudokuBoard: [[Int]] = [[Int]]()
        for i in 0..<BOARD_SIZE {
            let sudokuRow: String = sudokuRows[i]
            var j: Int = 0
            for c in sudokuRow.characters {
                var d: Int = SudokuBoardCell.EMPTY
                switch c {
                    case "1": d = 1
                    case "2": d = 2
                    case "3": d = 3
                    case "4": d = 4
                    case "5": d = 5
                    case "6": d = 6
                    case "7": d = 7
                    case "8": d = 8
                    case "9": d = 9
                    default: d = SudokuBoardCell.EMPTY
                }
                sudokuBoard[i][j] = d
                j = j + 1
                if j >= BOARD_SIZE {
                    break
                }
            }
        }
        
        return sudokuBoard;
    }
    /**
    * Loads Sudoku board from one string line ('0' and' '.' treated as empty cell).
    * Any other char than '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'
    * is being filtered out.
    *
    * @param boardDefinition    Board definition in one string line containing
    *                           row after row.
    * @return                   Loaded board if data is sufficient to fill 81 cells
    *                           (including empty cells), otherwise null.
    */
    static func loadBoardFromStringLine(boardDefinition: String?) -> [[Int]]? {
        let lastInex = BOARD_SIZE - 1;
        
        guard let boarddef = boardDefinition else {
            return nil
        }
        
        if boarddef.characters.count < SudokuBoard.BOARD_CELLS_NUMBER {
            return nil
        }
        
        var board: [[Int]] = boardCopy(SudokuPuzzles.PUZZLE_EMPTY)
        
        var cellNum: Int = 0
        var i: Int = 0
        var j: Int = -1
        for c in (boardDefinition?.characters)! {
            var d: Int = -1
            switch c {
                case "1": d = 1
                case "2": d = 2
                case "3": d = 3
                case "4": d = 4
                case "5": d = 5
                case "6": d = 6
                case "7": d = 7
                case "8": d = 8
                case "9": d = 9
                case "0": d = 0
                case ".": d = 0
                default: d = -1
            }
            if d >= 0 && cellNum < SudokuBoard.BOARD_CELLS_NUMBER {
                j += 1
                cellNum += 1
                board[i][j] = d
                if j == lastInex {
                    i += 1
                    j = -1
                }
            }
        }
        
        if cellNum == SudokuBoard.BOARD_CELLS_NUMBER {
            return board
        }
        else {
            return nil
        }

    }
    /**
    * Loads Sudoku board from variadic list of strings (each string as a
    * one row)
    *
    * Format:
    * Any character different than '1-9' and '.' is being removed.
    * Any line starting with '#' is being removed.
    * Any empty line is being removed.
    * Any final line having less than 9 characters is being removed.
    *
    * If number of final lines is less then 9 then null is returned.
    *
    * Finally 9 starting characters for first 9 lines is the
    * loaded board definition.
    *
    * @param boardDefinition  Board definition (variadic list of strings).
    * @return  Array representing loaded Sudoku board,
    *          null - if problem occurred while loading.
    */
    static func loadBoardFromStrings(boardDefinition: [String]) -> [[Int]] {
        return loadBoard(boardDefinition);
    }
    /**
    * Saves board to the text file.
    *
    * @param sudokuBoard    Sudoku board to be saved.
    * @param filePath       Path to the file.
    * @return               True if saving was successful, otherwise false.
    *
    * @see SudokuStore#boardToString(int[][])
    */
    static func saveBoard(sudokuBoard: [[Int]], filePath: String) -> Bool {
        let boardString: String = SudokuStore.boardToString(sudokuBoard);
        return SudokuStore.saveToFile(filePath, boardstr: boardString)
    }
    /**
    * Saves board to the text file.
    *
    * @param sudokuBoard    Sudoku board to be saved.
    * @param filePath       Path to the file.
    * @param headComment    Comment to be added at the head.
    * @return               True if saving was successful, otherwise false.
    *
    * @see SudokuStore#boardToString(int[][], String)
    */
    static func saveBoard(sudokuBoard: [[Int]], filePath: String, headComment: String) -> Bool {
        let boardString: String = SudokuStore.boardToString(sudokuBoard, headComment: headComment, tailComment: "");
        return SudokuStore.saveToFile(filePath, boardstr: boardString)
    }
    /**
    * Saves board to the text file.
    *
    * @param sudokuBoard    Sudoku board to be saved.
    * @param filePath       Path to the file.
    * @param headComment    Comment to be added at the head.
    * @param tailComment    Comment to be added at the tail.
    * @return               True if saving was successful, otherwise false.
    *
    * @see SudokuStore#boardToString(int[][], String, String)
    */
    static func saveBoard(sudokuBoard: [[Int]], filePath: String, headComment: String, tailComment: String) -> Bool {
        let boardString: String = SudokuStore.boardToString(sudokuBoard, headComment: headComment, tailComment: tailComment);
        return SudokuStore.saveToFile(filePath, boardstr: boardString)
    }
    
    private static func saveToFile(filePath: String, boardstr: String) -> Bool {
        let persistenceFileName = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] ).stringByAppendingString(filePath)
        
        do {
            _ = try boardstr.writeToFile(persistenceFileName, atomically: true, encoding: NSUTF8StringEncoding)
            return true
        } catch let error as NSError {
            print(error.description)
            return false
        }

    }
    /**
    * Set all digits to zero.
    *
    * @param digits
    * @see SudokuStore#checkSolvedBoard(int[][])
    */
    private static func clearDigits(var digits: [Int]) {
        for i in 0..<10 {
            digits[i] = 0;
        }
    }
    /**
    * Returns found unique digits number.
    *
    * @param digits
    * @see SudokuStore#checkSolvedBoard(int[][])
    *
    * @return Unique digits number.
    */
    private static func sumDigits(digits: [Int]) -> Int {
        var s: Int = 0
        for i in 1..<10 {
            s += digits[i]
        }
        return s
    }
    /**
    * Returns maximum count of found digits
    *
    * @param digits
    * @see SudokuStore#checkPuzzle(int[][])
    *
    * @return Unique digits number.
    */
    private static func maxDigitCount(digits: [Int]) -> Int {
        var max: Int = 0
        for i in 1..<10 {
            if digits[i] > max {
                max = digits[i]
            }
        }
        return max
    }
    /**
    * Checks whether solved board is correct.
    *
    * @param solvedBoard   The solved board to be verified.
    *
    * @return              True if solved board is correct, otherwise false.
    */
    static func checkSolvedBoard(solvedBoard: [[Int]]?) -> Bool {
        
        guard let board = solvedBoard else {
            return false
        }
        if board.count != BOARD_SIZE {
            return false
        }
        if board[0].count != BOARD_SIZE {
            return false
        }
        
        var digits: [Int] = [Int](count: 10, repeatedValue: 0)
        for i in 0..<BOARD_SIZE {
            clearDigits(digits)
            for j in 0..<BOARD_SIZE {
                let d = board[i][j]
                if d < 1 || d > 9 {
                    return false
                }
                digits[d] = 1
            }
            if sumDigits(digits) != 9 {
                return false
            }
        }
        
        for j in 0..<BOARD_SIZE {
            clearDigits(digits)
            for i in 0..<BOARD_SIZE {
                let d = board[i][j]
                digits[d] = 1
            }
            if sumDigits(digits) != 9 {
                return false
            }
        }

        for rowSeg in 0..<BOARD_SEGMENTS_NUMBER {
            let iSeg: Int = boardSegmentStartIndex(rowSeg)
            for colSeg in 0..<BOARD_SEGMENTS_NUMBER {
                let jSeg: Int = boardSegmentStartIndex(colSeg)
                clearDigits(digits)
                for i in 0..<BOARD_SUB_SQURE_SIZE {
                    for j in 0..<BOARD_SUB_SQURE_SIZE {
                        let d = board[iSeg+i][jSeg+j]
                        digits[d] = 1
                    }
                    
                }
                if sumDigits(digits) != 9 {
                    return false
                }
            }
        }

        return true;
    }
    /**
    * Checks whether Sudoku puzzle contains an obvious error.
    *
    * @param sudokuBoard   The board to be verified.
    *
    * @return              True if no obvious error, otherwise false.
    */
    static func checkPuzzle(sudokuBoard: [[Int]]?) -> Bool {
        
        guard let board = sudokuBoard else {
            return false
        }
        if board.count != BOARD_SIZE {
            return false
        }
        if board[0].count != BOARD_SIZE {
            return false
        }
        
        var digits: [Int] = [Int](count: 10, repeatedValue: 0)
        for i in 0..<BOARD_SIZE {
            clearDigits(digits)
            for j in 0..<BOARD_SIZE {
                let d = board[i][j]
                if d < 0 || d > 9 {
                    return false
                }
                digits[d] = digits[d] + 1
            }
            if maxDigitCount(digits) > 1 {
                return false
            }
        }
        
        for j in 0..<BOARD_SIZE {
            clearDigits(digits)
            for i in 0..<BOARD_SIZE {
                let d = board[i][j]
                digits[d] = digits[d] + 1
            }
            if maxDigitCount(digits) > 1 {
                return false
            }
        }
        

        for rowSeg in 0..<BOARD_SEGMENTS_NUMBER {
            let iSeg = boardSegmentStartIndex(rowSeg)
            for colSeg in 0..<BOARD_SEGMENTS_NUMBER {
                let jSeg = boardSegmentStartIndex(colSeg)
                clearDigits(digits)
                for i in 0..<BOARD_SUB_SQURE_SIZE {
                    for j in 0..<BOARD_SUB_SQURE_SIZE {
                        let d = board[iSeg+i][jSeg+j]
                        digits[d] = digits[d] + 1
                    }
                }
                if maxDigitCount(digits) > 1 {
                    return false
                }
            }
        }
    
        return true;
    }
    /*
    * ======================================================
    *         Allowed operation on Sudoku board
    * ======================================================
    */
    /*
    * ======================================================
    *                 Rotation methods
    * ======================================================
    */
    /**
    * Clockwise rotation of Sudoku board.
    *
    * @param sudokuBoard Array representing Sudoku board.
    * @return Clockwise rotated sudoku board.
    */
    static func rotateClockWise(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else {
            return nil
        }
        
        var rotated: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: SudokuBoardCell.EMPTY))

        
        for i in 0..<BOARD_SIZE {
            rotated.append([Int]())
            let newColIndex: Int = BOARD_SIZE - i - 1
            for j in 0..<BOARD_SIZE {
                rotated[j][newColIndex] = board[i][j]
            }
        }
        return rotated
    }
    /**
    * Counterclockwise rotation of Sudoku board.
    *
    * @param sudokuBoard Array representing Sudoku board.
    * @return Clockwise rotated Sudoku board.
    */
    static func rotateCounterclockWise(sudokuBoard: [[Int]]?) -> [[Int]]? {
    
        guard let board = sudokuBoard else {
            return nil
        }
    
        var rotated: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: SudokuBoardCell.EMPTY))
        
        for j in 0..<BOARD_SIZE {
            let newRowIndex = BOARD_SIZE - j - 1
            for i in 0..<BOARD_SIZE {
                rotated[newRowIndex][i] = board[i][j]
            }
        }

        return rotated
    }
    /*
    * ======================================================
    *                 Reflection methods
    * ======================================================
    */
    /**
    * Horizontal reflection of the Sudoku board.
    *
    * @param sudokuBoard Array representing Sudoku board.
    * @return Horizontally reflected Sudoku board.
    */
    static func reflectHorizontally(sudokuBoard: [[Int]]?) -> [[Int]]? {
    
        guard let board = sudokuBoard else {
            return nil
        }
        var reflectedBoard: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: SudokuBoardCell.EMPTY))
        
        for i in 0..<BOARD_SIZE {
            let newRowIndex = BOARD_SIZE - i - 1
            for j in 0..<BOARD_SIZE {
                reflectedBoard[newRowIndex][j] = board[i][j]
            }
        }
        
        return reflectedBoard;
    }
    /**
    * Vertical reflection of the Sudoku board.
    *
    * @param sudokuBoard Array representing Sudoku board.
    * @return Vertically reflected Sudoku board.
    */
    static func reflectVertically(sudokuBoard: [[Int]]?) -> [[Int]]? {
    
    guard let board = sudokuBoard else {
        return nil
    }
    var reflectedBoard: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: SudokuBoardCell.EMPTY))
    
    for j in 0..<BOARD_SIZE {
        let newColIndex = BOARD_SIZE - j - 1
        for i in 0..<BOARD_SIZE {
            reflectedBoard[i][newColIndex] = board[i][j]
        }
    }

    
        return reflectedBoard;
    }
    /**
    * Diagonal (Top-Left -&gt; Bottom-Right) reflection of the Sudoku board.
    *
    * @param sudokuBoard Array representing Sudoku board.
    * @return Diagonally (Top-Left -&gt; Bottom-Right) reflection of the Sudoku board. reflected Sudoku board.
    */
    static func transposeTlBr(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else {
            return nil
        }
        var reflectedBoard: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: SudokuBoardCell.EMPTY))
        
        for i in 0..<BOARD_SIZE {
            for j in 0..<BOARD_SIZE {
                reflectedBoard[j][i] = board[i][j]
            }
        }

        return reflectedBoard;
    }
    /**
    * Diagonal (Top-Right -&gt; Bottom-Left) reflection of the Sudoku board.
    *
    * @param sudokuBoard Array representing Sudoku board.
    * @return Diagonally Top-Right -&gt; Bottom-Left) reflection of the Sudoku board. reflected Sudoku board.
    */
    static func transposeTrBl(sudokuBoard: [[Int]]?) -> [[Int]]? {
    
        guard let board = sudokuBoard else {
            return nil
        }
        var reflectedBoard: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: SudokuBoardCell.EMPTY))
        
        for i in 0..<BOARD_SIZE {
            let newColIndex = BOARD_SIZE - i - 1
            for j in 0..<BOARD_SIZE {
                let newRowIndex = BOARD_SIZE - j - 1
                reflectedBoard[newRowIndex][newColIndex] = board[i][j]
            }
        }
        
        return reflectedBoard
    }
    /*
    * ======================================================
    *                 Swapping methods
    * ======================================================
    */
    /**
    * Swapping 2 row segments (3x9 each one) of Sudoku board.
    *
    * @param    sudokuBoard     Array representing Sudoku board.
    * @param    rowSeg1         First row segment id: 0, 1, 2.
    * @param    rowSeg2	     Second row segment id: 0, 1, 2.
    * @return   New array containing values resulted form swapping
    *           row  segments procedure. If both segments are equal
    *           or one of the segments id is not 0, 1, or 2, then exact
    *           copy of original board is returned.
    */
    static func swapRowSegments(sudokuBoard: [[Int]], rowSeg1: Int, rowSeg2: Int) -> [[Int]] {
        /*
        guard let board = sudokuBoard else {
            return nil
        }
        guard var newBoard = boardCopy(board) else {
            return nil
        }
        */
        
        var newBoard = boardCopy(sudokuBoard)
        
        if rowSeg1 == rowSeg2 {
            return newBoard
        }
        if rowSeg1 < 0 || rowSeg1 > 2 {
            return newBoard
        }
        if rowSeg2 < 0 || rowSeg2 > 2 {
            return newBoard
        }
        let startRowSeg1 = boardSegmentStartIndex(rowSeg1)
        let startRowSeg2 = boardSegmentStartIndex(rowSeg2)
        for i in 0..<BOARD_SUB_SQURE_SIZE {
            for j in 0..<BOARD_SIZE {
                newBoard[startRowSeg1 + i][j] = sudokuBoard[startRowSeg2 + i][j]
                newBoard[startRowSeg2 + i][j] = sudokuBoard[startRowSeg1 + i][j]
            }
        }

        return newBoard
    }
    /**
    * Swapping randomly selected 2 row segments (3x9 each one) of Sudoku board.
    *
    * @param    sudokuBoard     Array representing Sudoku board.
    * @return   New array containing values resulted form swapping
    *           column  segments procedure.
    */
    static func swapRowSegmentsRandomly(sudokuBoard: [[Int]]?) -> [[Int]]? {
        
        guard let board = sudokuBoard else {
            return nil
        }
        return swapRowSegments(board, rowSeg1: randomIndex(BOARD_SEGMENTS_NUMBER), rowSeg2: randomIndex(BOARD_SEGMENTS_NUMBER))
        
    }
    /**
    * Swapping 2 column segments (9x3 each one) of Sudoku board.
    *
    * @param    sudokuBoard     Array representing Sudoku board.
    * @param    colSeg1         First column segment id: 0, 1, 2.
    * @param    colSeg2	     Second column segment id: 0, 1, 2.
    * @return   New array containing values resulted form swapping
    *           column  segments procedure. If both segments are equal
    *           or one of the segments id is not 0, 1, or 2, then exact
    *           copy of original board is returned.
    */
    static func swapColSegments(sudokuBoard: [[Int]], colSeg1: Int, colSeg2: Int) -> [[Int]] {
        /*
        guard let board = sudokuBoard else {
            return nil
        }
        guard var newBoard = boardCopy(board) else {
            return nil
        }
        */
        var newBoard = boardCopy(sudokuBoard)
        if colSeg1 == colSeg2 { return newBoard }
        if colSeg1 < 0 || colSeg1 > 2 { return newBoard }
        if colSeg2 < 0 || colSeg2 > 2 { return newBoard }
        
        let startColSeg1 = boardSegmentStartIndex(colSeg1)
        let startColSeg2 = boardSegmentStartIndex(colSeg2)
        for j in 0..<BOARD_SUB_SQURE_SIZE {
            for i in 0..<BOARD_SIZE {
                newBoard[i][startColSeg1 + j] = sudokuBoard[i][startColSeg2 + j]
                newBoard[i][startColSeg2 + j] = sudokuBoard[i][startColSeg1 + j]
            }
        }
        return newBoard
    
    }
    /**
    * Swapping randomly selected 2 column segments (9x3 each one) of Sudoku board.
    *
    * @param    sudokuBoard     Array representing Sudoku board.
    * @return   New array containing values resulted form swapping
    *           column  segments procedure.
    */
    static func swapColSegmentsRandomly(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else {
            return nil
        }

        return swapColSegments(board, colSeg1: randomIndex(BOARD_SEGMENTS_NUMBER), colSeg2: randomIndex(BOARD_SEGMENTS_NUMBER));
    }
    /**
    * Swapping 2 rows within a given row segment.
    *
    * @param    sudokuBoard     Array representing Sudoku board.
    * @param    rowSeg          Row segment id: 0, 1, 2.
    * @param    row1            First row id within a segment: 0, 1, 2.
    * @param    row2            Second row id within a segment: 0, 1, 2.
    * @return   New array containing values resulted form swapping
    *           rows procedure. If both rows are equal
    *           or one of the row id is not 0, 1, or 2, then exact
    *           copy of original board is returned.
    */
    static func swapRowsInSegment(sudokuBoard: [[Int]], int rowSeg: Int, row1: Int, row2: Int) -> [[Int]] {
        /*
        guard let board = sudokuBoard else {
            return nil
        }
        guard var newBoard = boardCopy(board) else {
            return nil
        }
        */
        var newBoard = boardCopy(sudokuBoard)
        if row1 == row2 || rowSeg < 0 || rowSeg > 2 || row1 < 0 || row1 > 2 || row2 < 0 || row2 > 2 {
            return newBoard
        }
        let segStart = boardSegmentStartIndex(rowSeg)
        for j in 0..<BOARD_SIZE {
            newBoard[segStart + row1][j] = sudokuBoard[segStart + row2][j]
            newBoard[segStart + row2][j] = sudokuBoard[segStart + row1][j]
        }
    
    
        return newBoard
    }
    /**
    * Swapping randomly selected 2 rows within randomly select row segment.
    *
    * @param    sudokuBoard     Array representing Sudoku board.
    * @return   New array containing values resulted form swapping
    *           column  segments procedure.
    */
    static func swapRowsInSegmentRandomly(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else {
            return nil
        }

        return swapRowsInSegment(board, int: randomIndex(BOARD_SEGMENTS_NUMBER), row1: randomIndex(BOARD_SEGMENTS_NUMBER), row2: randomIndex(BOARD_SEGMENTS_NUMBER));
    }
    /**
    * Swapping 2 columns within a given column segment.
    *
    * @param    sudokuBoard     Array representing Sudoku board.
    * @param    colSeg          Column segment id: 0, 1, 2.
    * @param    col1            First column id within a segment: 0, 1, 2.
    * @param    col2            Second column id within a segment: 0, 1, 2.
    * @return   New array containing values resulted form swapping
    *           columns procedure. If both columns are equal
    *           or one of the  id is not 0, 1, or 2, then exact
    *           copy of original board is returned.
    */
    static func swapColsInSegment(sudokuBoard: [[Int]], colSeg: Int, col1: Int, col2: Int) -> [[Int]] {
        /*
        guard let board = sudokuBoard else {
            return nil
        }
        guard var newBoard = boardCopy(board) else {
            return nil
        }
        */
        var newBoard = boardCopy(sudokuBoard)
        if colSeg < 0 || colSeg > 2 || col1 < 0 || col1 > 2 || col2 < 0 || col2 > 2 || col1 == col2 {
            return newBoard
        }
        let segStart = boardSegmentStartIndex(colSeg)
        for i in 0..<BOARD_SIZE {
            newBoard[i][segStart + col1] = sudokuBoard[i][segStart + col2]
            newBoard[i][segStart + col2] = sudokuBoard[i][segStart + col1]
        }
        return newBoard
    }
    /**
    * Swapping randomly selected 2 columns within randomly select column segment.
    *
    * @param    sudokuBoard     Array representing Sudoku board.
    * @return   New array containing values resulted form swapping
    *           column  segments procedure.
    */
    static func swapColsInSegmentRandomly(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else {
            return nil
        }
    
        return swapColsInSegment(board, colSeg: randomIndex(BOARD_SEGMENTS_NUMBER), col1: randomIndex(BOARD_SEGMENTS_NUMBER), col2: randomIndex(BOARD_SEGMENTS_NUMBER))
    }
    /*
    * ======================================================
    *                 Permutation methods
    * ======================================================
    */
    /**
    * Sudoku board permutation.
    * @param sudokuBoard     Sudoku board to be permuted.
    * @param permutation     Permutation (ie. 5, 2, 8, 9, 1, 3, 6, 4, 7)
    * @return                If board is null then null,
    *                        If permutation is not valid the original board.
    *                        Otherwise permuted board.
    */
    static func permuteBoard(sudokuBoard: [[Int]]?, permutation: [Int]) -> [[Int]]? {
        guard let board = sudokuBoard else {
            return nil
        }
        if !isValidPermutation(permutation, n: BOARD_SIZE) {
            return boardCopy(board)
        }
        var permutedboard: [[Int]] = [[Int]]()
        for i in 0..<BOARD_SIZE {
            permutedboard.append([Int]())
            for _ in 0..<BOARD_SIZE {
                permutedboard[i].append(SudokuBoardCell.EMPTY)
            }
        }
        
        for i in 0..<BOARD_SIZE {
            for j in 0..<BOARD_SIZE {
                let digit = board[i][j]
                if digit == SudokuBoardCell.EMPTY {
                    permutedboard[i][j] = SudokuBoardCell.EMPTY
                }
                else {
                    permutedboard[i][j] = permutation[digit-1] + 1
                }
            }
        }
        return permutedboard
    }
    /**
    * Random permutation of sudoku board.
    *
    * @param sudokuBoard     Sudoku board to be permuted.
    * @return                If sudoku board is  ot null then permuted board,
    *                        otherwise null.
    */
    static func permuteBoard(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        return permuteBoard(board, permutation: generatePermutation(BOARD_SIZE)!)
    }
    /**
    * Method applies given permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 row segments (3x9 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @param    permutation    Array representing permutation of length 3 (permuting: 0, 1, 2).
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned. If permutation is not valid copy of original Sudoku board
    *           is returned.
    */
    static func permuteRowSegments(sudokuBoard: [[Int]]?, permutation: [Int]) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        if !isValidPermutation(permutation, n: BOARD_SEGMENTS_NUMBER) {
            return boardCopy(board)
        }
        var permutedboard: [[Int]] = [[Int]]()
        for i in 0..<BOARD_SIZE {
            permutedboard.append([Int]())
            for _ in 0..<BOARD_SIZE {
                permutedboard[i].append(SudokuBoardCell.EMPTY)
            }
        }
        var segmentstart = [Int]()
        for _ in 0..<BOARD_SEGMENTS_NUMBER {
            segmentstart.append(0)
        }
        for seg in 0..<BOARD_SEGMENTS_NUMBER {
            segmentstart[seg] = boardSegmentStartIndex(seg)
        }
        for seg in 0..<BOARD_SEGMENTS_NUMBER {
            for i in 0..<BOARD_SUB_SQURE_SIZE {
                let curRowIndex = segmentstart[permutation[seg]] + i
                let newRowIndex = segmentstart[seg] + i
                for j in 0..<BOARD_SIZE {
                    permutedboard[newRowIndex][j] = board[curRowIndex][j]
                }
            }
        }
    
        return permutedboard
    }
    /**
    * Method applies randomly generated permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 row segments (3x9 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned.
    */
    static func permuteRowSegments(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        return permuteRowSegments(board, permutation: generatePermutation(BOARD_SEGMENTS_NUMBER)! );
    }
    /**
    * Method applies given permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 column segments (9x3 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @param    permutation    Array representing permutation of length 3 (permuting: 0, 1, 2).
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned. If permutation is not valid copy of original Sudoku board
    *           is returned.
    */
    static func permuteColSegments(sudokuBoard: [[Int]]?, permutation: [Int]) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        if !isValidPermutation(permutation, n: BOARD_SEGMENTS_NUMBER) {
            return boardCopy(board)
        }
        var permutatedBoard: [[Int]] = [[Int]]()
        for i in 0..<BOARD_SIZE {
            permutatedBoard.append([Int]())
            for _ in 0..<BOARD_SIZE {
                permutatedBoard[i].append(SudokuBoardCell.EMPTY)
            }
        }
        var segmentstart: [Int] = [Int]()
        for _ in 0..<BOARD_SEGMENTS_NUMBER {
            segmentstart.append(0)
        }
        
        for seg in 0..<BOARD_SEGMENTS_NUMBER {
            segmentstart[seg] = boardSegmentStartIndex(seg)
        }
        for seg in 0..<BOARD_SEGMENTS_NUMBER {
            for j in 0..<BOARD_SUB_SQURE_SIZE {
                let curColIndex = segmentstart[permutation[seg]] + j
                let newColIndex = segmentstart[seg] + j
                for i in 0..<BOARD_SIZE {
                    permutatedBoard[i][newColIndex] = board[i][curColIndex]
                }
            }
        }
        return permutatedBoard;
    }
    /**
    * Method applies randomly generated permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 column segments (9x3 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned.
    */
    static func permuteColSegments(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        return permuteColSegments(board, permutation: generatePermutation(BOARD_SEGMENTS_NUMBER)! );
    }
    /**
    * Method applies given permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 rows in a given row segment (9x3 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @param    rowSeg         Row segment id: 0, 1, 2.
    * @param    permutation    Permutation of length 3 (0, 1, 2)
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned. If permutation is not valid exact copy of
    *           Sudoku board is returned.
    *
    * @see SudokuStore#isValidPermutation(int[])
    * @see SudokuStore#generatePermutation(int)
    */
    static func permuteRowsInSegment(sudokuBoard: [[Int]]?, rowSeg: Int, permutation: [Int]) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        if !isValidPermutation(permutation, n: BOARD_SUB_SQURE_SIZE) {
            return boardCopy(board)
        }
        var permutatedBoard: [[Int]] = boardCopy(board)
        if rowSeg < 0 || rowSeg > 2 { return permutatedBoard }
        let segstart = boardSegmentStartIndex(rowSeg)
        for i in 0..<BOARD_SUB_SQURE_SIZE {
            let curRowIndex = segstart + permutation[i]
            let newRowIndex = segstart + i
            for j in 0..<BOARD_SIZE {
                permutatedBoard[newRowIndex][j] = board[curRowIndex][j]
            }
        }
        return permutatedBoard;
    }
    /**
    * Method applies randomly generated permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 rows in a given row segment (9x3 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @param    rowSeg         Row segment id: 0, 1, 2.
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned.
    *
    * @see SudokuStore#generatePermutation(int)
    */
    static func permuteRowsInSegment(sudokuBoard: [[Int]]?, rowSeg: Int) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        return permuteRowsInSegment(board, rowSeg: rowSeg, permutation: generatePermutation(BOARD_SUB_SQURE_SIZE)! );
    }
    /**
    * Method applies randomly generated permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 rows in a randomly selected row segment (9x3 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned.
    *
    * @see SudokuStore#generatePermutation(int)
    */
    static func permuteRowsInSegment(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        return permuteRowsInSegment(board, rowSeg: randomIndex(BOARD_SEGMENTS_NUMBER), permutation: generatePermutation(BOARD_SUB_SQURE_SIZE)! );
    }
    /**
    * Method applies randomly generated permutations of length 3 (permutation of 0, 1, 2)
    * to the 3 rows in a all row segments (9x3 each one) of Sudoku array. New permutation
    * is generated separately for each row segment.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned.
    *
    * @see SudokuStore#generatePermutation(int)
    */
    static func permuteRowsInAllSegments(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        let permutatedboard0 = permuteRowsInSegment(board, rowSeg: 0)
        let permutatedboard1 = permuteRowsInSegment(permutatedboard0, rowSeg: 1)
        let permutatedboard2 = permuteRowsInSegment(permutatedboard1, rowSeg: 2)
        return permutatedboard2

    }
    /**
    * Method applies given permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 columns in a given column segment (3x9 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @param    colSeg         Column segment id: 0, 1, 2.
    * @param    permutation    Permutation of length 3 (0, 1, 2)
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned. If permutation is not valid exact copy of
    *           Sudoku board is returned.
    *
    * @see SudokuStore#isValidPermutation(int[])
    * @see SudokuStore#generatePermutation(int)
    */
    static func permuteColsInSegment(sudokuBoard: [[Int]]?, colSeg: Int, permutation: [Int]) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        if !isValidPermutation(permutation, n: BOARD_SUB_SQURE_SIZE) {
            return boardCopy(board)
        }
        var permutatedBoard: [[Int]] = boardCopy(board)
        if colSeg < 0 || colSeg > 2 { return permutatedBoard }
        let segstart = boardSegmentStartIndex(colSeg)
        for j in 0..<BOARD_SUB_SQURE_SIZE {
            let curColIndex = segstart + permutation[j]
            let newColIndex = segstart + j
            for i in 0..<BOARD_SIZE {
                permutatedBoard[i][newColIndex] = board[i][curColIndex]
            }
        }

        return permutatedBoard;
    }
    /**
    * Method applies randomly generated permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 columns in a given column segment (3x9 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @param    colSeg         Column segment id: 0, 1, 2.
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned.
    *
    * @see SudokuStore#generatePermutation(int)
    */
    static func permuteColsInSegment(sudokuBoard: [[Int]]?, colSeg : Int) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        return permuteColsInSegment(board, colSeg: colSeg, permutation: generatePermutation(BOARD_SUB_SQURE_SIZE)! );
    }
    /**
    * Method applies randomly generated permutation of length 3 (permutation of 0, 1, 2)
    * to the 3 columns in a randomly selected column segment (3x9 each one) of Sudoku array.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned.
    *
    * @see SudokuStore#generatePermutation(int)
    */
    static func permuteColsInSegment(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        return permuteColsInSegment(board, colSeg: randomIndex(BOARD_SEGMENTS_NUMBER), permutation: generatePermutation(BOARD_SUB_SQURE_SIZE)! );
    }
    /**
    * Method applies randomly generated permutations of length 3 (permutation of 0, 1, 2)
    * to the 3 columns in a all column segments (9x3 each one) of Sudoku array. New permutation
    * is generated separately for each columns segment.
    *
    * @param    sudokuBoard    Array representing Sudoku board.
    * @return   New array resulting from permutation of given sudokuBoard. If sudokuBoard is null
    *           the null is returned.
    *
    * @see SudokuStore#generatePermutation(int)
    */
    static func permuteColsInAllSegments(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        let permutedboard0 = permuteColsInSegment(board, colSeg: 0)
        let permutedboard1 = permuteColsInSegment(permutedboard0, colSeg: 1)
        let permutedboard2 = permuteColsInSegment(permutedboard1, colSeg: 2)

        return permutedboard2
    }
    /*
    * ======================================================
    *                 Random transformations
    * ======================================================
    */
    /**
    * Based on the parameter value method applies
    * one of the following board transformation:
    * <ul>
    * <li>0 - {@link #rotateClockWise(int[][])}
    * <li>1 - {@link #rotateCounterclockWise(int[][])}
    * <li>2 - {@link #reflectHorizontally(int[][])}
    * <li>3 - {@link #reflectVertically(int[][])}
    * <li>4 - {@link #transposeTlBr(int[][])}
    * <li>5 - {@link #transposeTrBl(int[][])}
    * <li>6 - {@link #swapRowSegmentsRandomly(int[][])}
    * <li>7 - {@link #swapColSegmentsRandomly(int[][])}
    * <li>8 - {@link #swapRowsInSegmentRandomly(int[][])}
    * <li>9 - {@link #swapColsInSegmentRandomly(int[][])}
    * <li>10 - {@link #permuteBoard(int[][])}
    * <li>11 - {@link #permuteRowSegments(int[][])}
    * <li>12 - {@link #permuteColSegments(int[][])}
    * <li>13 - {@link #permuteRowsInSegment(int[][])}
    * <li>14 - {@link #permuteRowsInAllSegments(int[][])}
    * <li>15 - {@link #permuteColsInSegment(int[][])}
    * <li>16 - {@link #permuteColsInAllSegments(int[][])}
    * </ul>
    *
    * @param sudokuBoard   Sudoku board to be transformed
    * @param transfId      Random operation id between 0 and {@link #AVAILABLE_RND_BOARD_TRANSF}.
    * @return              Sudoku board resulting from transformation.
    */
    static func randomBoardTransf(sudokuBoard: [[Int]]?, transfId: Int) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        let rndtransf = randomIndex(AVAILABLE_RND_BOARD_TRANSF)
        switch rndtransf {

    case 0:  return rotateClockWise(board)
    case 1:  return rotateCounterclockWise(board)
    case 2:  return reflectHorizontally(board)
    case 3:  return reflectVertically(board)
    case 4:  return transposeTlBr(board)
    case 5:  return transposeTrBl(board)
    case 6:  return swapRowSegmentsRandomly(board)
    case 7:  return swapColSegmentsRandomly(board)
    case 8:  return swapRowsInSegmentRandomly(board)
    case 9:  return swapColsInSegmentRandomly(board)
    case 10: return permuteBoard(board)
    case 11: return permuteRowSegments(board)
    case 12: return permuteColSegments(board)
    case 13: return permuteRowsInSegment(board)
    case 14: return permuteRowsInAllSegments(board)
    case 15: return permuteColsInSegment(board)
    case 16: return permuteColsInAllSegments(board)
        default: return board
    }
    //return board
    }
    /**
    * Random board transformation of type selected randomly (typed randomly selected between
    * 0 and {@link #AVAILABLE_RND_BOARD_TRANSF}).
    *
    * @param sudokuBoard        Sudoku board to be transformed.
    * @return                   Sudoku board resulting from transformation.
    *
    * @see #randomBoardTransf(int[][], int)
    */
    static func randomBoardTransf(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        return randomBoardTransf(board, transfId: randomIndex(AVAILABLE_RND_BOARD_TRANSF))
    }
    /**
    * Applies to the Sudoku board sequence (of a given length) of transformations selected randomly
    * (each transformation selected randomly between 0 and {@link #AVAILABLE_RND_BOARD_TRANSF}).
    *
    * @param sudokuBoard       Sudoku board to be transformed.
    * @param seqLength         Length of sequence (positive)
    * @return                  Sudoku board resulting from transformations.
    *                          If seqLengh is lower than 1 then exact copy of
    *                          Sudoku board is returned.
    *
    * @see #randomBoardTransf(int[][], int)
    */
    static func seqOfRandomBoardTransf(sudokuBoard: [[Int]]?, seqLength: Int) -> [[Int]]? {
        guard let board = sudokuBoard else { return nil }
        if seqLength < 1 { return boardCopy(board) }
        var newBoard = boardCopy(board)
        for _ in 0..<seqLength {
            newBoard = randomBoardTransf(newBoard)!
        }
        return newBoard
    }
    /**
    * Applies to the Sudoku board sequence (of default length) of transformations selected randomly
    * (each transformation selected randomly between 0 and {@link #AVAILABLE_RND_BOARD_TRANSF}).
    * Invocation of {@link #seqOfRandomBoardTransf(int[][], int)} with sequence length
    * equal to {@link #DEFAULT_RND_TRANSF_SEQ_LENGTH}.
    *
    * @param sudokuBoard       Sudoku board to be transformed.
    * @return                  Sudoku board resulting from transformations.
    *                          If seqLengh is lower than 1 then exact copy of
    *                          Sudoku board is returned.
    *
    * @see #randomBoardTransf(int[][], int)
    */
    static func seqOfRandomBoardTransf(sudokuBoard: [[Int]]?) -> [[Int]]? {
        guard let board = sudokuBoard else {
            return nil
        }
        return seqOfRandomBoardTransf(board, seqLength: DEFAULT_RND_TRANSF_SEQ_LENGTH)
    }
    /*
    * ======================================================
    *              Random numbers generators
    *               Permutation generators
    * ======================================================
    */
    /**
    * Random number generator for n returning random number between 0, 1, ... n-1.
    *
    * @param     n    The parameter influencing random number generation process.
    * @return    Random number between 0, 1, ... n-1 if n is 1 or above, otherwise
    *            error {@link ErrorCodes#SUDOKUSTORE_RANDOMINDEX_INCORRECT_PARAMETER}
    *            is returned.
    */
    static func randomIndex(n: Int) -> Int {
        if (n < 0) {
            return SudokuErrorCodes.SUDOKUSTORE_RANDOMINDEX_INCORRECT_PARAMETER
        }
        return Int(floor(getRandomNumber() * Double(n)))
    }
    /**
    * Random number generator for n returning random number between 1, 2, ... n.
    *
    * @param     n    The parameter influencing random number generation process.
    * @return    Random number between 1, 2, ... n if n is 1 or above, otherwise
    *            error {@link ErrorCodes#SUDOKUSTORE_RANDOMINDEX_INCORRECT_PARAMETER}
    *            is returned.
    */
    static func randomNumber(n: Int) -> Int {
        if n < 1 {
            return SudokuErrorCodes.SUDOKUSTORE_RANDOMNUMBER_INCORRECT_PARAMETER
        }
        return Int(floor(getRandomNumber() * Double(n)) + 1)
    }
    
    
    static func getRandomNumber() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
    
    /**
    * 9x9 Sudoku board consist either 3 row segments (3x9 each one)
    * or 3 column segments (9x3 each one). Each segment has its own
    * starting index in Sudoku array representing Sudoku board.
    * For row segments starting index will be giving information
    * on first column, and for column segments starting index
    * shall be interpreted as first row in that segment.
    * All parameters and values start form 0, because they
    * are designed specifically for arrays.
    *
    * @param   segId    The segment id: 0, 1, 2
    * @return  0 for segment 0, 3 for segment 1, 6 for segment 2,
    *          otherwise {@link ErrorCodes#SUDOKUSTORE_BOARDSEGMENTSTARTINDEX_INCORRECT_SEGMENT}.
    */
    static func boardSegmentStartIndex(segId: Int) -> Int {
        if segId == 0 { return 0 }
        else if segId == 1 { return 3 }
        else if segId == 2 { return 6 }
        else { return SudokuErrorCodes.SUDOKUSTORE_BOARDSEGMENTSTARTINDEX_INCORRECT_SEGMENT }
    }
    /**
    * Permutation generator assuming permuting
    * 0, 1, ..., n-1 for n-length permutation.
    *
    * @param     n   The permutation length.
    * @return    If n &gt; 0 permutation array is returned
    *            containing n randomly distributed elements
    *            with values: 0, 1, ..., n-1. If n is zero or
    *            negative null is returned.
    */
    static func generatePermutation(n: Int) -> [Int]? {
    
        if n <= 0 { return nil}
        var permutation: [Int] = [Int]()
        for _ in 0..<n {
            permutation.append(0)
        }
        if n == 0 {
            permutation[0] = 0
            return permutation
        }
        for i in 0..<n {
            permutation[i] = i
            for j in 0..<n {
                let notpermuted = n - j
                let lastnotpermutedindex = notpermuted - 1
                let newindex = randomIndex(notpermuted)
                if newindex < lastnotpermutedindex {
                    let b = permutation[lastnotpermutedindex]
                    permutation[lastnotpermutedindex] = permutation[newindex]
                    permutation[newindex] = b
                }
            }
        }
        return permutation
    
    }
    /**
    * Checks whether given array of length n is representing
    * valid permutation of 0, 1, ..., n-1
    *
    * @param    permutation   Array representing permutation
    * @return   True if permutation is valid, false otherwise.
    */
    static func isValidPermutation(permutation: [Int]) -> Bool {
        let n = permutation.count
        if n == 0 {return false}
        var seq: [Int] = [Int]()
        for _ in 0..<n {
            seq.append(SudokuBoardCell.EMPTY)
        }
        for i in 0..<n {
            seq[i] = 0
            if permutation[i] < 0 || permutation[i] > n-1 {return false}
        }
        for i in 0..<n {
            seq[permutation[i]] = 1
        }
        var nPerm : Int = 0
        for i in 0..<n {
            nPerm += seq[i]
        }
        if nPerm == n {return true}
        return false
    }
    /**
    * Checks whether given array is representing
    * valid permutation of length n and form of 0, 1, ..., n-1
    *
    * @param    permutation   Array representing permutation.
    * @param    n             Assumed permutation length.
    * @return   True if permutation is valid, false otherwise.
    */
    static func isValidPermutation(permutation: [Int]?, n: Int) -> Bool {
        guard let p = permutation else {
            return false
        }
        if n <= 0 { return false }
        if p.count != n {return false }
        return isValidPermutation(p)
    }
    /*
    * ======================================================
    *             Other board methods
    * ======================================================
    */
    /**
    * Exact (1 to 1) copy of Sudoku board array.
    *
    * @param sudokuBoard     The board that will be copied.
    * @return                 New array containing exact copy of given Sudoku board.
    */
    static func boardCopy(sudokuBoard: [[Int]]) -> [[Int]] {
        /*
        guard let board = sudokuBoard else {
            return nil
        }
        */
        
        var newboard: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: SudokuBoardCell.EMPTY))
        
        for i in 0..<BOARD_SIZE {
            for j in 0..<BOARD_SIZE {
                newboard[i][j] = sudokuBoard[i][j]
            }
        }
        return newboard
    }
    /**
    * Checks whether boards are equal.
    * @param board1    First board.
    * @param board2    Second board.
    * @return          True if boards are equal, otherwise false
    *                  (false also for null boards or board having different sizes).
    */
    static func boardsAreEqual(board1: [[Int]]?, board2: [[Int]]?) -> Bool {
        guard let b1 = board1 else {
            return false
        }
        guard let b2 = board2 else {
            return false
        }
        if b1.count != b2.count {return false}
        if b1[0].count != b2[0].count {return false}
        for i in 0..<b1.count {
            for j in 0..<b1[0].count {
                if b1[i][j] != b2[i][j] { return false }
            }
        }
        return true
    }
    /*
    * ======================================================
    *           Board to string methods
    * ======================================================
    */
    /**
    * Returns string representation of the board.
    * @param  sudokuBoard     Array representing Sudoku puzzles.
    * @param  headComment     Comment to be added at the head.
    * @param  tailComment     Comment to be added at the tail.
    * @return Board (only) representation.
    */
    static func convBoardToString(sudokuBoard: [[Int]], headComment: String, tailComment: String) -> String {
        var boardStr: String = ""
        var oneLineDefDot: String = ""
        var oneLineDefZero: String = ""
        
        if headComment.characters.count > 0 {
            boardStr = boardStr + "# " + headComment + NEW_LINE_SEPARATOR + NEW_LINE_SEPARATOR
        }


        //if (sudokuBoard == null) return "NULL sudoku board.";
        boardStr = boardStr + "+-------+-------+-------+" + NEW_LINE_SEPARATOR;
        
        for i in 0..<SudokuBoard.BOARD_SIZE {
            if i > 0 && i < SudokuBoard.BOARD_SIZE && i % SudokuBoard.BOARD_SUB_SQURE_SIZE == 0 {
                boardStr = boardStr + "+-------+-------+-------+" + NEW_LINE_SEPARATOR
            }
            boardStr = boardStr + "| "
            for j in 0..<SudokuBoard.BOARD_SIZE {
                if j > 0 && j < SudokuBoard.BOARD_SIZE && j % SudokuBoard.BOARD_SUB_SQURE_SIZE == 0 {
                    boardStr = boardStr + "| "
                }
                if sudokuBoard[i][j] != SudokuBoardCell.EMPTY {
                    boardStr = boardStr + String(sudokuBoard[i][j]) + " "
                    oneLineDefDot = oneLineDefDot + String(sudokuBoard[i][j])
                    oneLineDefZero = oneLineDefZero + String(sudokuBoard[i][j])
                }
                else {
                    boardStr = boardStr + ". ";
                    oneLineDefDot = oneLineDefDot + ".";
                    oneLineDefZero = oneLineDefZero + "0";
                }
            }
            boardStr = boardStr + "|" + NEW_LINE_SEPARATOR
        }
        
        boardStr = boardStr + "+-------+-------+-------+" + NEW_LINE_SEPARATOR + NEW_LINE_SEPARATOR
        boardStr = boardStr + "# One line definition:" + NEW_LINE_SEPARATOR
        boardStr = boardStr + "# " + oneLineDefDot + NEW_LINE_SEPARATOR
        boardStr = boardStr + "# " + oneLineDefZero + NEW_LINE_SEPARATOR + NEW_LINE_SEPARATOR
    
        if tailComment.characters.count > 0 {
            boardStr = NEW_LINE_SEPARATOR + NEW_LINE_SEPARATOR + boardStr + "# " + tailComment
        }
        return boardStr
    }
    /**
    * Returns string representation of the board.
    * @param  sudokuBoard   Array representing Sudoku puzzles.
    * @return Board (only) representation.
    */
    static func boardToString(sudokuBoard: [[Int]]) -> String {
        return convBoardToString(sudokuBoard, headComment: "Sudoku puzzle", tailComment: JANET_SUDOKU_NAME + "-v." + SudokuStore.JANET_SUDOKU_VERSION + ", " + String(NSDate()))
    }
    /**
    * Returns string representation of the board + provided comment.
    * @param sudokuBoard     Sudoku board.
    * @param headComment     Comment to be added at the head.
    * @return                String representation of the sudoku board.
    */
    static func boardToString(sudokuBoard: [[Int]], headComment: String) -> String {
        return convBoardToString(sudokuBoard, headComment: headComment, tailComment: "")
    }
    /**
    * Returns string representation of the board + provided comment.
    * @param  sudokuBoard     Sudoku board.
    * @param  headComment     Comment to be added at the head.
    * @param  tailComment     Comment to be added at the tail.
    * @return                 String representation of the sudoku board.
    */
    static func boardToString(sudokuBoard: [[Int]], headComment: String, tailComment: String) -> String {
        return convBoardToString(sudokuBoard, headComment: headComment, tailComment: tailComment)
    }
    /**
    * Returns string representation of empty cells (only).
    * @param  emptyCells  Array representing empty cells of Sudoku puzzles.
    * @return Empty cells (only) string representation.
    */
    static func emptyCellsToString(emptyCells: [[Int]]) -> String {
        var boardStr: String = "Number of free digits" + NEW_LINE_SEPARATOR
        boardStr = boardStr + "=====================" + NEW_LINE_SEPARATOR
        
        for i in 0..<SudokuBoard.BOARD_SIZE {
            if i > 0 && i < SudokuBoard.BOARD_SIZE && i % SudokuBoard.BOARD_SUB_SQURE_SIZE == 0 {
                boardStr = boardStr + "---------------------" + NEW_LINE_SEPARATOR
            }
            for j in 0..<SudokuBoard.BOARD_SIZE {
                if ((j > 0) && (j < SudokuBoard.BOARD_SIZE) && (j % SudokuBoard.BOARD_SUB_SQURE_SIZE == 0)) {
                    boardStr = boardStr + "| "
                }
                if emptyCells[i][j] > 0 {
                    boardStr = boardStr + String(emptyCells[i][j]) + " "
                }
                else {
                    boardStr = boardStr + ". "
                }
            }
            boardStr = boardStr + NEW_LINE_SEPARATOR
        }
        
        boardStr = boardStr + "=====================" + NEW_LINE_SEPARATOR
        return boardStr
    }
    /**
    * Returns string representation of the board and empty cells.
    * @param  sudokuBoard   Array representing Sudoku puzzles.
    * @param  emptyCells    Array representing empty cells of Sudoku puzzles.
    * @return Board and empty cells representation.
    */
    static func boardAndEmptyCellsToString(sudokuBoard: [[Int]], emptyCells: [[Int]]) -> String {
        var boardStr: String = "    Sudoku board           Number of free digits" + NEW_LINE_SEPARATOR
        boardStr = boardStr + "=====================      =====================" + NEW_LINE_SEPARATOR
        for i in 0..<SudokuBoard.BOARD_SIZE {
            if ((i > 0) && (i < SudokuBoard.BOARD_SIZE) && (i % SudokuBoard.BOARD_SUB_SQURE_SIZE == 0)) {
				boardStr = boardStr + "---------------------      ---------------------" + NEW_LINE_SEPARATOR
            }
            for j in 0..<SudokuBoard.BOARD_SIZE {
                if ((j > 0) && (j < SudokuBoard.BOARD_SIZE) && (j % SudokuBoard.BOARD_SUB_SQURE_SIZE == 0)) {
                    boardStr = boardStr + "| "
                }
                if sudokuBoard[i][j] != SudokuBoardCell.EMPTY {
                    boardStr = boardStr + String(sudokuBoard[i][j]) + " "
                }
                else {
                    boardStr = boardStr + ". "
                }
            }
            boardStr = boardStr + "     ";
            for j in 0..<SudokuBoard.BOARD_SIZE {
                if ((j > 0) && (j < SudokuBoard.BOARD_SIZE) && (j % SudokuBoard.BOARD_SUB_SQURE_SIZE == 0)) {
                    boardStr = boardStr + "| "
                }
                if emptyCells[i][j] > 0 {
                    boardStr = boardStr + String(emptyCells[i][j]) + " "
                }
                else {
                    boardStr = boardStr + ". "
                }
            }
            boardStr = boardStr + NEW_LINE_SEPARATOR
        }
        boardStr = boardStr + "=====================      =====================" + NEW_LINE_SEPARATOR
        return boardStr
    }
    
    /**
    * Returns string representation of the 'path' leading to the solution.
    * @param solutionBoardCells  Array representing sequence of board cells.
    * @return                      String representation of sequence of board cells.
    */
    static func solutionPathToString(solutionBoardCells: [SudokuBoardCell]) -> String {
        var solutionPath: String = ""
        solutionPath = solutionPath + " --------------- " + NEW_LINE_SEPARATOR
        solutionPath = solutionPath + "| id | i, j | d |" + NEW_LINE_SEPARATOR
        solutionPath = solutionPath + "|----|----- |---|" + NEW_LINE_SEPARATOR
        for i in 0..<solutionBoardCells.count {
				let b = solutionBoardCells[i]
            if i + 1 < 10 {
                solutionPath = solutionPath + "|  "
            }
            else {
                solutionPath = solutionPath + "| "
            }
            solutionPath = solutionPath + String(i+1) + " | "
            solutionPath = solutionPath + String(b.rowIndex+1) + ", " + String(b.colIndex + 1) + " | "
            solutionPath = solutionPath + String(b.digit) + " |" + NEW_LINE_SEPARATOR
        }
        solutionPath = solutionPath + " --------------- " + NEW_LINE_SEPARATOR
        return solutionPath;
    
    }
    /**
    * Prints Sudoku board to the console.
    * @param sudokuBoard     Sudoku board to be printed
    */
    static func consolePrintBoard(sudokuBoard: [[Int]]) {
        print(boardToString(sudokuBoard));
    }
    /**
    * Prints object to the console.
    * @param o    Object to be printed.
    */
    static func consolePrintln(o: NSObject) {
        print("[" + JANET_SUDOKU_NAME + "-v." + SudokuStore.JANET_SUDOKU_VERSION + "] " + String(o));
    }
}
/*
* ======================================================
*     Package level classes
* ======================================================
*/
/**
* Digit random seed data type.
*/
class DigitRandomSeed {
    var digit: Int = 0
    var randomSeed: Double = 0
}
/**
* Package level class describing empty cell.
*/
class EmptyCell {
    /**
    * Empty cell id.
    */
    static let CELL_ID: Int = 0;
    /**
    * Empty cell row number.
    */
    var rowIndex: Int = 0
    /**
    * Empty cell column number.
    */
    var colIndex: Int = 0
    /**
    * List of digits than still can be used.
    */
    var digitsStillFree:[Int] = [Int]()
    /**
    * Random seed for randomized accessing digits still free.
    */
    var digitsRandomSeed:[DigitRandomSeed] = [DigitRandomSeed]()
    /**
    * Number of digits than still can be used.
    */
    var digitsStillFreeNumber: Int = 0
    /**
    * Random seed for randomized accessing empty cells.
    */
    var randomSeed: Double = 0
    /**
    * Default constructor.
    */
    init() {
        rowIndex = SudokuBoardCell.INDEX_NULL
        colIndex = SudokuBoardCell.INDEX_NULL
        var digitrandomseed: DigitRandomSeed!
        for i in 0..<SudokuBoard.BOARD_MAX_INDEX {
            digitrandomseed = DigitRandomSeed()
            digitrandomseed.digit = i
            digitrandomseed.randomSeed = Double(arc4random()) / Double(UINT32_MAX)
            digitsRandomSeed.append(digitrandomseed)
        }

    sortDigitsRandomSeed(1, r: SudokuBoard.BOARD_SIZE);
    randomSeed = Double(arc4random()) / Double(UINT32_MAX)
    setAllDigitsStillFree();
    }
    /**
    * Sorting digits  by random seed.
    *
    * @param l    Starting left index.
    * @param r    Starting right index.
    */
    private func sortDigitsRandomSeed(l: Int, r: Int) {
        var i: Int = l
        var j: Int = r
        var x: DigitRandomSeed!
        var w: DigitRandomSeed!

        x = digitsRandomSeed[(l+r)/2];
        while i <= j {
            while (digitsRandomSeed[i].randomSeed < x.randomSeed) {
				i++;
            }
            while (digitsRandomSeed[j].randomSeed > x.randomSeed) {
                j--
            }
            if (i<=j) {
				w = digitsRandomSeed[i];
				digitsRandomSeed[i] = digitsRandomSeed[j];
				digitsRandomSeed[j] = w;
				i++;
				j--;
            }
        }
        if l < j {
            sortDigitsRandomSeed(l,r: j)
        }
        if i < r {
            sortDigitsRandomSeed(i,r: r)
        }
    }
    /**
    * All digits are set that can be used in the specified filed
    * of the board.
    */
    func setAllDigitsStillFree() {
        digitsStillFree.removeAll()
        for _ in 0..<SudokuBoard.BOARD_MAX_INDEX {
            digitsStillFree.append(SudokuBoardCell.DIGIT_STILL_FREE)
        }
        digitsStillFreeNumber = 0;
    }
    
    func order() -> Int {
        return digitsStillFreeNumber
    }
    
    func orderPlusRndSeed() -> Double {
        return Double(digitsStillFreeNumber) + randomSeed
    }
}
/**
* Data type for sub-square definition
* on the Sudoku board.
*/
class SubSquare {
    /**
    * Left top - row index.
    */
    var rowMin: Int = 0
    /**
    * Right bottom - row index.
    */
    var rowMax: Int = 0
    /**
    * Left top - column index.
    */
    var colMin: Int = 0
    /**
    * Right bottom - column index.
    */
    var colMax: Int = 0
    /**
    * Sub-square identification on the Sudoku board
    * based on the cell position
    * @param emptyCell   Cell object, including cell position
    * @return             Sub-square left-top and right-bottom indexes.
    */
    static func getSubSqare(emptyCell: EmptyCell) -> SubSquare {
        return getSubSqare(emptyCell.rowIndex, colIndex: emptyCell.colIndex);
    }
    /**
    * Sub-square identification on the Sudoku board
    * based on the cell position
    * @param emptyCell   Cell object, including cell position
    * @return             Sub-square left-top and right-bottom indexes.
    */
    static func getSubSqare(boardCell: SudokuBoardCell) -> SubSquare {
        return getSubSqare(boardCell.rowIndex, colIndex: boardCell.colIndex);
    }
    /**
    * Sub-square identification on the Sudoku board
    * based on the cell position
    * @param rowIndex     Row index
    * @param colIndex     Column index
    * @return             Sub-square left-top and right-bottom indexes.
    */
    static func getSubSqare(rowIndex: Int, colIndex: Int) -> SubSquare {
        let sub = SubSquare()
        if (rowIndex < SudokuBoard.BOARD_SUB_SQURE_SIZE) {
            sub.rowMin = 0
            sub.rowMax = SudokuBoard.BOARD_SUB_SQURE_SIZE
        } else if (rowIndex < 2 * SudokuBoard.BOARD_SUB_SQURE_SIZE) {
            sub.rowMin = SudokuBoard.BOARD_SUB_SQURE_SIZE
            sub.rowMax = 2 * SudokuBoard.BOARD_SUB_SQURE_SIZE
        } else {
            sub.rowMin = 2 * SudokuBoard.BOARD_SUB_SQURE_SIZE
            sub.rowMax = 3 * SudokuBoard.BOARD_SUB_SQURE_SIZE
        }
        if (colIndex < SudokuBoard.BOARD_SUB_SQURE_SIZE) {
            sub.colMin = 0
            sub.colMax = SudokuBoard.BOARD_SUB_SQURE_SIZE
        } else if (colIndex < 2 * SudokuBoard.BOARD_SUB_SQURE_SIZE) {
            sub.colMin = SudokuBoard.BOARD_SUB_SQURE_SIZE
            sub.colMax = 2 * SudokuBoard.BOARD_SUB_SQURE_SIZE
        } else {
            sub.colMin = 2 * SudokuBoard.BOARD_SUB_SQURE_SIZE
            sub.colMax = 3 * SudokuBoard.BOARD_SUB_SQURE_SIZE
        }
        return sub
    }
}