//
//  SudokuGridView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct SudokuGridView: View {
    @ObservedObject var engine: GameEngine
    
    private let spacing: CGFloat = 4
    private let blockSize: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let gridSize = availableWidth
            let cellSize = (gridSize - (spacing * 8) - (20)) / 9
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                VStack(spacing: spacing) {
                    ForEach(0..<9, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<9, id: \.self) { col in
                                let cell = engine.grid.indices.contains(row) ? engine.grid[row][col] : SudokuCell(row: row, col: col, value: nil, isGiven: false)
                                
                                CellView(
                                    cell: cell,
                                    isSelected: isSelected(row: row, col: col),
                                    isRelated: isRelated(row: row, col: col),
                                    isHighlighted: isHighlighted(value: cell.value),
                                    isError: cell.isError
                                )
                                .aspectRatio(1, contentMode: .fit) // Force square aspect ratio
                                .onTapGesture {
                                    engine.selectCell(row: row, col: col)
                                }
                                // Add thicker borders for 3x3 blocks visually
                                .overlay(
                                    // Right border for cols 2 and 5
                                    (col == 2 || col == 5) ? 
                                    AnyView(Rectangle().frame(width: 1).foregroundColor(.gray).padding(.trailing, -spacing/2).offset(x: spacing/2)) : AnyView(EmptyView()),
                                    alignment: .trailing
                                )
                                .overlay(
                                    // Bottom border for rows 2 and 5
                                    (row == 2 || row == 5) ? 
                                    AnyView(Rectangle().frame(height: 1).foregroundColor(.gray).padding(.bottom, -spacing/2).offset(y: spacing/2)) : AnyView(EmptyView()),
                                    alignment: .bottom
                                )
                            }
                        }
                    }
                }
                .padding(10)
            }
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
    let isSelected: Bool
    let isRelated: Bool
    let isHighlighted: Bool
    let isError: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(backgroundColor)
            
            if let value = cell.value {
                Text("\(value)")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(cell.isGiven ? .heavy : .medium)
                    .foregroundColor(textColor)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            } else if !cell.notes.isEmpty {
                GeometryReader { geo in
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
                        ForEach(1...9, id: \.self) { num in
                            if cell.notes.contains(num) {
                                Text("\(num)")
                                    .font(.system(size: geo.size.width * 0.25, design: .monospaced))
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                Color.clear
                            }
                        }
                    }
                }
                .padding(2)
            }
        }
    }
    
    var backgroundColor: Color {
        if isError { return Color.red.opacity(0.2) }
        if isSelected { return Color.blue.opacity(0.3) }
        if isHighlighted { return Color.yellow.opacity(0.3) }
        if isRelated { return Color.blue.opacity(0.05) }
        return Color(UIColor.systemBackground)
    }
    
    var textColor: Color {
        if isError { return .red }
        if cell.isGiven { return .primary }
        return .blue
    }
}

#Preview {
    SudokuGridView(engine: GameEngine())
        .padding()
}
