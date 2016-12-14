//
//  SudokuGenerator.swift
//  Dev
//
//  Created by YU HONG on 2016-11-30.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation

class SudokuGenerator {
    /**
    * Indicator if generation should
    * start from randomly generated board.
    */
    //public static final char PARAM_GEN_RND_BOARD = '1';
    /**
    * Indicator showing that initial board should be solved
    * before generation process will be started.
    */
    //public static final char PARAM_DO_NOT_SOLVE = '2';
    /**
    * Indicator showing that initial board should not be
    * randomly transformed before generation process will be started.
    */
    //public static final char PARAM_DO_NOT_TRANSFORM = '3';
    /**
    * Indicator if generation should
    * start from randomly generated board.
    */
    private var generateRandomBoard: Bool = false
    /**
    * Indicator showing that initial board should not be
    * randomly transformed before generation process will be started.
    */
    private var transformBeforeGeneration: Bool = false
    /**
    * Indicator showing that initial board should be solved
    * before generation process will be started.
    */
    private var solveBeforeGeneration: Bool = false
    /**
    * Board size derived form SudokuBoard class.
    */
    //private static final int BOARD_SIZE = SudokuBoard.BOARD_SIZE;
    private let BOARD_SIZE: Int = 9
    /**
    * Board cells number derived form SudokuBoard class.
    */
    //private static final int BOARD_CELLS_NUMBER = SudokuBoard.BOARD_CELLS_NUMBER;
    private let BOARD_CELLS_NUMBER: Int = 81
    /**
    * Empty cell identifier.
    */
    //private static final int CELL_EMPTY = BoardCell.EMPTY;
    let CELL_EMPTY: Int = SudokuBoardCell.EMPTY
    /**
    * Marker if analyzed digit 0...9 is still not used.
    */
    //private static final int DIGIT_STILL_FREE = BoardCell.DIGIT_STILL_FREE;
    let DIGIT_STILL_FREE: Int = SudokuBoardCell.DIGIT_STILL_FREE
    /**
    * Digit 0...9 can not be used in that place.
    */
    //private static final int DIGIT_IN_USE = BoardCell.DIGIT_IN_USE;
    let DIGIT_IN_USE: Int = SudokuBoardCell.DIGIT_IN_USE
    /**
    * If yes then filled cells with the same impact will be randomized.
    */
    private var randomizeFilledCells: Bool = false
    /**
    * Initial board that will be a basis for
    * the generation process
    */
    //private int[][] sudokuBoard;
    var sudokuBoard: [[Int]]?
    /**
    * Board cells array
    */
    //private BoardCell[] boardCells;
    var boardCells: [SudokuBoardCell]?
    /**
    * Message type normal.
    */
    //private static final int MSG_INFO = 1;
    let MSG_INFO: Int = 1
    /**
    * Message type error.
    */
    //private static final int MSG_ERROR = -1;
    let MSG_ERROR: Int = -1
    /**
    * Message from the solver.
    */
    //private String messages = "";
    var messages: String = ""
    /**
    * Last message.
    */
    //private String lastMessage = "";
    var lastMessage: String = ""
    /**
    * Last error message.
    */
    //private String lastErrorMessage = "";
    var lastErrorMessage: String = ""
    /**
    * Solving time in seconds.
    */
    //private double computingTime;
    var computingTime: Double = 0
    /**
    * Generator state.
    *
    * @see #GENERATOR_INIT_STARTED
    * @see #GENERATOR_INIT_FINISHED
    * @see #GENERATOR_INIT_FAILED
    * @see #GENERATOR_GEN_NOT_STARTED
    * @see #GENERATOR_GEN_STARTED
    * @see #GENERATOR_GEN_STARTED
    * @see #GENERATOR_GEN_FAILED
    */
    //private int generatorState;
    var generatorState: Int = 0
    /**
    * Generator init started
    * @see #getGeneratorState()
    */
    //public static final int GENERATOR_INIT_STARTED = 1;
    let GENERATOR_INIT_STARTED: Int = 1
    /**
    * Generator init finished.
    * @see #getGeneratorState()
    */
    //public static final int GENERATOR_INIT_FINISHED = 2;
    let GENERATOR_INIT_FINISHED: Int = 2
    /**
    * Generator init failed.
    * @see #getGeneratorState()
    */
    //public static final int GENERATOR_INIT_FAILED = -1;
    let GENERATOR_INIT_FAILED: Int = -1
    /**
    * Generation process not started.
    * @see #getGeneratorState()
    */
    //public static final int GENERATOR_GEN_NOT_STARTED = -2;
    let GENERATOR_GEN_NOT_STARTED: Int = -2
    /**
    * Generation process started.
    * @see #getGeneratorState()
    */
    //public static final int GENERATOR_GEN_STARTED = 3;
    let GENERATOR_GEN_STARTED: Int = 3
    /**
    * Generation process finished.
    * @see #getGeneratorState()
    */
    //public static final int GENERATOR_GEN_FINISHED = 4;
    let GENERATOR_GEN_FINISHED: Int = 4
    /**
    * Generation process failed.
    * @see #getGeneratorState()
    */
    //public static final int GENERATOR_GEN_FAILED = -3;
    let GENERATOR_GEN_FAILED: Int = -3
    
    
    
    /**
    * Internal variables init for constructor.
    */
    private func initIntervalVars() {
        generatorState = GENERATOR_INIT_STARTED
        randomizeFilledCells = true
        computingTime = 0
    }
    
    /**
    * Set parameters provided by the user.
    *
    * @param parameters  parameters list
    * @see #PARAM_GEN_RND_BOARD
    * @see #PARAM_DO_NOT_SOLVE
    */
    private func setParameters(generaterandomboard: Bool?=false, solvebeforegeneration: Bool?=true, transformbeforegeneration: Bool?=true) {
        
        let randomboard = generaterandomboard ?? false
        let solve = solvebeforegeneration ?? true
        let transform = transformbeforegeneration ?? true
        
        
        generateRandomBoard = randomboard
        solveBeforeGeneration = solve
        transformBeforeGeneration = transform
        
    }
    
    /**
    * Board initialization method.
    * @param initBoard        Initial board.
    * @param info             The string to pass to the msg builder.
    */
    private func boardInit(initBoard: [[Int]]?, info: String) {
        var puzzle: SudokuSolver?
        
        guard let board = initBoard else {
            if generateRandomBoard {
                puzzle = SudokuSolver(sudokuBoard: SudokuPuzzles.PUZZLE_EMPTY)
                puzzle!.solve()
                if (puzzle!.getSolvingState() == SudokuSolver.SOLVING_STATE_SOLVED) {
                    sudokuBoard = puzzle!.solvedBoard
                    addMessage("(SudokuGenerator) Generator initialized using random board (" + info + ").", msgType: MSG_INFO)
                    generatorState = GENERATOR_INIT_FINISHED
                    return
                } else {
                    addMessage("(SudokuGenerator) Generator initialization using random board (" + info + ") failed. Board with error?", msgType: MSG_ERROR)
                    addMessage(puzzle!.getLastErrorMessage(), msgType: MSG_ERROR)
                    generatorState = GENERATOR_INIT_FAILED
                    return
                }
            }
            return
        }
        
        if (SudokuStore.checkPuzzle(board) == false) {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator initialization (" + info + ") failed. Board with error?", msgType: MSG_ERROR)
            return
        }
        if (solveBeforeGeneration == true) {
            puzzle = SudokuSolver(sudokuBoard: board)
            puzzle!.solve()
            if (puzzle!.getSolvingState() == SudokuSolver.SOLVING_STATE_SOLVED) {
				sudokuBoard = puzzle!.solvedBoard
				addMessage("(SudokuGenerator) Generator initialized usign provided board + finding solution (" + info + ").", msgType: MSG_INFO)
				generatorState = GENERATOR_INIT_FINISHED
				return
            } else {
				addMessage("(SudokuGenerator) Generator initialization usign provided board + finding solution (" + info + ") failed. Board with error?", msgType: MSG_ERROR)
				addMessage(puzzle!.getLastErrorMessage(),msgType:  MSG_ERROR)
				generatorState = GENERATOR_INIT_FAILED
				return
            }
        }
        puzzle = SudokuSolver(sudokuBoard: board)
        if (puzzle!.checkIfUniqueSolution() == SudokuSolver.SOLUTION_UNIQUE) {
            sudokuBoard = board
            addMessage("(SudokuGenerator) Generator initialized usign provided board (" + info + ").", msgType: MSG_INFO)
            generatorState = GENERATOR_INIT_FINISHED
            return
        } else {
            addMessage("(SudokuGenerator) Generator initialization usign provided board (" + info + ") failed. Solution not exists or is non unique.", msgType: MSG_ERROR)
            addMessage(puzzle!.getLastErrorMessage(), msgType: MSG_ERROR)
            generatorState = GENERATOR_INIT_FAILED
            return
        }
    }
    
    /**
    * Default constructor based on random Sudoku puzzle example.
    *
    * @param parameters      Optional parameters.
    *
    * @see #PARAM_DO_NOT_SOLVE
    * @see #PARAM_DO_NOT_TRANSFORM
    * @see #PARAM_GEN_RND_BOARD
    */
    init(generaterandomboard: Bool?=false, solvebeforegeneration: Bool?=true, transformbeforegeneration: Bool?=true) {
        setParameters(generaterandomboard, solvebeforegeneration: solvebeforegeneration, transformbeforegeneration: transformbeforegeneration)
        initIntervalVars()
        //var b: [[Int]]?
        if (generateRandomBoard == true) {
            boardInit(nil, info: "random board")
        } else {
            let example = SudokuStore.randomIndex( SudokuPuzzles.NUMBER_OF_PUZZLE_EXAMPLES )
            let board = SudokuStore.boardCopy( SudokuStore.getPuzzleExample(example) )
            if (transformBeforeGeneration == true) {
				boardInit(SudokuStore.seqOfRandomBoardTransf(board), info: "transformed example: " + String(example))
            }
            else {
				boardInit(board, info: "example: " + String(example))
            }
        }
    }
    /**
    * Default constructor based on puzzle example.
    *
    * @param example         Example number between 0 and {@link SudokuPuzzles#NUMBER_OF_PUZZLE_EXAMPLES}.
    * @param parameters      Optional parameters.
    *
    * @see #PARAM_DO_NOT_SOLVE
    * @see #PARAM_DO_NOT_TRANSFORM
    * @see #PARAM_GEN_RND_BOARD
    */
    init(example: Int, generaterandomboard: Bool?=false, solvebeforegeneration: Bool?=true, transformbeforegeneration: Bool?=true) {
        setParameters(generaterandomboard, solvebeforegeneration: solvebeforegeneration, transformbeforegeneration: transformbeforegeneration)
        initIntervalVars()
        if ( (example >= 0) && (example < SudokuPuzzles.NUMBER_OF_PUZZLE_EXAMPLES) ) {
            let board: [[Int]] = SudokuStore.boardCopy( SudokuStore.getPuzzleExample(example) )
            if (transformBeforeGeneration == true) {
				boardInit(SudokuStore.seqOfRandomBoardTransf(board)!, info: "transformed example: " + String(example))
            }
            else {
                boardInit(board, info: "example: " + String(example))
            }
        }
        else {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator not initialized incorrect example number: " + String(example) + " - should be between 1 and " + String(SudokuPuzzles.NUMBER_OF_PUZZLE_EXAMPLES) + ".", msgType: MSG_ERROR)
        }
    }
    
    /**
    * Default constructor based on provided initial board.
    *
    * @param initialBoard    Array with the board definition.
    * @param parameters      Optional parameters
    *
    * @see #PARAM_DO_NOT_SOLVE
    * @see #PARAM_DO_NOT_TRANSFORM
    * @see #PARAM_GEN_RND_BOARD
    */
    init(initialBoard: [[Int]]?, generaterandomboard: Bool?=false, solvebeforegeneration: Bool?=true, transformbeforegeneration: Bool?=true) {
        setParameters(generaterandomboard, solvebeforegeneration: solvebeforegeneration, transformbeforegeneration: transformbeforegeneration)
        initIntervalVars()
        guard let board = initialBoard else {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator not initialized - null initial board.", msgType: MSG_ERROR)
            return
        }
        if (board.count != BOARD_SIZE) {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator not initialized - incorrect number of rows in initial board, is: " + String(board.count) + ",  expected: " + String(BOARD_SIZE) + ".", msgType: MSG_ERROR)
        } else if (board[0].count != BOARD_SIZE) {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator not initialized - incorrect number of columns in initial board, is: " + String(board[0].count) + ", expected: " + String(BOARD_SIZE) + ".", msgType: MSG_ERROR)
        } else if (SudokuStore.checkPuzzle(board) == false) {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator not initialized - initial board contains an error.", msgType: MSG_ERROR)
        } else {
            let b:[[Int]] = SudokuStore.boardCopy(board)
            if (transformBeforeGeneration == true) {
				boardInit( SudokuStore.seqOfRandomBoardTransf(b)!, info: "transformed board provided by the user")
            }
            else {
                boardInit(b, info: "board provided by the user")
            }
        }
    }
    /**
    * Constructor based on the sudoku board
    * provided in text file.
    *
    * @param boardFilePath   Path to the board definition.
    * @param parameters      Optional parameters
    *
    * @see #PARAM_DO_NOT_SOLVE
    * @see #PARAM_DO_NOT_TRANSFORM
    * @see #PARAM_GEN_RND_BOARD
    */
    init(boardFilePath: String?, generaterandomboard: Bool?=false, solvebeforegeneration: Bool?=true, transformbeforegeneration: Bool?=true) {
        setParameters(generaterandomboard, solvebeforegeneration: solvebeforegeneration, transformbeforegeneration: transformbeforegeneration)
        initIntervalVars()
        guard let path = boardFilePath else {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator not initialized - null board file path.", msgType: MSG_ERROR)
            return
        }
        if (path.characters.count == 0) {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator not initialized - blank board file path.", msgType: MSG_ERROR)
        }
        else {
            let board = SudokuStore.loadBoard(path)
            if (transformBeforeGeneration == true) {
				boardInit( SudokuStore.seqOfRandomBoardTransf(board)!, info: "transformed board provided by the user")
            }
            else {
				boardInit(board!,info:  "board provided by the user")
            }
        }
    }
    
    /**
    * Constructor based on the sudoku board
    * provided array of strings.
    *
    * @param boardDefinition  Board definition as array of strings
    *                        (each array entry as separate row).
    * @param parameters        Optional parameters
    *
    * @see #PARAM_DO_NOT_SOLVE
    * @see #PARAM_DO_NOT_TRANSFORM
    * @see #PARAM_GEN_RND_BOARD
    *
    func SudokuGenerator(String[] boardDefinition, char... parameters) {
    setParameters(parameters);
    initInternalVars();
    if (boardDefinition == null) {
    generatorState = GENERATOR_INIT_FAILED;
    addMessage("(SudokuGenerator) Generator not initialized - null board definition.", MSG_ERROR);
    } else if (boardDefinition.length == 0) {
    generatorState = GENERATOR_INIT_FAILED;
    addMessage("(SudokuGenerator) Generator not initialized - blank board definition.", MSG_ERROR);
    } else {
    int[][] board = SudokuStore.loadBoard(boardDefinition);
    if (transformBeforeGeneration == true)
				boardInit( SudokuStore.seqOfRandomBoardTransf(board), "transformed board provided by the user");
    else
				boardInit(board, "board provided by the user");
    }
    }
    */
    
    /**
    * Constructor based on the sudoku board
    * provided list of strings.
    *
    * @param boardDefinition  Board definition as list of strings
    *                         (each list entry as separate row).
    * @param parameters       Optional parameters
    *
    * @see #PARAM_DO_NOT_SOLVE
    * @see #PARAM_DO_NOT_TRANSFORM
    * @see #PARAM_GEN_RND_BOARD
    */
    init(boardDefinition: Array<String>?, generaterandomboard: Bool?=false, solvebeforegeneration: Bool?=true, transformbeforegeneration: Bool?=true) {
        setParameters(generaterandomboard, solvebeforegeneration: solvebeforegeneration, transformbeforegeneration: transformbeforegeneration)
        initIntervalVars()
        guard let bd = boardDefinition else {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator not initialized - null board definition.", msgType: MSG_ERROR)
            return
        }
        if (bd.count == 0) {
            generatorState = GENERATOR_INIT_FAILED
            addMessage("(SudokuGenerator) Generator not initialized - blank board definition.", msgType: MSG_ERROR)
        }
        else {
            let board = SudokuStore.loadBoard(bd)
            if (transformBeforeGeneration == true) {
				boardInit( SudokuStore.seqOfRandomBoardTransf(board)!, info: "transformed board provided by the user")
            }
            else {
				boardInit(board, info: "board provided by the user")
            }
        }
    }
    /**
    * Sudoku puzzle generator.
    *
    * @return   Sudoku puzzle if process finished correctly, otherwise null.
    */
    func generate() -> [[Int]]? {
        if (generatorState != GENERATOR_INIT_FINISHED) {
            generatorState = GENERATOR_GEN_NOT_STARTED
            addMessage("(SudokuGenerator) Generation process not started due to incorrect initialization.", msgType: MSG_ERROR)
            return nil
        }
        let solvingStartTime = SudokuUtils.CurrentTimeMills()
        generatorState = GENERATOR_GEN_STARTED
        addMessage("(SudokuGenerator) Generation process started.", msgType: MSG_INFO);
        if randomizeFilledCells {
            addMessage("(SudokuGenerator) >>> Will randomize filled cells within cells with the same impact.", msgType: MSG_INFO)
        }
        boardCells = [SudokuBoardCell](count: BOARD_CELLS_NUMBER, repeatedValue: SudokuBoardCell())
        
        var cellIndex = 0
        for i in 0..<BOARD_SIZE {
            for j in 0..<BOARD_SIZE {
                let d = sudokuBoard?[i][j]
                if (d != CELL_EMPTY) {
                    boardCells![cellIndex].set(i,colIndex: j,digit: d!)
                    cellIndex += 1
                }
            }
        }
        var filledCells = cellIndex
        for i in 0..<BOARD_SIZE {
            for j in 0..<BOARD_SIZE {
                let d = sudokuBoard?[i][j]
                if (d == CELL_EMPTY) {
                    boardCells![cellIndex].set(i, colIndex: j, digit: d!)
                    cellIndex += 1
                }
            }
        }
        updateDigitsStillFreeCounts()
        sortBoardCells(0,r: filledCells-1)
        repeat {
            let r = 0
            let i = boardCells![r].rowIndex
            let j = boardCells![r].colIndex
            let d = sudokuBoard![i][j]
            sudokuBoard![i][j] = CELL_EMPTY
            let s = SudokuSolver(sudokuBoard: sudokuBoard!)
            if (s.checkIfUniqueSolution() != SudokuSolver.SOLUTION_UNIQUE) {
				sudokuBoard![i][j] = d
            }
            let lastIndex = filledCells-1
            if (r < lastIndex) {
				let b1 = boardCells![r]
				let b2 = boardCells![lastIndex]
				boardCells![lastIndex] = b1
				boardCells![r] = b2
            }
            filledCells -= 1
            updateDigitsStillFreeCounts()
            if (filledCells > 0) { sortBoardCells(0,r: filledCells-1) }
        } while (filledCells > 0)
        let solvingEndTime = SudokuUtils.CurrentTimeMills()
        computingTime = Double(solvingEndTime - solvingStartTime) / 1000.0
        generatorState = GENERATOR_GEN_FINISHED
        addMessage("(SudokuGenerator) Generation process finished, computing time: " + String(computingTime) + " s.", msgType: MSG_INFO)
        return sudokuBoard
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
        let savingStatus = SudokuStore.saveBoard(sudokuBoard!, filePath: filePath)
        if savingStatus {
            addMessage("(saveBoard) Saving successful, file: " + filePath, msgType: MSG_INFO)
        }
        else {
            addMessage("(saveBoard) Saving failed, file: " + filePath, msgType: MSG_ERROR)
        }
        return savingStatus;
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
        let savingStatus = SudokuStore.saveBoard(sudokuBoard!, filePath: filePath, headComment: headComment)
        if savingStatus {
            addMessage("(saveBoard) Saving successful, file: " + filePath, msgType: MSG_INFO)
        }
        else {
            addMessage("(saveBoard) Saving failed, file: " + filePath, msgType: MSG_ERROR)
        }
    return savingStatus;
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
        let savingStatus = SudokuStore.saveBoard(sudokuBoard!, filePath: filePath, headComment: headComment, tailComment: tailComment)
        
        if savingStatus {
            addMessage("(saveBoard) Saving successful, file: " + filePath, msgType: MSG_INFO)
        }
        else {
            addMessage("(saveBoard) Saving failed, file: " + filePath, msgType: MSG_ERROR)
        }
            return savingStatus;
    }
    /**
    * Updating digits still free for a specific cell
    * while generating process.
    */
    private func updateDigitsStillFreeCounts() {
        for i in 0..<BOARD_CELLS_NUMBER {
            countDigitsStillFree((boardCells?[i])!)
        }
    }
    /**
    * Counts number of digits still free
    * for a specific cell.
    *
    * @param boardCell
    */
    private func countDigitsStillFree(boardCell: SudokuBoardCell) {
        var digitsStillFree : [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var emptyCellsNumber: Int = 0
        
        for j in 0..<BOARD_SIZE {
            let boardDigit = sudokuBoard?[boardCell.rowIndex][j]
            if boardDigit != CELL_EMPTY {
                digitsStillFree[boardDigit!] = DIGIT_IN_USE
            }
            else {
                if j != boardCell.colIndex {
                    emptyCellsNumber += 1
                }
            }
        }
        for i in 0..<BOARD_SIZE {
            let boardDigit = sudokuBoard?[i][boardCell.colIndex]
            if boardDigit != CELL_EMPTY {
                digitsStillFree[boardDigit!] = DIGIT_IN_USE
            }
            else {
                if i != boardCell.rowIndex {
                    emptyCellsNumber += 1
                }
            }
        }
        
        let sub: SubSquare = SubSquare.getSubSqare(boardCell)
    
        /*
        * Mark digits used in a sub-square.
        */
        for i in sub.rowMin..<sub.rowMax {
            for j in sub.colMin..<sub.colMax {
                let boardDigit = sudokuBoard?[i][j]
                if boardDigit != CELL_EMPTY {
                    digitsStillFree[boardDigit!] = DIGIT_IN_USE
                }
                else if ((i != boardCell.rowIndex) && (j != boardCell.colIndex)) {
                    emptyCellsNumber += 1
                }
            }
        }
        
        /*
        * Find number of still free digits to use.
        */
        digitsStillFree[boardCell.digit] = 0
        boardCell.digitsStillFreeNumber = emptyCellsNumber
        for digit in 1..<10 {
            if (digitsStillFree[digit] == DIGIT_STILL_FREE) {
				boardCell.digitsStillFreeNumber += 1
            }
        }
    }
    /**
    * Sorting board cells
    * @param l  First index
    * @param r  Last index
    */
    private func sortBoardCells(l: Int, r: Int) {
        var i = l
        var j = r
        var x : SudokuBoardCell?
        var w : SudokuBoardCell?

        x = boardCells?[(l+r)/2]
        
        repeat {
            if randomizeFilledCells {
				/*
                * Adding randomization
                */
                while ( boardCells?[i].orderPlusRndSeed() < x?.orderPlusRndSeed() ) { i += 1 }
                while ( boardCells?[j].orderPlusRndSeed() > x?.orderPlusRndSeed() ) { j -= 1 }
  
            }
            else {
				/*
                * No randomization
                */
                while ( boardCells?[i].order() < x?.order() ) { i += 1 }
                while ( boardCells?[j].order() > x?.order() ) { j -= 1 }
            }
            if (i<=j) {
				w = boardCells?[i]
				boardCells?[i] = (boardCells?[j])!
				boardCells?[j] = w!
				i += 1
                j -= 1
            }
        } while (i <= j)
        if (l < j) {
            sortBoardCells(l,r: j)
        }
        if (i < r) {
            sortBoardCells(i,r: r)
        }
    }
    /**
    * By default random seed on filled cells is enabled. This parameter
    * affects generating process only. Random seed on
    * filled cells causes randomization on filled cells
    * within the same impact.
    */
    func enableRndSeedOnFilledCells() {
        randomizeFilledCells = true
    }
    /**
    * By default random seed on filled cells is enabled. This parameter
    * affects generating process only. Lack of random seed on
    * filled cells causes no randomization on filled cells
    * within the same impact.
    */
    func disableRndSeedOnFilledCells() {
        randomizeFilledCells = false
    }
    /**
    * Message builder.
    * @param msg Message.
    */
    private func addMessage(msg: String, msgType: Int) {
        let vdt: String = "[" + SudokuStore.JANET_SUDOKU_NAME + "-v." + SudokuStore.JANET_SUDOKU_VERSION + "][" + String(NSDate()) + "]";
        var mt: String = "(msg)"
        if msgType == MSG_ERROR {
            mt = "(error)"
            lastErrorMessage = msg
        }
        messages = messages + SudokuStore.NEW_LINE_SEPARATOR + vdt + mt + " " + msg
        lastMessage = msg
    }
    
    /**
    * Returns list of recorded messages.
    * @return List of recorded messages.
    */
    func getMessages() -> String {
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
    * Return solving time in seconds..
    * @return  Solving time in seconds.
    */
    func getComputingTime() -> Double {
        return computingTime
    }
    /**
    * Return current state of the generator
    * @return  {@link #GENERATOR_INIT_STARTED} or
    *          {@link #GENERATOR_INIT_FINISHED} or
    *          {@link #GENERATOR_INIT_FAILED} or
    *          {@link #GENERATOR_GEN_NOT_STARTED} or
    *          {@link #GENERATOR_GEN_STARTED} or
    *          {@link #GENERATOR_GEN_FINISHED} or
    *          {@link #GENERATOR_GEN_FAILED}.
    */
    func getGeneratorState() -> Int {
        return generatorState
    }
    
}
