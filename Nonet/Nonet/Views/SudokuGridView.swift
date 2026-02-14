//
//  SudokuGridView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct SudokuGridView: View {
    @ObservedObject var engine: GameEngine
    
    // Grid sizing
    private let spacing: CGFloat = 2
    private let blockSize: CGFloat = 4
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let cellSize = (availableWidth - (spacing * 6) - (blockSize * 2)) / 9
            
            VStack(spacing: blockSize) {
                ForEach(0..<3, id: \.self) { boxRow in
                    HStack(spacing: blockSize) {
                        ForEach(0..<3, id: \.self) { boxCol in
                            // 3x3 Box
                            VStack(spacing: spacing) {
                                ForEach(0..<3, id: \.self) { rowOffset in
                                    HStack(spacing: spacing) {
                                        ForEach(0..<3, id: \.self) { colOffset in
                                            let row = (boxRow * 3) + rowOffset
                                            let col = (boxCol * 3) + colOffset
                                            
                                            let cell = engine.grid.indices.contains(row) ? engine.grid[row][col] : SudokuCell(row: row, col: col, value: nil, isGiven: false)
                                            
                                            CellView(
                                                cell: cell,
                                                size: cellSize,
                                                isSelected: isSelected(row: row, col: col),
                                                isRelated: isRelated(row: row, col: col),
                                                isHighlighted: isHighlighted(value: cell.value)
                                            )
                                            .onTapGesture {
                                                engine.selectCell(row: row, col: col)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(blockSize)
            .background(Color.black) // Border color
            .border(Color.black, width: 2)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func isSelected(row: Int, col: Int) -> Bool {
        guard let selected = engine.selectedCell else { return false }
        return selected.row == row && selected.col == col
    }
    
    private func isRelated(row: Int, col: Int) -> Bool {
        guard let selected = engine.selectedCell else { return false }
        return selected.row == row || selected.col == col || 
               (selected.row / 3 == row / 3 && selected.col / 3 == col / 3)
    }
    
    private func isHighlighted(value: Int?) -> Bool {
        guard let selected = engine.selectedCell,
              let val = value,
              let selectedVal = engine.grid[selected.row][selected.col].value else { return false }
        return val == selectedVal
    }
}

struct CellView: View {
    let cell: SudokuCell
    let size: CGFloat
    let isSelected: Bool
    let isRelated: Bool
    let isHighlighted: Bool
    
    var body: some View {
        ZStack {
            Color(backgroundColor)
            
            
            if let value = cell.value {
                Text("\(value)")
                    .font(.system(size: size * 0.6, weight: cell.isGiven ? .bold : .light))
                    .foregroundColor(textColor)
            } else if !cell.notes.isEmpty {
                GeometryReader { geo in
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                        ForEach(1...9, id: \.self) { num in
                            if cell.notes.contains(num) {
                                Text("\(num)")
                                    .font(.system(size: size * 0.25))
                                    .foregroundColor(.gray)
                            } else {
                                Color.clear
                            }
                        }
                    }
                }
                .padding(2)
            }
        }
        .frame(width: size, height: size)
    }
    
    var backgroundColor: UIColor {
        if cell.isError { return .red.withAlphaComponent(0.3) }
        if isSelected { return .systemBlue.withAlphaComponent(0.3) }
        if isHighlighted { return .systemBlue.withAlphaComponent(0.2) } // Same number highlighted
        if isRelated { return .systemGray5 }
        return .systemBackground
    }
    
    var textColor: Color {
        if cell.isError { return .red }
        if cell.isGiven { return .black }
        return .blue
    }
}

#Preview {
    SudokuGridView(engine: GameEngine())
}
