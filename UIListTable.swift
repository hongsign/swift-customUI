//
//  UIListTable.swift
//  Dev
//
//  Created by YU HONG on 2016-11-28.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation
import UIKit

/*------------------------------------------------

UIListTable

UILabel (description)          |  UILabel (Action)

All action recognizer should be handled by view controller.
This UI view just handles the display.

--------------------------------------------------*/

class UIListTable: UIView {
    
    //size percentage
    let firstsize: CGFloat = 75
    let secondsize: CGFloat = 25
    
    let padding: CGFloat = 2
    
    var rowheight: CGFloat = 20
    var row: Int = 0
    var list: [[UILabel]] = [[UILabel]]()
    
    
    func add(first: UILabel, second: UILabel) {
        list.append([first,second])
        
        setNeedsDisplay()
    }
    
    func remove(index: Int) {
        if index < list.count {
            list.removeAtIndex(index)
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        view.subviews.forEach({ $0.removeFromSuperview() })
        for i in 0..<list.count {
            for j in 0..<list[i].count {
                var width: CGFloat = 0
                if j == 0 {
                    width = (rect.width - 3 * padding) * firstsize / 100
                }
                if j == 1 {
                    width = (rect.width - 3 * padding) * secondsize / 100
                }
                list[i][j].frame = CGRectMake(padding + CGFloat(j) * rect.width * firstsize / 100, CGFloat(i+1) * padding + CGFloat(i) * rowheight, width, rowheight)
                list[i][j].textAlignment = .Center
                addSubview(list[i][j])
            }
        }
    }
    
}
