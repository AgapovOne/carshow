//
//  Helpers.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import CustomDump
import UIKit

func dumped<T>(_ value: T) -> String {
    var desc = ""
    customDump(value, to: &desc)
    return desc
}

func call(_ phone: String) {
    guard
        let url = URL(string: "tel://\(phone)"),
        UIApplication.shared.canOpenURL(url)
    else {
        print("failed to call to \(phone)")
        return
    }
    print("called \(phone)")
    UIApplication.shared.open(url)
}

func update<A>(_ a: inout A, _ fs: ((inout A) -> Void)...) {
    fs.forEach { f in f(&a) }
}

func update<A>(_ a: A, _ fs: ((inout A) -> Void)...) -> A {
    var a = a
    fs.forEach { f in f(&a) }
    return a
}
