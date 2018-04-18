//
//  Constants.swift
//  PseudoLint
//
//  Created by Tanner on 2/20/18.
//  Copyright © 2018 Tanner Bennett. All rights reserved.
//

import Foundation

typealias Pattern = (find: String, replace: String)

struct Expression {
    static let nsstrings = ("CFSTR\\((\"(?:[^\"\\n]|\\\\\")*\")\\)", "@$1")
    static let classRef = ("&OBJC_CLASS___([\\w\\d]+)", "$1")
    static let msgSend = ("objc_msgSend\\(([\\w\\d]+), \"([\\w\\d:]+)\"\\)", "[$1 $2]")
    static let msgSendWithArgs = ("objc_msgSend\\(([\\w\\d]+), \"([\\w\\d:]+)\", (..*)\\)", "[$1 $2]($3)")
    static let returnedObject = ("(?:\\(\\w+ \\*\\))?objc_retainAutoreleasedReturnValue\\((.+)\\)", "$1")
    static let autorelease = ("\\n\\s+objc_retainAutorelease.+", "")
    static let release = ("objc_release\\((\\w+)\\);", "// [$1 release];")
    static let singletons = ("\\+(\\[[\\w\\d]+ [\\w\\d]+\\])\\(.+\\);", "$1;")
    static let singleArgClassMethods = ("\\[([\\w\\d]+ [\\w\\d]+:)\\]\\([^,]+, [^,]+, (.+)\\);", "[$1$2];")
    static let dictionarySubscript = ("\\[([\\w\\d]+) objectForKeyedSubscript:(.+)\\]", "$1[key: $2]")
    static let arraySubscript = ("\\[([\\w\\d]+) objectAtIndexedSubscript:(.+)\\]", "$1[idx: $2]")
    static let autoreleaseReturn = ("\\(id\\)objc_autoreleaseReturnValue\\((.+)\\);", "$1;")

    static let all: [Pattern] = [
        nsstrings, classRef, msgSend, msgSendWithArgs,
        returnedObject, autorelease, release, singletons,
        singleArgClassMethods, dictionarySubscript, arraySubscript,
        autoreleaseReturn
    ]
}
