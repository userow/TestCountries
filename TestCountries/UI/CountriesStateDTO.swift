//
//  CountriesStateDTO.swift
//  TestCountries
//
//  Created by Pavlo Vasylenko on 27.05.2023.
//

import Foundation

public struct CountriesStateDTO {
    var isFlagOn = false
    var isCodeOn = false
    var highlightedText = ""
}

extension CountriesStateDTO: Equatable {
    static func != (lhs: Self, rhs: Self) -> Bool {
        let equal = (lhs.isFlagOn != rhs.isFlagOn) ||
        (lhs.isCodeOn != rhs.isCodeOn) ||
        (lhs.highlightedText != rhs.highlightedText)

        return equal
    }
}
