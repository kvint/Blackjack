//
//  AsyncOperation.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 02.09.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    var _finished = false // Our read-write mirror of the super's read-only finished property
    var _executing = false
    
    override var isAsynchronous: Bool {
        return true
    }
    
    /// Override read-only superclass property as read-write.
    override var isExecuting: Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    /// Override read-only superclass property as read-write.
    override var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        isFinished = false
        isExecuting = true
        
        self.execute()
    }
    
    func execute() {
    }
}
