//
//  Extensions.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 17/11/2022.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}

public extension Thread {
    /// A method to ensure execution of the provided block on the main thread
    /// - Parameter block: The block to execute on the main thread
    class func runOnMain(block: () -> Void) {
        if Thread.isMainThread {
            block()
            return
        }
        DispatchQueue.main.sync {
            block()
        }
    }
}

extension UInt8 {
    var boolValue: Bool {
        return self != 0
    }
}
