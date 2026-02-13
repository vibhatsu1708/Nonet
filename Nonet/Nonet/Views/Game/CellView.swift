//
//  CellView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct CellView: View {
    let cell: SudokuCell
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: 4)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
                )
            
            // Number text
            if let value = cell.value {
                Text("\(value)")
                    .font(.system(size: 20, weight: cell.isFixed ? .bold : .regular))
                    .foregroundColor(textColor)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .animation(.easeInOut(duration: 0.2), value: cell.isHighlighted)
        .animation(.easeInOut(duration: 0.15), value: cell.isError)
    }
    
    private var backgroundColor: Color {
        if cell.isHighlighted {
            return Color.green.opacity(0.3)
        } else if isSelected {
            return Color.blue.opacity(0.2)
        } else {
            return Color(.systemGray6)
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return Color.blue
        } else {
            return Color.gray.opacity(0.3)
        }
    }
    
    private var textColor: Color {
        if cell.isError {
            return .red
        } else if cell.isFixed {
            return .primary
        } else {
            return .blue
        }
    }
}
