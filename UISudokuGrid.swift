//
//  UISudokuGrid.swift
//  Dev
//
//  Created by YU HONG on 2016-11-29.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class UISudokuGrid: UIView {
    
    let numberlist = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let padding: CGFloat = 2
    
    var row: Int = 9
    var col: Int = 9
    
    var border: CGFloat = 0
    
    var grid: [[UILabel]] = [[UILabel]]()
    
    var currentpos: (row: Int, col: Int) = (0,0)
    
    let textcolor: UIColor = UIColor.blackColor()
    let selectedcolor: UIColor = UIColor.redColor()
    
    let bgcolor: UIColor = UIColor.clearColor()
    let selectedbgcolor: UIColor = UIColor.lightGrayColor()
    
    var dropdown: DropDown!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        
        
        let w = (frame.width - CGFloat(col + 1) * padding) / CGFloat(col)
        let h = (frame.height - CGFloat(row + 1) * padding) / CGFloat(row)
        
        border = w > h ? h : w
        
        userInteractionEnabled = true
        let selector = NSSelectorFromString("clicked:")
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))

        
        initDropDown()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        //subviews.forEach({ $0.removeFromSuperview() })
        
        let w = (rect.width - CGFloat(col + 1) * padding) / CGFloat(col)
        let h = (rect.height - CGFloat(row + 1) * padding) / CGFloat(row)
        
        border = w > h ? h : w
        
        for i in 0..<row {
            for j in 0..<col {
                grid[i][j].frame = CGRectMake(padding + CGFloat(j) * border, padding + CGFloat(i) * border, border, border)
                addSubview(grid[i][j])
            }
        }
        
    }
    
    func initGrid(grid: [[Int]]) {
        for i in 0..<row {
            self.grid.append([UILabel]())
            for j in 0..<col {
                self.grid[i].append(UILabel(frame: CGRectZero))
                
                if grid[i][j] == 0 {
                    self.grid[i][j].text = ""
                }
                else {
                    self.grid[i][j].text = String(grid[i][j])
                }
                
                self.grid[i][j].layer.borderWidth = 1
                self.grid[i][j].layer.borderColor = textcolor.CGColor
                self.grid[i][j].textAlignment = .Center
            }
        }
    }
    
    func initDropDown() {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = border
        appearance.cornerRadius = 5
        appearance.shadowColor = UIColor.darkGrayColor()
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.5
        appearance.textColor = textcolor
        
        dropdown = DropDown()
        
        dropdown.anchorView = self
        dropdown.direction = .Any
        dropdown.width = border
        dropdown.dataSource = numberlist
        dropdown.dismissMode = .Manual//.Automatic
        dropdown.selectionAction = { [unowned self] (index, item) in
            self.grid[self.currentpos.row][self.currentpos.col].text = item
            self.grid[self.currentpos.row][self.currentpos.col].layer.borderColor = self.textcolor.CGColor
            self.grid[self.currentpos.row][self.currentpos.col].backgroundColor = self.bgcolor
            self.dropdownshowed = false
            self.dropdown.hide()
        }
        /*
        dropdown.cancelAction = { [unowned self] in
            self.grid[self.currentpos.row][self.currentpos.col].textColor = self.textcolor
            self.dropdownshowed = false
        }
        */
        
    }
    
    func getGrid() -> [[Int]] {
        var g: [[Int]] = [[Int]]()
        
        for i in 0..<row {
            for j in 0..<col {
                if grid[i][j].text == "" {
                    g[i][j] = 0
                }
                else {
                    g[i][j] = Int(grid[i][j].text!)!
                }
            }
        }
        
        return g
    }
    
    func updateCell(row: Int, col: Int, value: Int) {
        grid[row][col].text = String(value)
    }
    
    var dropdownshowed: Bool = false
    /*----------------------------------------------------
    TapAction
    ------------------------------------------------------*/
    func clicked(sender: UITapGestureRecognizer) {
        
        print("clicked")
        
                /*
        let r = CGFloat(currentpos.row)
        let c = CGFloat(currentpos.col)
        
        dropdown.topOffset = CGPoint(x: -c * border + (c + 1) * padding, y: -r * border + (r + 1) * padding)
        */
        if dropdownshowed {
            grid[currentpos.row][currentpos.col].layer.borderColor = textcolor.CGColor
            grid[currentpos.row][currentpos.col].backgroundColor = bgcolor//UIColor.lightGrayColor()
            dropdownshowed = false
            dropdown.hide()
        }
        else {
            let touchlocation = sender.locationInView(sender.view)
            for i in 0..<row {
                for j in 0..<col {
                    if touchlocation.x > grid[i][j].frame.origin.x && touchlocation.x < grid[i][j].frame.origin.x + grid[i][j].frame.width {
                        if touchlocation.y > grid[i][j].frame.origin.y && touchlocation.y < grid[i][j].frame.origin.y + grid[i][j].frame.height {
                            currentpos = (row: i, col: j)
                        }
                    }
                }
            }
            grid[currentpos.row][currentpos.col].layer.borderColor = selectedcolor.CGColor
            grid[currentpos.row][currentpos.col].backgroundColor = selectedbgcolor

            //let c = CGFloat(currentpos.col)
            //dropdown.frame.origin.x = c * border + (c + 1) * padding
            //dropdown.center = grid[currentpos.row][currentpos.col].center
            dropdown.anchorView = grid[currentpos.row][currentpos.col]
            dropdownshowed = true
            dropdown.show()
        }
        
    }
    
}
