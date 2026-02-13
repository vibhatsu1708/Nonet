//
//  SudokuCell.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import Foundation

struct SudokuCell: Identifiable, Equatable {
    let id = UUID()
    var value: Int? // 1-9 or nil for empty
    let isFixed: Bool // Cannot be edited if true (original puzzle cells)
    var isError: Bool = false // Marks cell red if incorrect
    var isHighlighted: Bool = false // For completion animations
    
    init(value: Int? = nil, isFixed: Bool = false) {
        self.value = value
        self.isFixed = isFixed
    }
}
