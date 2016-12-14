//
//  SudokuUtils.swift
//  Dev
//
//  Created by YU HONG on 2016-12-06.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation

class SudokuUtils {
    
    static func ToArray(list: Stack<SudokuBoardCell>) -> [SudokuBoardCell] {
        let n = list.count
        var cells = [SudokuBoardCell]()
        
        for _ in 0..<n {
            cells.append(list.pop())
        }
        return cells
    }
    
    static func CurrentTimeMills() -> Int64 {
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble * 1000)
    }
    
}