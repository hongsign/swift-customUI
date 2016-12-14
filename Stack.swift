//
//  Stack.swift
//  Dev
//
//  Created by YU HONG on 2016-12-05.
//  Copyright © 2016 homesoft. All rights reserved.
//

import Foundation

class Stack<Element> {
    var items = [Element]()
    
    func push (item: Element) {
        items.append(item)
    }
    
    func pop() -> Element {
        return items.removeLast()
    }
    
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
    
    var count: Int {
        return items.count
    }
    
    func removeAll() {
        items.removeAll()
    
}
