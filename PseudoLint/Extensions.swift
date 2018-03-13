//
//  Extensions.swift
//  PseudoLint
//
//  Created by Tanner on 3/12/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

import Foundation

infix operator +/

extension String: Error {
    var madeAbsolute: String {
        if self.isAbsolutePath {
            return self
        } else {
            let path = (self as NSString).standardizingPath
            return String(validatingUTF8: realpath(path, nil))!
        }
    }

    var lastPathComponent: String {
        return self.ns.lastPathComponent
    }

    var deletingLastPathComponent: String {
        return self.ns.deletingLastPathComponent
    }

    var isAbsolutePath: Bool {
        return self.ns.isAbsolutePath
    }

    var ns: NSString {
        return self as NSString
    }

    mutating func findAndReplace(_ pattern: Pattern) {
        let expr = try! NSRegularExpression(pattern: pattern.find, options: [])
        self = expr.stringByReplacingMatches(
            in: self, options: [.withTransparentBounds], range: NSMakeRange(0, self.count), withTemplate: pattern.replace
        )
    }

    static func +/(lhs: String, rhs: String) -> String {
        return (lhs as NSString).appendingPathComponent(rhs)
    }
}

extension FileManager {
    func createDirectory(atPath path: String) {
        var isDirectory: ObjCBool = false
        if self.fileExists(atPath: path, isDirectory: &isDirectory) {
            if !isDirectory.boolValue {
                fatalError("'\(path) is a file, not a directory")
            }
        } else {
            try! self.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: [:])
        }
    }
}
