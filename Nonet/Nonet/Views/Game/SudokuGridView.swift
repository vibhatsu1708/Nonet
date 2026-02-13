//
//  SudokuGridView.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import SwiftUI

struct SudokuGridView: View {
    @ObservedObject var grid: SudokuGrid
    @Binding var selectedCell: (row: Int, col: Int)?
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9, id: \.self) { col in
                        CellView(
                            cell: grid.cells[row][col],
                            isSelected: selectedCell?.row == row && selectedCell?.col == col
                        )
                        .onTapGesture {
                            if !grid.cells[row][col].isFixed {
                                selectedCell = (row, col)
                                HapticManager.shared.selectionFeedback()
                            }
                        }
                        
                        // Thicker border after every 3rd column
                        if col < 8 {
                            if (col + 1) % 3 == 0 {
                                Divider()
                                    .frame(width: 2)
                                    .background(Color.primary)
                            } else {
                                Divider()
                                    .frame(width: 1)
                            }
                        }
                    }
                }
                
                // Thicker border after every 3rd row
                if row < 8 {
                    if (row + 1) % 3 == 0 {
                        Divider()
                            .frame(height: 2)
                            .background(Color.primary)
                    } else {
                        Divider()
                            .frame(height: 1)
                    }
                }
            }
        }
        .background(Color.primary.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
}
