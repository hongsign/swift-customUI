//
//  SudokuSolver.swift
//  Dev
//
//  Created by YU HONG on 2016-11-30.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation

class SudokuSolver {
    /**
    * Sudoku solving not initiated.
    */
    static let SOLVING_STATE_NOT_STARTED: Int = 1
    /**
    * Sudoku solving started.
    */
    static let SOLVING_STATE_STARTED: Int = 2;
    /**
    * Sudoku solving finished and successful.
    */
    static let SOLVING_STATE_SOLVED: Int = 3;
    /**
    * Solution does not exist.
    * @see #checkIfUniqueSolution()
    */
    static let SOLUTION_NOT_EXISTS: Int = -1;
    /**
    * Solution exists and is unique.
    * @see #checkIfUniqueSolution()
    */
    static let SOLUTION_UNIQUE: Int = 1;
    /**
    * Solution exists and is non-unique.
    * @see #checkIfUniqueSolution()
    */
    static let SOLUTION_NON_UNIQUE: Int = 2;
    /**
    * Message type normal.
    */
    static let MSG_INFO: Int = 1;
    /**
    * Message type error.
    */
    static let MSG_ERROR: Int = -1;
    /**
    * Sudoku board size.
    */
    static let BOARD_SIZE: Int = SudokuBoard.BOARD_SIZE;
    /**
    * Number of cells on the Sudoku board.
    */
    private static let BOARD_CELLS_NUMBER: Int = SudokuBoard.BOARD_CELLS_NUMBER;
    /**
    * Sudoku board was successfully loaded.
    */
    private static let BOARD_STATE_EMPTY: Int = SudokuBoard.BOARD_STATE_EMPTY;
    /**
    * Sudoku board was successfully loaded.
    */
    private static let BOARD_STATE_LOADED: Int = SudokuBoard.BOARD_STATE_LOADED;
    /**
    * Sudoku board is ready to start solving process.
    */
    private static let BOARD_STATE_READY: Int = SudokuBoard.BOARD_STATE_READY;
    /**
    * Sudoku board is ready to start solving process.
    */
    private static let BOARD_STATE_ERROR: Int = SudokuBoard.BOARD_STATE_ERROR;
    /**
    * Empty cell identifier.
    */
    private static let CELL_EMPTY: Int = SudokuBoardCell.EMPTY;
    /**
    * Marker if analyzed digit 0...9 is still not used.
    */
    private static let DIGIT_STILL_FREE: Int = SudokuBoardCell.DIGIT_STILL_FREE;
    /**
    * Digit 0...9 can not be used in that place.
    */
    private static let DIGIT_IN_USE: Int = SudokuBoardCell.DIGIT_IN_USE;
    /**
    * Cell is not pointing to any cells on the board.
    */
    private static let INDEX_NULL: Int = SudokuBoardCell.INDEX_NULL;
    /**
    * Sudoku board used while solving process.
    */
    var sudokuBoard: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: CELL_EMPTY))
    /**
    * Sudoku solution.
    */
    var solvedBoard: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: CELL_EMPTY))
    /**
    * Board backup for general internal purposes.
    */
    private var boardBackup: [[Int]] = [[Int]](count: BOARD_SIZE, repeatedValue: [Int](count: BOARD_SIZE, repeatedValue: CELL_EMPTY))
    /**
    * Path to the sudoku solution.
    */
    private var solutionPath: Stack<SudokuBoardCell> = Stack<SudokuBoardCell>()
    /**
    * All solutions list
    */
    private var solutionsList: Array<SudokuBoard> = Array<SudokuBoard>()
    /**
    * Solving status indicator.
    */
    private var boardState:Int = BOARD_STATE_EMPTY
    /**
    * Solving status indicator.
    */
    private var solvingState: Int = SudokuSolver.SOLVING_STATE_NOT_STARTED
    /**
    * Solving time in seconds.
    */
    private var computingTime: Double = 0
    /**
    * Step back counter showing how many different
    * routes were evaluated while solving.
    */
    private var closedPathsCounter: Int = 0
    /**
    * Total evaluated paths counter while finding all solutions.
    */
    private var totalPathsCounter: Int = 0
    /**
    * If yes then empty cells with the same number of
    * still free digits will be randomized.
    */
    private var randomizeEmptyCells: Bool = false
    /**
    * If yes then still free digits for a given empty cell
    * will be randomized.
    */
    private var randomizeFreeDigits: Bool = false
    /**
    * Empty cells on the Sudoku board
    */
    private var emptyCells: [EmptyCell] = [EmptyCell](count: BOARD_CELLS_NUMBER, repeatedValue: EmptyCell())
    /**
    * Pointers to the empty cells.
    */
    private var emptyCellsPointer: [[EmptyCell]] = [[EmptyCell]](count: BOARD_SIZE, repeatedValue: [EmptyCell](count: BOARD_SIZE, repeatedValue: EmptyCell()))
    /**
    * Number of empty cells on the Sudoku board.
    */
    private var emptyCellsNumber: Int = 0
    /**
    * Message from the solver.
    */
    private var messages: String = "";
    /**
    * Last message.
    */
    private var lastMessage: String = "";
    /**
    * Last error message.
    */
    private var lastErrorMessage: String = "";
    private var solutionNumber: Int = 0
    
    
    /*
    * =====================================================
    *                  Constructors
    * =====================================================
    */
    /**
    * Default constructor - only board initialization.
    */
    init() {
        clearPuzzels()
        randomizeEmptyCells = true
        randomizeFreeDigits = true
        findEmptyCells()
    }
    /**
    * Constructor - based on the Sudoku predefined example number.
    * @param exampleNumber  number of Sudoku example to load between 1
    * and {@link SudokuPuzzles#NUMBER_OF_PUZZLE_EXAMPLES}
    */
    init(exampleNumber: Int) {
        clearPuzzels()
        randomizeEmptyCells = true
        randomizeFreeDigits = true
        loadBoard(exampleNumber)
    }
    /**
    * Constructor - based on file path to the Sudoku definition.
    * @param filePath     Path to the sudoku definition.
    */
    init(filePath: String) {
        clearPuzzels()
        randomizeEmptyCells = true
        randomizeFreeDigits = true
        loadBoard(filePath)
    }
    /**
    * Constructor - based on file path to the Sudoku definition.
    * @param boardDefinition     Board definition (as array of strings,
    *                            each array entry as separate row).
    */
    init(boardDefinition: [String]) {
        clearPuzzels()
        randomizeEmptyCells = true
        randomizeFreeDigits = true
        loadBoard(sudokuBoard)
    }
    /**
    * Constructor - based on file path to the Sudoku definition.
    * @param boardDefinition     Board definition (as list of strings,
    *                            each list entry as separate row).
    *
    public SudokuSolver(ArrayList<String> boardDefinition) {
    clearPuzzels();
    randomizeEmptyCells = true;
    randomizeFreeDigits = true;
    loadBoard(boardDefinition);
    }
    */
    /**
    * Constructor - based on array representing Sudoku board.
    * @param sudokuBoard    9x9 array representing Sudoku board/
    */
    init(sudokuBoard: [[Int]]) {
        clearPuzzels();
        randomizeEmptyCells = true;
        randomizeFreeDigits = true;
        loadBoard(sudokuBoard)
    }
    /*
    * =====================================================
    *                  Loading methods
    * =====================================================
    */
    /**
    * Loads Sudoku example given by the parameter exampleNumber.
    *
    * @param exampleNumber  Number of predefined Sudoku example.
    * @return {@link ErrorCodes#SUDOKUSOLVER_LOADBOARD_LOADING_FAILED} or
    *         {@link SudokuBoard#BOARD_STATE_LOADED}.
    */
    func loadBoard(exampleNumber: Int) -> Int {
        if ((exampleNumber < 0) || (exampleNumber > SudokuStore.NUMBER_OF_PUZZLE_EXAMPLES)) {
            addMessage("(loadBoard) Loading failed - example number should be between 0 and " + String(SudokuStore.NUMBER_OF_PUZZLE_EXAMPLES-1), msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_LOADBOARD_LOADING_FAILED
        }
        if boardState != SudokuSolver.BOARD_STATE_EMPTY {
            clearPuzzels()
        }
        
        
        let loadedBoard = SudokuStore.getPuzzleExample(exampleNumber)
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
                sudokuBoard[i][j] = loadedBoard[i][j]
            }
        }
        boardState = SudokuSolver.BOARD_STATE_LOADED
        addMessage("(loadBoard) Sudoku example board " + String(exampleNumber) + " loaded", msgType: SudokuSolver.MSG_INFO);
        return findEmptyCells()
    }
    /**
    * Loads Sudoku from file.
    *
    * @param filePath File path that contains board definition.
    * @return {@link ErrorCodes#SUDOKUSOLVER_LOADBOARD_LOADING_FAILED} or
    *         {@link SudokuBoard#BOARD_STATE_LOADED}.
    */
    func loadBoard(filePath: String) -> Int {
        guard let loadedboard: [[Int]] = SudokuStore.loadBoard(filePath) else {
            addMessage("(loadBoard) Loading from file failed: " + filePath, msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_LOADBOARD_LOADING_FAILED
        }
        if boardState != SudokuSolver.BOARD_STATE_EMPTY {
            clearPuzzels()
        }
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
                sudokuBoard[i][j] = loadedboard[i][j]
            }
        }
        boardState = SudokuSolver.BOARD_STATE_LOADED
        addMessage("(loadBoard) Sudoku loaded, file: " + filePath, msgType: SudokuSolver.MSG_INFO)
        return findEmptyCells()
    }
    
    /**
    * Loads Sudoku from array of strings.
    *
    * @param boardDefinition  Board definition as array of strings
    *                        (each array entry as separate row).
    * @return {@link ErrorCodes#SUDOKUSOLVER_LOADBOARD_LOADING_FAILED} or
    *         {@link SudokuBoard#BOARD_STATE_LOADED}.
    */
    func loadBoard(boardDefinition: [String]) -> Int {
        
        guard let loadedboard: [[Int]] = SudokuStore.loadBoard(boardDefinition) else {
            addMessage("(loadBoard) Loading from array of strings failed.", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_LOADBOARD_LOADING_FAILED
        }
        
        if boardState != SudokuSolver.BOARD_STATE_EMPTY {
            clearPuzzels()
        }
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
				sudokuBoard[i][j] = loadedboard[i][j]
            }
        }
        boardState = SudokuSolver.BOARD_STATE_LOADED
        addMessage("(loadBoard) Sudoku loaded from array of strings. ", msgType: SudokuSolver.MSG_INFO)
        return findEmptyCells()
    }
    
    /**
    * Loads Sudoku from array of strings.
    *
    * @param boardDefinition  Board definition as list of strings
    *                        (each list entry as separate row).
    * @return {@link ErrorCodes#SUDOKUSOLVER_LOADBOARD_LOADING_FAILED} or
    *         {@link SudokuBoard#BOARD_STATE_LOADED}.
    *
    func loadBoard(boardDefinition: Array<String>) -> Int {
        guard let loadedboard: [[Int]] = SudokuStore.loadBoard(boardDefinition) else {
            addMessage("(loadBoard) Loading from list of strings failed.", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_LOADBOARD_LOADING_FAILED;
        }

        if boardState != SudokuSolver.BOARD_STATE_EMPTY {
            clearPuzzels()
        }
        
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
                sudokuBoard[i][j] = loadedboard[i][j]
            }
        }

        boardState = SudokuSolver.BOARD_STATE_LOADED
        addMessage("(loadBoard) Sudoku loaded from list of strings. ", msgType: SudokuSolver.MSG_INFO)
        return findEmptyCells()
    }
    */
    
    /**
    * Loads Sudoku from array.
    *
    * @param sudokuBoard Array representing Sudoku puzzles.
    * @return {@link ErrorCodes#SUDOKUSOLVER_LOADBOARD_LOADING_FAILED} or
    *         {@link SudokuBoard#BOARD_STATE_LOADED}.
    */
    func loadBoard(sudokuBoard: [[Int]]?) -> Int {
        
        guard let board = sudokuBoard else {
            addMessage("(loadBoard) Loading from array failed - null array!", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_LOADBOARD_LOADING_FAILED
        }
        
        if board.count != SudokuSolver.BOARD_SIZE {
            addMessage("(loadBoard) Loading from array failed - incorrect number of rows! " + String(board.count), msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_LOADBOARD_LOADING_FAILED
        }
        
        for i in 0..<board.count {
            if board[i].count != SudokuSolver.BOARD_SIZE {
				addMessage("(loadBoard) Loading from array failed - incorrect number of columns! " + String(board[i].count), msgType: SudokuSolver.MSG_ERROR)
				return SudokuErrorCodes.SUDOKUSOLVER_LOADBOARD_LOADING_FAILED;
            }
        }
        
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
                let d = board[i][j]
                if ( !( ((d >= 1) && (d <= 9)) || (d == SudokuSolver.CELL_EMPTY) ) )  {
                    addMessage("(loadBoard) Loading from array failed - incorrect digit: " + String(d), msgType: SudokuSolver.MSG_ERROR)
                    return SudokuErrorCodes.SUDOKUSOLVER_LOADBOARD_LOADING_FAILED
                }
            }
        }
        

        if (boardState != SudokuSolver.BOARD_STATE_EMPTY) {
            clearPuzzels()
        }
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
				self.sudokuBoard[i][j] = board[i][j]
            }
        }
        
        boardState = SudokuSolver.BOARD_STATE_LOADED
        addMessage("(loadBoard) Sudoku loaded from array!", msgType: SudokuSolver.MSG_INFO)
        return findEmptyCells()
    }
    
    /**
    * Saves board to the text file.
    *
    * @param filePath       Path to the file.
    * @return               True if saving was successful, otherwise false.
    *
    * @see SudokuStore#saveBoard(int[][], String)
    * @see SudokuStore#boardToString(int[][])
    */
    func saveBoard(filePath: String) -> Bool {
        let savingStatus = SudokuStore.saveBoard(sudokuBoard, filePath: filePath)
        if savingStatus {
            addMessage("(saveBoard) Saving successful, file: " + filePath, msgType: SudokuSolver.MSG_INFO)
        }
        else {
            addMessage("(saveBoard) Saving failed, file: " + filePath, msgType: SudokuSolver.MSG_ERROR)
        }
        return savingStatus
    }
    
    /**
    * Saves board to the text file.
    *
    * @param filePath       Path to the file.
    * @param headComment    Comment to be added at the head.
    * @return               True if saving was successful, otherwise false.
    *
    * @see SudokuStore#saveBoard(int[][], String, String)
    * @see SudokuStore#boardToString(int[][], String)
    */
    func saveBoard(filePath: String, headComment: String) -> Bool {
        let savingStatus = SudokuStore.saveBoard(sudokuBoard, filePath: filePath, headComment: headComment)
        if savingStatus {
            addMessage("(saveBoard) Saving successful, file: " + filePath, msgType: SudokuSolver.MSG_INFO)
        }
        else {
            addMessage("(saveBoard) Saving failed, file: " + filePath, msgType: SudokuSolver.MSG_ERROR)
        }
        return savingStatus
    }
    
    /**
    * Saves board to the text file.
    *
    * @param filePath       Path to the file.
    * @param headComment    Comment to be added at the head.
    * @param tailComment    Comment to be added at the tail.
    * @return               True if saving was successful, otherwise false.
    *
    * @see SudokuStore#saveBoard(int[][], String, String, String)
    * @see SudokuStore#boardToString(int[][], String, String)
    */
    func saveBoard(filePath: String, headComment: String, tailComment: String) -> Bool {
        let savingStatus = SudokuStore.saveBoard(sudokuBoard, filePath: filePath, headComment: headComment, tailComment: tailComment);
        if savingStatus {
            addMessage("(saveBoard) Saving successful, file: " + filePath, msgType: SudokuSolver.MSG_INFO)
        }
        else {
            addMessage("(saveBoard) Saving failed, file: " + filePath, msgType: SudokuSolver.MSG_ERROR)
        }
        return savingStatus
    }
    
    /**
    * Saves solved board to the text file.
    *
    * @param filePath       Path to the file.
    * @return               True if saving was successful, otherwise false.
    *
    * @see SudokuStore#saveBoard(int[][], String)
    * @see SudokuStore#boardToString(int[][])
    */
    func saveSolvedBoard(filePath: String) -> Bool {
        let savingStatus = SudokuStore.saveBoard(solvedBoard, filePath: filePath)
        if savingStatus {
            addMessage("(saveSolvedBoard) Saving successful, file: " + filePath, msgType: SudokuSolver.MSG_INFO)
        }
        else {
            addMessage("(saveSolvedBoard) Saving failed, file: " + filePath, msgType: SudokuSolver.MSG_ERROR)
        }
        return savingStatus
    }
    /**
    * Saves solved board to the text file.
    *
    * @param filePath       Path to the file.
    * @param headComment    Comment to be added at the head.
    * @return               True if saving was successful, otherwise false.
    *
    * @see SudokuStore#saveBoard(int[][], String, String)
    * @see SudokuStore#boardToString(int[][], String)
    */
    func saveSolvedBoard(filePath: String, headComment: String) -> Bool {
        let savingStatus = SudokuStore.saveBoard(solvedBoard, filePath: filePath, headComment: headComment)
        if savingStatus {
            addMessage("(saveSolvedBoard) Saving successful, file: " + filePath, msgType: SudokuSolver.MSG_INFO)
        }
        else {
            addMessage("(saveSolvedBoard) Saving failed, file: " + filePath, msgType: SudokuSolver.MSG_ERROR)
        }
        return savingStatus
    }
    
    /**
    * Saves solved board to the text file.
    *
    * @param filePath       Path to the file.
    * @param headComment    Comment to be added at the head.
    * @param tailComment    Comment to be added at the tail.
    * @return               True if saving was successful, otherwise false.
    *
    * @see SudokuStore#saveBoard(int[][], String, String, String)
    * @see SudokuStore#boardToString(int[][], String, String)
    */
    func saveSolvedBoard(filePath: String, headComment: String, tailComment: String) -> Bool {
        let savingStatus = SudokuStore.saveBoard(solvedBoard, filePath: filePath, headComment: headComment, tailComment: tailComment)
        if savingStatus {
            addMessage("(saveSolvedBoard) Saving successful, file: " + filePath, msgType: SudokuSolver.MSG_INFO)
        }
        else {
            addMessage("(saveSolvedBoard) Saving failed, file: " + filePath, msgType: SudokuSolver.MSG_ERROR)
        }
        return savingStatus;
    }
    
    /**
    * Manually set cell value.
    *
    * @param rowIndex   Cell row index between 0 and 8.
    * @param colIndex   Cell column index between 0 and 8.
    * @param digit      Cell digit between 1 and 9, or EMPTY_CELL.
    * @return           Number of empty cells that left if cell definition correct,
    *                   {@link ErrorCodes#SUDOKUSOLVER_SETCELL_INCORRECT_DEFINITION} otherwise.
    */
    func setCell(rowIndex: Int, colIndex: Int, digit: Int) -> Int {
        if rowIndex < 0 || rowIndex >= SudokuSolver.BOARD_SIZE {
            addMessage("(setCell) Incorrect row index - is: " + String(rowIndex) + ", should be between 0 and " + String(SudokuSolver.BOARD_SIZE) + ".", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_SETCELL_INCORRECT_DEFINITION
        }
        if colIndex < 0 || colIndex >= SudokuSolver.BOARD_SIZE {
            addMessage("(setCell) Incorrect colmn index - is: " + String(colIndex) + ", should be between 0 and " + String(SudokuSolver.BOARD_SIZE) + ".", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_SETCELL_INCORRECT_DEFINITION
        }
        if (digit < 1 || digit > 9) && (digit != SudokuSolver.CELL_EMPTY) {
            addMessage("(setCell) Incorrect digit definition - is: " + String(digit) + ", should be between 1 and 9, or " + String(SudokuSolver.CELL_EMPTY) + " for empty cell", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_SETCELL_INCORRECT_DEFINITION
        }
        sudokuBoard[rowIndex][colIndex] = digit
        return findEmptyCells()
    }
    
    /**
    * Returns cell digit from current Sudoku board.
    * @param rowIndex    Cell row index between 0 and 8.
    * @param colIndex    Cell column index between 0 and 8.
    * @return            Cell digit between 1 and 9, if cell empty
    *                    then {@link BoardCell#EMPTY}.
    *                    If indexes are out of range then error
    *                    {@link ErrorCodes#SUDOKUSOLVER_GETCELLDIGIT_INCORRECT_INDEX}
    *                    is returned.
    */
    func getCellDigit(rowIndex: Int, colIndex: Int) -> Int {
        if rowIndex < 0 || rowIndex >= SudokuSolver.BOARD_SIZE {
            addMessage("(getCellDigit) Incorrect row index - is: " + String(rowIndex) + ", should be between 0 and " + String(SudokuSolver.BOARD_SIZE) + ".", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_GETCELLDIGIT_INCORRECT_INDEX
        }
        if colIndex < 0 || colIndex >= SudokuSolver.BOARD_SIZE {
            addMessage("(getCellDigit) Incorrect colmn index - is: " + String(colIndex) + ", should be between 0 and " + String(SudokuSolver.BOARD_SIZE) + ".", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_GETCELLDIGIT_INCORRECT_INDEX
        }
        return sudokuBoard[rowIndex][colIndex]
    }
    /*
    * =====================================================
    *                  Solving methods
    * =====================================================
    */
    /**
    * Method starts solving procedure.
    * @return if board state is {@link SudokuBoard#BOARD_STATE_EMPTY} then {@link ErrorCodes#SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED},
    *         if board state is {@link SudokuBoard#BOARD_STATE_ERROR} then {@link ErrorCodes#SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED},
    *         if board state is {@link SudokuBoard#BOARD_STATE_LOADED} then {@link ErrorCodes#SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED},
    *         if board state is {@link SudokuBoard#BOARD_STATE_READY} then returns solving status:
    *              {@link SudokuSolver#SOLVING_STATE_SOLVED},
    *              {@link ErrorCodes#SUDOKUSOLVER_SOLVE_SOLVING_FAILED}.
    *
    */
    func solve() -> Int {
        switch boardState {
        case SudokuSolver.BOARD_STATE_EMPTY:
            addMessage("(solve) Nothing to solve - the board is empty!", msgType: SudokuSolver.MSG_ERROR)
            solvingState = SudokuSolver.SOLVING_STATE_NOT_STARTED
            return SudokuErrorCodes.SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED
        case SudokuSolver.BOARD_STATE_ERROR:
            addMessage("(solve) Can not start solving process - the board contains an error!", msgType: SudokuSolver.MSG_ERROR)
            solvingState = SudokuSolver.SOLVING_STATE_NOT_STARTED
            return SudokuErrorCodes.SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED
        case SudokuSolver.BOARD_STATE_LOADED:
            addMessage("(solve) Can not start solving process - the board is not ready!", msgType: SudokuSolver.MSG_ERROR)
            solvingState = SudokuSolver.SOLVING_STATE_NOT_STARTED
            return SudokuErrorCodes.SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED
        case SudokuSolver.BOARD_STATE_READY:
            addMessage("(solve) Starting solving process!", msgType: SudokuSolver.MSG_INFO)
            if randomizeEmptyCells {
				addMessage("(solve) >>> Will randomize empty cells if number of still free digits is the same.", msgType: SudokuSolver.MSG_INFO)
            }
            if randomizeFreeDigits {
				addMessage("(solve) >>> Will randomize still free digits for a given empty cell.", msgType: SudokuSolver.MSG_INFO)
            }
            solvingState = SudokuSolver.SOLVING_STATE_STARTED
            solutionPath = Stack<SudokuBoardCell>()
            backupCurrentBoard()
            let solvingStartTime = SudokuUtils.CurrentTimeMills()
            closedPathsCounter = 0
            solve(0)
            let solvingEndTime = SudokuUtils.CurrentTimeMills()
            computingTime = Double(solvingEndTime - solvingStartTime) / 1000.0
            if solvingState != SudokuSolver.SOLVING_STATE_SOLVED {
				solvingState = SudokuErrorCodes.SUDOKUSOLVER_SOLVE_SOLVING_FAILED
				boardState = SudokuSolver.BOARD_STATE_ERROR
				addMessage("(solve) Error while solving - no solutions found - setting board state as 'error' !!", msgType: SudokuSolver.MSG_ERROR)
            }
            else {
				addMessage("(solve) Sudoku solved !!! Cells solved: " + String(emptyCellsNumber) + " ... Closed routes: " + String(closedPathsCounter) + " ... solving time: " + String(computingTime) + " s.", msgType: SudokuSolver.MSG_INFO)
				emptyCellsNumber = 0
            }
            restoreBoardFromBackup()
            return solvingState
        default:
            addMessage("(solve) Can not start solving process - do not know why :-(. Please report bug!", msgType: SudokuSolver.MSG_ERROR)
            solvingState = SudokuSolver.SOLVING_STATE_NOT_STARTED
            return SudokuErrorCodes.SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED
        }
        
    }
    
    /**
    * Recursive process of Sudoku solving.
    * @param level     Level of recursive step.
    */
    private func solve(level: Int) {
        /**
        * Close route if solving process stopped
        */
        if solvingState != SudokuSolver.SOLVING_STATE_STARTED {
            return
        }
        /**
        * Check if solved
        */
        if (level == emptyCellsNumber) {
            solvingState = SudokuSolver.SOLVING_STATE_SOLVED
            solvedBoard = getBoardCopy()
            return
        }
        /**
        * If still other cells are empty, perform recursive steps.
        */
        let emptyCell = emptyCells[level]
        let digitsStillFreeNumber = emptyCell.digitsStillFreeNumber
        if digitsStillFreeNumber > 0 {
            var digitNum: Int = 0
            for digitIndex in 1..<10 {
				var digit = digitIndex
                if randomizeFreeDigits {
                    digit = emptyCell.digitsRandomSeed[digitIndex].digit
                }
				if (emptyCell.digitsStillFree[digit] == SudokuSolver.DIGIT_STILL_FREE) {
                    digitNum += 1
                    sudokuBoard[emptyCell.rowIndex][emptyCell.colIndex] = digit
                    if level + 1 < emptyCellsNumber - 1 {
                        sortEmptyCells(level+1, r: emptyCellsNumber-1)
                    }
                    solutionPath.push( SudokuBoardCell(rowIndex: emptyCell.rowIndex, colIndex: emptyCell.colIndex, digit: digit) )
                    updateDigitsStillFree(emptyCell)
                    solve(level + 1)
                    if solvingState == SudokuSolver.SOLVING_STATE_STARTED {
                        solutionPath.pop();
                        if (digitNum == digitsStillFreeNumber) {
                            sudokuBoard[emptyCell.rowIndex][emptyCell.colIndex] = SudokuSolver.CELL_EMPTY;
                            updateDigitsStillFree(emptyCell)
                            if (level < emptyCellsNumber - 1) {
                                sortEmptyCells(level, r: emptyCellsNumber-1)
                            }
                            closedPathsCounter += 1
                        }
                    }
                    else {
                        return
                    }
				}
            }
        }
        else {
            sudokuBoard[emptyCell.rowIndex][emptyCell.colIndex] = SudokuSolver.CELL_EMPTY;
            updateDigitsStillFree(emptyCell);
        }
    }
    /**
    * Method searching all solutions procedure.
    *
    * @return if board state is {@link SudokuBoard#BOARD_STATE_EMPTY} then {@link ErrorCodes#SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED},
    *         if board state is {@link SudokuBoard#BOARD_STATE_ERROR} then {@link ErrorCodes#SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED},
    *         if board state is {@link SudokuBoard#BOARD_STATE_LOADED} then {@link ErrorCodes#SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED},
    *         if board state is {@link SudokuBoard#BOARD_STATE_READY} then returns number of all solutions found.
    */
    func findAllSolutions() -> Int {
        switch boardState {
        case SudokuSolver.BOARD_STATE_EMPTY:
            addMessage("(findAllSolutions) Nothing to solve - the board is empty!", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED
        case SudokuSolver.BOARD_STATE_ERROR:
            addMessage("(findAllSolutions) Can not start solving process - the board contains an error!", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED
        case SudokuSolver.BOARD_STATE_LOADED:
            addMessage("(findAllSolutions) Can not start solving process - the board is not ready!", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_FINDALLSOLUTIONS_SEARCHING_NOT_STARTED
        case SudokuSolver.BOARD_STATE_READY:
            addMessage("(findAllSolutions) Starting solving process!", msgType: SudokuSolver.MSG_INFO)
            if randomizeEmptyCells {
				addMessage("(findAllSolutions) >>> Will randomize empty cells if number of still free digits is the same.", msgType: SudokuSolver.MSG_INFO)
            }
            if randomizeFreeDigits {
				addMessage("(findAllSolutions) >>> Will randomize still free digits for a given emptymsgType:  cell.", msgType: SudokuSolver.MSG_INFO)
            }
            solutionsList = Array<SudokuBoard>()
            backupCurrentBoard()
            let solvingStartTime = SudokuUtils.CurrentTimeMills()
            totalPathsCounter = 0
            findAllSolutions(0)
            let solvingEndTime = SudokuUtils.CurrentTimeMills()
            computingTime = Double(solvingEndTime - solvingStartTime) / 1000.0
            restoreBoardFromBackup()
            return solutionsList.count
        default:
            addMessage("(findAllSolutions) Can not start solving process - do not know why :-(", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_SOLVE_SOLVING_NOT_STARTED
        }
        
    }
    
    /**
    * Recursive process of searching all possible solutions.
    * @param level     Level of recursive step.
    */
    private func findAllSolutions(level: Int) {
        /*
        * Enter level.
        * Check if solved.
        */
        if level == emptyCellsNumber {
            let solution = SudokuBoard()
            solution.board = getBoardCopy()
            solution.pathNumber = totalPathsCounter
            solutionsList.append(solution)
            return
        }
        /*
        * If still other cells are empty, perform recursive steps.
        */
        let emptyCell = emptyCells[level]
        let digitsStillFreeNumber = emptyCell.digitsStillFreeNumber
        if digitsStillFreeNumber > 0 {
            var digitNum: Int = 0
            for digitIndex in 1..<10 {
                var digit: Int = digitIndex
                if randomizeFreeDigits {
                    digit = emptyCell.digitsRandomSeed[digitIndex].digit
                }
				if (emptyCell.digitsStillFree[digit] == SudokuSolver.DIGIT_STILL_FREE) {
                    digitNum += 1
                    sudokuBoard[emptyCell.rowIndex][emptyCell.colIndex] = digit
                    if (level + 1 < emptyCellsNumber - 1) {
                        sortEmptyCells(level+1, r: emptyCellsNumber-1)
                    }
                    updateDigitsStillFree(emptyCell)
                    findAllSolutions(level + 1)
                    if digitNum == digitsStillFreeNumber {
                        sudokuBoard[emptyCell.rowIndex][emptyCell.colIndex] = SudokuSolver.CELL_EMPTY
                        updateDigitsStillFree(emptyCell)
                        if level < emptyCellsNumber - 1 {
                            sortEmptyCells(level, r: emptyCellsNumber-1)
                        }
                        totalPathsCounter += 1
                    }
				}
            }
        }
        else {
            sudokuBoard[emptyCell.rowIndex][emptyCell.colIndex] = SudokuSolver.CELL_EMPTY
            updateDigitsStillFree(emptyCell)
        }
    }
    /**
    * Method searching all solutions procedure.
    *
    * @return if board state is {@link SudokuBoard#BOARD_STATE_EMPTY} then {@link ErrorCodes#SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED},
    *         if board state is {@link SudokuBoard#BOARD_STATE_ERROR} then {@link ErrorCodes#SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED},
    *         if board state is {@link SudokuBoard#BOARD_STATE_LOADED} then {@link ErrorCodes#SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED},
    *         if board state is {@link SudokuBoard#BOARD_STATE_READY} then returns {@link #SOLUTION_UNIQUE}, {@link #SOLUTION_NON_UNIQUE}, {@link #SOLUTION_NOT_EXISTS}.
    */
    func checkIfUniqueSolution() -> Int {
        switch boardState {
        case SudokuSolver.BOARD_STATE_EMPTY:
            addMessage("(checkIfUniqueSolution) Nothing to solve - the board is empty!", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED
        case SudokuSolver.BOARD_STATE_ERROR:
            addMessage("(checkIfUniqueSolution) Can not start solving process - the board contains an error!", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED
        case SudokuSolver.BOARD_STATE_LOADED:
            addMessage("(checkIfUniqueSolution) Can not start solving process - the board is not ready!", msgType: SudokuSolver.MSG_ERROR)
            return SudokuErrorCodes.SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED
        case SudokuSolver.BOARD_STATE_READY:
            addMessage("(checkIfUniqueSolution) Starting solving process!", msgType: SudokuSolver.MSG_INFO)
            if randomizeEmptyCells {
				addMessage("(checkIfUniqueSolution) >>> Will randomize empty cells if number of still free digits is the same.", msgType: SudokuSolver.MSG_INFO)
            }
            if randomizeFreeDigits {
				addMessage("(checkIfUniqueSolution) >>> Will randomize still free digits for a given empty cell.", msgType: SudokuSolver.MSG_INFO)
            }
            solutionNumber = 0
            backupCurrentBoard()
            let solvingStartTime: Int64 = SudokuUtils.CurrentTimeMills()
            totalPathsCounter = 0
            checkIfUniqueSolution(0)
            let solvingEndTime: Int64 = SudokuUtils.CurrentTimeMills()
            computingTime = Double(solvingEndTime - solvingStartTime) / 1000.0
            restoreBoardFromBackup()
            if solutionNumber == 1 {
				return SudokuSolver.SOLUTION_UNIQUE
            }
            else if solutionNumber == 2 {
				return SudokuSolver.SOLUTION_NON_UNIQUE
            }
            else {
				return SudokuSolver.SOLUTION_NOT_EXISTS
            }
        default:
            addMessage("(checkIfUniqueSolution) Can not start solving process - do not know why :-(", msgType: SudokuSolver.MSG_ERROR);
            return SudokuErrorCodes.SUDOKUSOLVER_CHECKIFUNIQUESOLUTION_CHECKING_NOT_STARTED
        }
        
    }
    
    /**
    * Recursive process of checking unique solution.
    * @param level     Level of recursive step.
    */
    private func checkIfUniqueSolution(level: Int) {
        if solutionNumber > 1 { return }
        /*
        * Enter level.
        * Check if solved.
        */
        if level == emptyCellsNumber {
            solutionNumber++
            return
        }
        
        /*
        * If still other cells are empty, perform recursive steps.
        */
        let emptyCell = emptyCells[level];
        let digitsStillFreeNumber = emptyCell.digitsStillFreeNumber
        if digitsStillFreeNumber > 0 {
            var digitNum: Int = 0
            for digitIndex in 1..<10 {
                var digit: Int = digitIndex
                if randomizeFreeDigits {
                    digit = emptyCell.digitsRandomSeed[digitIndex].digit
                }
				if emptyCell.digitsStillFree[digit] == SudokuSolver.DIGIT_STILL_FREE {
                    digitNum += 1
                    sudokuBoard[emptyCell.rowIndex][emptyCell.colIndex] = digit
                    if level + 1 < emptyCellsNumber - 1 {
                        sortEmptyCells(level+1, r: emptyCellsNumber-1)
                    }
                    updateDigitsStillFree(emptyCell)
                    checkIfUniqueSolution(level + 1)
                    if digitNum == digitsStillFreeNumber {
                        sudokuBoard[emptyCell.rowIndex][emptyCell.colIndex] = SudokuSolver.CELL_EMPTY
                        updateDigitsStillFree(emptyCell);
                        if (level < emptyCellsNumber - 1) {
                            sortEmptyCells(level, r: emptyCellsNumber-1)
                        }
                        totalPathsCounter++
                    }
				}
            }
        }
        else {
            sudokuBoard[emptyCell.rowIndex][emptyCell.colIndex] = SudokuSolver.CELL_EMPTY
            updateDigitsStillFree(emptyCell)
        }
    }
    
    /*
    * =====================================================
    *               Board related methods
    * =====================================================
    */
    /**
    * Perform current board backup
    */
    private func backupCurrentBoard() {
        boardBackup = getBoardCopy()
    }
    /**
    * Restore board state from backup
    */
    private func restoreBoardFromBackup() {
        
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
                sudokuBoard[i][j] = boardBackup[i][j]
            }
        }
        findEmptyCells()
    }
    /**
    * To clear the Sudoku board.
    */
    func clearPuzzels() {
        
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
                sudokuBoard[i][j] = SudokuSolver.CELL_EMPTY
                emptyCellsPointer[i][j] = EmptyCell()
            }
        }
        
        for i in 0..<SudokuSolver.BOARD_CELLS_NUMBER {
            emptyCells[i] = EmptyCell()
        }
        
        emptyCellsNumber = 0
        solvingState = SudokuSolver.SOLVING_STATE_NOT_STARTED
        boardState = SudokuSolver.BOARD_STATE_EMPTY
        solvedBoard.removeAll()
        solutionPath.removeAll()
        computingTime = 0
        closedPathsCounter = 0
        addMessage("(clearPuzzels) Clearing sudoku board - board is empty.", msgType: SudokuSolver.MSG_INFO)
        
    }
    
    /**
    * Reset empty cells
    */
    private func clearEmptyCells() {
        for i in 0..<SudokuSolver.BOARD_CELLS_NUMBER {
            emptyCells[i].rowIndex = SudokuSolver.INDEX_NULL
            emptyCells[i].colIndex = SudokuSolver.INDEX_NULL
            emptyCells[i].digitsStillFreeNumber = -1
        }
    }
    
    /**
    * Search and initialize list of empty cells.
    * @return    {@link SudokuBoard#BOARD_STATE_EMPTY}
    *            {@link SudokuBoard#BOARD_STATE_READY}
    *            {@link SudokuBoard#BOARD_STATE_ERROR}.
    */
    private func findEmptyCells() -> Int {
        clearEmptyCells()
        var emptyCellIndex: Int = 0
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
                if sudokuBoard[i][j] == SudokuSolver.CELL_EMPTY {
                    emptyCells[emptyCellIndex].rowIndex = i
                    emptyCells[emptyCellIndex].colIndex = j
                    emptyCellsPointer[i][j] = emptyCells[emptyCellIndex]
                    findDigitsStillFree(emptyCells[emptyCellIndex])
                    if emptyCells[emptyCellIndex].digitsStillFreeNumber == 0 {
                        addMessage("Cell empty, but no still free digit to fill in - cell: " + String(i) + ", " + String(j), msgType: SudokuSolver.MSG_ERROR)
                        return SudokuSolver.BOARD_STATE_ERROR
                    }
                    emptyCellIndex += 1
                }
            }
        }
        
        emptyCellsNumber = emptyCellIndex;
        addMessage("(findEmptyCells) Empty cells evaluated - number of cells to solve: " + String(emptyCellsNumber), msgType: SudokuSolver.MSG_INFO)
        if boardState == SudokuSolver.BOARD_STATE_EMPTY {
            addMessage("(findEmptyCells) Empty board - please fill some values.", msgType: SudokuSolver.MSG_INFO);
        }
        else if emptyCellsNumber > 0 {
            sortEmptyCells(0, r: emptyCellsNumber - 1);
            boardState = SudokuSolver.BOARD_STATE_READY;
        }
        else {
            if SudokuStore.checkSolvedBoard(sudokuBoard) {
				addMessage("(findEmptyCells) Puzzle already solved. Marking as solved, but no path leading to the solution.", msgType: SudokuSolver.MSG_INFO)
				boardState = SudokuSolver.BOARD_STATE_READY
				solvingState = SudokuSolver.SOLVING_STATE_SOLVED
				solvedBoard = SudokuStore.boardCopy(sudokuBoard)
            }
            else {
				addMessage("(findEmptyCells) No cells to solve + board error.", msgType: SudokuSolver.MSG_ERROR)
				boardState = SudokuSolver.BOARD_STATE_ERROR
				return SudokuSolver.BOARD_STATE_ERROR
            }
        }
    
        if !SudokuStore.checkPuzzle(sudokuBoard) {
            addMessage("(findEmptyCells) Board contains an abvious error - duplicated digits.", msgType: SudokuSolver.MSG_ERROR)
            boardState = SudokuSolver.BOARD_STATE_ERROR
            return SudokuSolver.BOARD_STATE_ERROR
        }
    
        return SudokuSolver.BOARD_STATE_READY
    }
    
    /**
    * Find digits that still can be used in a given empty cell.
    * @param emptyCell Empty cell to search still free digits for.
    */
    private func findDigitsStillFree(emptyCell: EmptyCell) {
        emptyCell.setAllDigitsStillFree()
        for j in 0..<SudokuSolver.BOARD_SIZE {
            let boarddigit = sudokuBoard[emptyCell.rowIndex][j]
            if boarddigit != SudokuSolver.CELL_EMPTY {
                emptyCell.digitsStillFree[boarddigit] = SudokuSolver.DIGIT_IN_USE
            }
        }
        for i in 0..<SudokuSolver.BOARD_SIZE {
            let boarddigit = sudokuBoard[i][emptyCell.colIndex]
            if boarddigit != SudokuSolver.CELL_EMPTY {
                emptyCell.digitsStillFree[boarddigit] = SudokuSolver.DIGIT_IN_USE
            }
        }
        
        let sub = SubSquare.getSubSqare(emptyCell)
        /*
        * Mark digits used in a sub-square.
        */
        for i in sub.rowMin..<sub.rowMax {
            for j in sub.colMin..<sub.colMax {
                let boarddigit = sudokuBoard[i][j]
                if boarddigit != SudokuSolver.CELL_EMPTY {
                    emptyCell.digitsStillFree[boarddigit] = SudokuSolver.DIGIT_IN_USE
                }
            }
        }
        
        /*
        * Find number of still free digits to use.
        */
        emptyCell.digitsStillFreeNumber = 0;
        for digit in 1..<10 {
            if emptyCell.digitsStillFree[digit] == SudokuSolver.DIGIT_STILL_FREE {
                emptyCell.digitsStillFreeNumber += 1
            }
        }
        
    }
    
    /**
    * Find digits that still can be used in a given empty cell.
    * @param emptyCell Empty cell to search still free digits for.
    */
    private func updateDigitsStillFree(emptyCell: EmptyCell) {
        
        for j in 0..<SudokuSolver.BOARD_SIZE {
            if sudokuBoard[emptyCell.rowIndex][j] == SudokuSolver.CELL_EMPTY {
                findDigitsStillFree(emptyCellsPointer[emptyCell.rowIndex][j])
            }
        }
        for i in 0..<SudokuSolver.BOARD_SIZE {
            if sudokuBoard[i][emptyCell.colIndex] == SudokuSolver.CELL_EMPTY {
                findDigitsStillFree(emptyCellsPointer[i][emptyCell.colIndex])
            }
        }
        let sub = SubSquare.getSubSqare(emptyCell)
        for i in sub.rowMin..<sub.rowMax {
            for j in sub.colMin..<sub.colMax {
                if sudokuBoard[i][j] == SudokuSolver.CELL_EMPTY {
                    findDigitsStillFree(emptyCellsPointer[i][j])
                }
            }
        }
        
        /*
        * Mark digits used in a sub-sqre
        */
        for i in sub.rowMin..<sub.rowMax {
            for j in sub.colMin..<sub.colMax {
                let boarddigit = sudokuBoard[i][j]
                if boarddigit != SudokuSolver.CELL_EMPTY {
                    emptyCell.digitsStillFree[boarddigit] = SudokuSolver.DIGIT_IN_USE
                }
            }
        }

        /*
        * Find number of still free digits to use.
        */
        emptyCell.digitsStillFreeNumber = 0
        for digit in 1..<10 {
            if emptyCell.digitsStillFree[digit] == SudokuSolver.DIGIT_STILL_FREE {
                emptyCell.digitsStillFreeNumber += 1
            }
        }
    }
    /**
    * Sorting empty cells list by ascending number of
    * still free digits left that can be used in a context
    * of a given empty cell.
    *
    * @param l    Starting left index.
    * @param r    Starting right index.
    */
    private func sortEmptyCells(l: Int, r: Int) {
        var i = l;
        var j = r;
        var x: EmptyCell!
        var w: EmptyCell!
        x = emptyCells[(l+r)/2];
        repeat {
            if randomizeEmptyCells == true {
				/*
                * Adding randomization
                */
                while ( emptyCells[i].orderPlusRndSeed() < x.orderPlusRndSeed() ) { i += 1 }
                while ( emptyCells[j].orderPlusRndSeed() > x.orderPlusRndSeed() ) { j -= 1 }
            }
            else {
				/*
                * No randomization
                */
                while ( emptyCells[i].order() < x.order() ) { i += 1 }
                while ( emptyCells[j].order() > x.order() ) { j -= 1 }
            }
            if (i<=j) {
				w = emptyCells[i]
				emptyCells[i] = emptyCells[j]
				emptyCells[j] = w;
				i += 1
				j -= 1
            }
        } while (i <= j)
        if l < j { sortEmptyCells(l,r: j) }
        if i < r { sortEmptyCells(i,r: r) }
    }
    /**
    * Message builder.
    * @param msg Message.
    */
    private func addMessage(msg: String, msgType: Int) {
        
        let vdt = "[" + SudokuStore.JANET_SUDOKU_NAME + "-v." + SudokuStore.JANET_SUDOKU_VERSION + "][" + String(NSDate()) + "]";
        var mt = "(msg)";
        if msgType == SudokuSolver.MSG_ERROR {
            mt = "(error)";
            lastErrorMessage = msg;
        }
        messages = messages + SudokuStore.NEW_LINE_SEPARATOR + vdt + mt + " " + msg;
        lastMessage = msg;
    }
    /**
    * Returns list of recorded messages.
    * @return List of recorded messages.
    */
    func getMessages() ->  String  {
        return messages
    }
    /**
    * Clears list of recorded messages.
    */
    func clearMessages() {
        messages = ""
    }
    /**
    * Gets last recorded message.
    * @return Last recorded message.
    */
    func getLastMessage() -> String {
        return lastMessage
    }
    /**
    * Gets last recorded error message.
    * @return Last recorded message.
    */
    func getLastErrorMessage() -> String {
        return lastErrorMessage
    }
    /**
    * Return current Sudou board state.
    * @return  {@link SudokuBoard#BOARD_STATE_READY} or
    *          {@link SudokuBoard#BOARD_STATE_EMPTY} or
    *          {@link SudokuBoard#BOARD_STATE_ERROR}.
    */
    func getBoardState() -> Int {
        return boardState
    }
    /**
    * Method for copy current board content
    * @return  Current copy of Sudoku board
    */
    func getBoardCopy() -> [[Int]] {
        return SudokuStore.boardCopy(sudokuBoard)
    }
    /**
    * Return current solving status.
    * @return  {@link SudokuSolver#SOLVING_STATE_NOT_STARTED} or
    *          {@link ErrorCodes#SUDOKUSOLVER_SOLVE_SOLVING_FAILED} or
    *          {@link SudokuSolver#SOLVING_STATE_SOLVED}.
    */
    func getSolvingState() -> Int {
        return solvingState
    }
    /**
    * Gets array representing Sudoku board.
    * @return Array representing Sudoku board.
    */
    func getBoard() -> [[Int]] {
        return sudokuBoard
    }
    /**
    * Gets array representing solved Sudoku board.
    * @return Array representing solved Sudoku board.
    */
    func getSolvedBoard() -> [[Int]]? {
        return solvedBoard
    }
    /**
    * Gets all solutions list evaluated by the findAllSolutions() method
    * @return  List of all found solutions
    * @see SudokuSolver#findAllSolutions()
    */
    func getAllSolutionsList() -> Array<SudokuBoard> {
        return solutionsList
    }
    /**
    * Gets array representing evaluated empty cells.
    * meaning number of still free digits possible.
    * @return Array representing evaluated empty cells.
    */
    func getEmptyCells() -> [[Int]] {
        
        if boardState == SudokuSolver.BOARD_STATE_EMPTY {
            return [[Int]](count: SudokuSolver.BOARD_SIZE, repeatedValue: [Int](count: SudokuSolver.BOARD_SIZE, repeatedValue: 9))
        }
        
        var emptycells = [[Int]](count: SudokuSolver.BOARD_SIZE, repeatedValue: [Int](count: SudokuSolver.BOARD_SIZE, repeatedValue: 0))
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
                if sudokuBoard[i][j] == SudokuSolver.CELL_EMPTY {
                    emptycells[i][j] = emptyCellsPointer[i][j].digitsStillFreeNumber
                }
            }
        }
        return emptycells
    
    }
    /**
    * Get all current board cells.
    * @return  Array of current board cells.
    */
    func getAllBoardCells() -> [SudokuBoardCell?] {
        var cells = [SudokuBoardCell?](count: SudokuSolver.BOARD_CELLS_NUMBER, repeatedValue: nil)
        var cellIndex: Int = 0
        
        for i in 0..<SudokuSolver.BOARD_SIZE {
            for j in 0..<SudokuSolver.BOARD_SIZE {
                cells[cellIndex] = SudokuBoardCell(rowIndex: i, colIndex: j, digit: sudokuBoard[i][j])
                cellIndex += 1
            }
        }
    
        return cells
    }
    /**
    * Return solution board cells keeping the solution
    * path order. If error was encountered while solving
    * path to the solution will be incomplete, but will show
    * where solving process was aborted.
    *
    * @return Array of board cells that lead to the solution (keeping
    *         the path order).
    */
    func getSolutionBoardCells() -> [SudokuBoardCell]? {
        //guard let path = solutionPath else { return nil }
        if solutionPath.count == 0 { return nil }
        return SudokuUtils.ToArray(solutionPath)
    }
    /**
    * Return solving time in seconds..
    * @return  Solvnig time in seconds.
    */
    func getComputingTime() -> Double {
        return computingTime
    }
    /**
    * Number of routes that were assessed, but lead to nothing
    * and required step back. The higher number to more computation was
    * performed while solving.
    * @return Number of closed routes while solving.
    */
    func getClosedRoutesNumber() -> Int {
        return closedPathsCounter
    }
    /**
    * By default random seed on empty cells is enabled. This parameter
    * affects solving process only. Random seed on
    * empty cells causes randomization on empty cells
    * within empty cells with the same number of still free digits.
    * Enabling extends ability to find different solutions, if exists.
    */
    func enableRndSeedOnEmptyCells() {
        randomizeEmptyCells = true
    }
    /**
    * By default random seed on empty cells is enabled. This parameter
    * affects solving process only. Random seed on
    * empty cells causes randomization on empty cells
    * within empty cells with the same number of still free digits.
    * Disabling limits ability to find different solutions, if exists.
    */
    func disableRndSeedOnEmptyCells() {
        randomizeEmptyCells = false
    }
    /**
    * By default random seed on free digits is enabled. This parameter
    * affects solving process only. Random seed on
    * free digits causes randomization on accessing free digits
    * for a given empty cells. Each free digits is a starting point
    * for a new recursive sub-path potentially leading to solution.
    * Enabling extends ability to find different solutions, if exists.
    */
    func enableRndSeedOnFreeDigits() {
        randomizeFreeDigits = true
    }
    /**
    * By default random seed on free digits is enabled. This parameter
    * affects solving process only. Random seed on
    * free digits causes randomization on accessing free digits
    * for a given empty cells. Each free digits is a starting point
    * for a new recursive sub-path potentially leading to solution.
    * Disabling limits ability to find different solutions, if exists.
    */
    func disableRndSeedOnFreeDigits() {
        randomizeFreeDigits = false
    }
    /**
    * Returns board state summary.
    * @return Board state summary as string.
    */
    private func boardStateToString() -> String {
        
        var boardStateStr: String = "Board: "
        switch boardState {
        case SudokuSolver.BOARD_STATE_EMPTY:
            boardStateStr = boardStateStr + "empty"
        case SudokuSolver.BOARD_STATE_ERROR:
            boardStateStr = boardStateStr + "error"
        case SudokuSolver.BOARD_STATE_LOADED:
            boardStateStr = boardStateStr + "loaded"
        case SudokuSolver.BOARD_STATE_READY:
            boardStateStr = boardStateStr + "ready"
        default: break
        }
        
        boardStateStr = boardStateStr + SudokuStore.NEW_LINE_SEPARATOR + "Initial empty cells: " + String(emptyCellsNumber)
        boardStateStr = boardStateStr + SudokuStore.NEW_LINE_SEPARATOR + "Solving : "
        
        
        
        switch solvingState  {
        case SudokuSolver.SOLVING_STATE_NOT_STARTED:
            boardStateStr = boardStateStr + "not started"
        case SudokuSolver.SOLVING_STATE_STARTED:
            boardStateStr = boardStateStr + "started"
        case SudokuSolver.SOLVING_STATE_SOLVED:
            boardStateStr = boardStateStr + "solved"
        case SudokuErrorCodes.SUDOKUSOLVER_SOLVE_SOLVING_FAILED:
            boardStateStr = boardStateStr + "failed"
        default: break
        }
        return boardStateStr
    }
    /**
    * Returns string board and empty cells representation.
    * @return Board and empty cells representation.
    */
    func boardAndEmptyCellsToString() -> String {
        return SudokuStore.boardAndEmptyCellsToString(sudokuBoard, emptyCells: getEmptyCells()) + boardStateToString() + SudokuStore.NEW_LINE_SEPARATOR
    }
    /**
    * Returns string board (only) representation.
    * @return Board (only) representation.
    */
    func boardToString() -> String {
        return SudokuStore.boardToString(sudokuBoard) + boardStateToString() + SudokuStore.NEW_LINE_SEPARATOR
    }
    /**
    * Returns string empty cells (only) representation.
    * @return Empty cells (only) representation.
    */
    func emptyCellsToString() -> String {
        return SudokuStore.emptyCellsToString( getEmptyCells() ) + boardStateToString() + SudokuStore.NEW_LINE_SEPARATOR
    }
    /**
    * Return string representation of cells that lead to
    * the solution, keeping the sequence.
    * @return  String representation of entries that lead to the solution.
    */
    func solutionPathToString() -> String {
        return SudokuStore.solutionPathToString( getSolutionBoardCells()! )
    }
}