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
    // MARK: Basic IDA linting
    // such as converting objc_msgSend(v0, "method:", v2) to [v0 method:](v2)
    static let nsstrings = ("CFSTR\\((\"(?:[^\"\\n]|\\\\\")*\")\\)", "@$1")
    static let classRef = ("&OBJC_CLASS___([\\w\\d]+)", "$1")
    static let msgSend = ("objc_msgSend\\(([\\w\\d]+), \"([\\w\\d:]+)\"\\)", "[$1 $2]")
    static let msgSendWithArgs = ("objc_msgSend\\(([\\w\\d]+), \"([\\w\\d:]+)\", (..*)\\)", "[$1 $2]($3)")
    static let returnedObject = ("(?:\\(\\w+ \\*\\))?objc_retainAutoreleasedReturnValue\\(([^,\\n]+)\\)", "$1")
    static let autorelease = ("\\n\\s+objc_retainAutorelease.+", "")
    static let release = ("objc_release\\((\\w+)\\);", "// [$1 release];")
    static let autoreleaseReturn = ("\\(id\\)objc_autoreleaseReturnValue\\(([^,\\n]+)\\);", "$1;")
    static let singletons = ("\\+(\\[([\\w\\d]+) ([\\w\\d]+)\\])\\(\\2, \\\"\\3\\\"\\);", "$1;")

    // MARK: complex, "hard-coded" linting, such as converting +[Class method:](arg) to [Class method:arg]
    // The _l means "long," ie where IDA chooses to prefix calls with - or +
    static let instanceMethods_l = ("-\\[([\\w\\d]+) ([\\w\\d]+)\\]\\(([^,\\n]+), [^,\\n]+\\);", "[$3 $2]; // -[$1 $2]")
    static let classMethods_l = ("\\+\\[([\\w\\d]+) ([\\w\\d]+)\\]\\(([^,\\n]+), [^,\\n]+\\);$", "[$1];")
    static let singleArgInstanceMethods_l = ("-\\[([\\w\\d]+) ([\\w\\d]+:)\\]\\(([^,\\n]+), [^,\\n]+, ([^,\\n]+)\\);", "[$3 $2$4]; // -[$1 $2]")
    static let singleArgClassMethods_l = ("\\+\\[([\\w\\d]+ [\\w\\d]+:)\\]\\([^,\\n]+, [^,\\n]+, ([^,\\n]+)\\);", "[$1$2];")

    // MARK: Re-linting
    // such as converting [v0 method:](arg) to [v0 method:arg]
    static let singleArgMethods = ("\\[([\\w\\d]+ [\\w\\d]+:)\\]\\(([^,\\n]+)\\);", "[$1$2];")
    static let arraySubscript = ("\\[([\\w\\d]+) objectAtIndexedSubscript:(.+)\\];", "$1[idx: $2]")
    static let dictionarySubscript = ("\\[([\\w\\d]+) objectForKeyedSubscript:(.+)\\];", "$1[key: $2]")
    static let frameLiteralsInMethods = ("((initWith|set)Frame:)\\](\\(.+\\));", "$1CGRectMake$3];")

    static let all: [Pattern] = [
        nsstrings, classRef, msgSend, msgSendWithArgs,
        returnedObject, autorelease, release, autoreleaseReturn,
        instanceMethods_l, classMethods_l, singleArgInstanceMethods_l,
        singleArgClassMethods_l, singleArgMethods,

        singletons, dictionarySubscript, arraySubscript, frameLiteralsInMethods
    ]
}
