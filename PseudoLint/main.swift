//
//  main.swift
//  PseudoLint
//
//  Created by Tanner on 2/20/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

import Foundation

func help() {
    print("usage: psl file")
    print("       psl directory")
    print("Files are saved to psl/")
    print("No arguments starts testing REPL instead")
}

func repl() {
    var str: String!
    while str == nil {
        print("> ", terminator: "")
        str = readLine()
    }

    for pattern in Expression.all {
        str.findAndReplace(pattern)
    }

    print("\n  " + str)
    print("")
    repl()
}

func processFile(at path: String, saveAs outPath: String) {
    var code = try! String(contentsOfFile: path)

    for pattern in Expression.all {
        code.findAndReplace(pattern)
    }

    try! code.write(toFile: outPath, atomically: true, encoding: .utf8)
}

func processDirectory(at path: String) {
    let outputFolder = path +/ "psl"
    FileManager.default.createDirectory(atPath: outputFolder)

    for item in try! FileManager.default.contentsOfDirectory(atPath: path) {
        if item.hasSuffix(".m") {
            processFile(at: path +/ item, saveAs: outputFolder +/ item)
        }
    }
}

func main() {
    if CommandLine.arguments.count < 2 {
        print("PseudoLint REPL")
        //help()
        repl() // for testing
    } else {
        let path = CommandLine.arguments[1].madeAbsolute
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                processDirectory(at: path)
            } else {
                let filename = path.lastPathComponent
                let folder = path.deletingLastPathComponent +/ "psl"
                FileManager.default.createDirectory(atPath: folder)
                processFile(at: path, saveAs: folder +/ filename)
            }
        } else {
            print("Invalid path")
        }
    }
}

main()
