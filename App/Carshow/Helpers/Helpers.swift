//
//  Helpers.swift
//  Carshow
//
//  Created by Alexey Agapov on 22.10.2022.
//

import CustomDump

func dumped<T>(_ value: T) -> String {
    var desc = ""
    customDump(value, to: &desc)
    return desc
}
