//
//  pieceInit.swift
//  Awesome Chess
//
//  Created by Yunyi Wu on 21.12.2025..
//

import Foundation
import SwiftUI
internal import Combine
//an array of pieces to store all the coordinates
//observableobject because move class will modify it later
class boardLogic : ObservableObject {
    @Published var pieces: [Piece] = []
    //variable to implement
    @Published var turnColor:PieceColor = .white
    
    @Published var whiteScore:Int=0
    @Published var blackScore:Int=0
    @Published var pawnPromotion:Bool = false
    @Published var promotionID:UUID?
    @Published var isKingInCheck: Bool = false
    @Published var legalMoves: [(row: Int, col: Int)] = []
   
    //clear the pieces before adding
    func start(){
        
        //clearing the pieces
        pieces=[]
        
        
        var pieceTypes:[PieceType]=[.rook, .knight, .bishop, .queen, .king, .bishop, .knight, .rook]
        
        
        //white bottom row
        for i in 0...7 {
            addPiece(
                Piece: Piece(
                    row: 1,
                    col: i,
                    pieceType: .pawn,
                    pieceColor: .white
                )
            )
            
        }
        
        //white bottom row
        
        for i in 0...7 {
            addPiece(
                Piece: Piece(
                    row: 0,
                    col: i,
                    pieceType: pieceTypes[i],
                    pieceColor: .white
                )
            )
            
        }
        
        //black bottom row
        for i in 0...7 {
            addPiece(
                Piece: Piece(
                    row: 6,
                    col: i,
                    pieceType: .pawn,
                    pieceColor: .black
                )
            )
            
        }
        
        //black bottom row
        for i in 0...7 {
            addPiece(
                Piece: Piece(
                    row: 7,
                    col: i,
                    pieceType: pieceTypes[i],
                    pieceColor: .black
                )
            )
            
        }
        
        
        
        
        
        
        
        
        //print(pieces)
        
        
        
        
        
    }
    func getLegalMoves(for piece: Piece) {
        legalMoves = []
        for row in 0...7 {
            for col in 0...7 {
                if canMove(piece_lookup: piece.id, row: row, col: col) {
                    legalMoves.append((row: row, col: col))
                }
            }
        }
    }
    func pieceAt( row:Int,col:Int,)->Piece?{
        //must iterate through the array
        for piece in pieces{
            if (piece.row==row && piece.col==col){
                //print(piece)
                return piece
                
            }
            
            
            
        }
        
        return nil
    }
    
    
    //should return a boolean
    
    func addPiece(Piece:Piece)->Bool{
        if let piece=(pieceAt(row: Piece.row, col: Piece.col)){
            return true
        }
        else{
            //add a piece into the array
            pieces.append(Piece)
            
            return false
            
        }
        
        
    }
    
    func movePiece(piece_lookup: Piece.ID, row: Int, col: Int) -> Piece? {
        if canMove(piece_lookup: piece_lookup, row: row, col: col) {
            
            //pointValue function goes here before the piece is captured
            if let destinationPiece = pieceAt(row: row, col: col) {
                
                
                
                let points = pointValue(for: destinationPiece.pieceType)
                if destinationPiece.pieceColor == .black{
                    whiteScore+=points
                }
                else{
                    blackScore+=points
                }
                deletePiece(piece_lookup: destinationPiece.id)
            }
            //if the index exists
            if let index = pieces.firstIndex(where: { $0.id == piece_lookup }) {
                pieces[index].row = row
                pieces[index].col = col
                pieces[index].hasMoved = true
                
                if pieces[index].pieceType == .pawn {
                    //if it reaches the white end
                    
                    if (pieces[index].pieceColor == .white && row == 7) || (pieces[index].pieceColor == .black && row == 0) {
                        //promote
                        promotionID = pieces[index].id
                        pawnPromotion = true 
                    }
                   
                }
                
                
            }
            //if can move flip the color
           turnColor = turnColor == .white ? .black: .white
            isKingInCheck = isInCheck(color: turnColor)
        }
        
        
     
        return getPiece(piece_lookup: piece_lookup)
    }

    func canMove(piece_lookup: Piece.ID, row: Int, col: Int, checkForCheck: Bool = true) -> Bool {
        guard let piece = getPiece(piece_lookup: piece_lookup) else { return false }
        
        if checkForCheck && piece.pieceColor != turnColor {
            return false
        }
        
        if piece.pieceType == .rook {
            if piece.row != row && piece.col != col { return false }
            if piece.col == col {
                for i in min(piece.row,row)+1..<max(piece.row,row) {
                    if let _ = pieceAt(row: i, col: col) { return false }
                }
            } else {
                for i in min(piece.col,col)+1..<max(piece.col,col) {
                    if let _ = pieceAt(row: row, col: i) { return false }
                }
            }
            if let destinationPiece = pieceAt(row: row, col: col) {
                if piece.pieceColor == destinationPiece.pieceColor { return false }
            }
            if checkForCheck && simulateMove(piece: piece, toRow: row, toCol: col) { return false }
            return true
        }
        
        else if piece.pieceType == .bishop {
            let colSteps = abs(col - piece.col)
            let rowSteps = abs(row - piece.row)
            let distanceTraveled = max(colSteps, rowSteps)
            if colSteps != rowSteps { return false }
            let direction = (row: (row-piece.row).signum(), col: (col-piece.col).signum())
            var currentLocation = (row: piece.row, col: piece.col)
            if distanceTraveled > 1 {
                for i in 1..<distanceTraveled {
                    currentLocation = (row: piece.row + i * direction.row, col: piece.col + i * direction.col)
                    if let _ = pieceAt(row: currentLocation.row, col: currentLocation.col) { return false }
                }
            }
            if let destinationPiece = pieceAt(row: row, col: col) {
                if piece.pieceColor == destinationPiece.pieceColor { return false }
            }
            if checkForCheck && simulateMove(piece: piece, toRow: row, toCol: col) { return false }
            return true
        }
        
        else if piece.pieceType == .knight {
            let rowDiff = abs(row - piece.row)
            let colDiff = abs(col - piece.col)
            if !((rowDiff==2 && colDiff==1) || (rowDiff==1 && colDiff==2)) { return false }
            if let destinationPiece = pieceAt(row: row, col: col) {
                if piece.pieceColor == destinationPiece.pieceColor { return false }
            }
            if checkForCheck && simulateMove(piece: piece, toRow: row, toCol: col) { return false }
            return true
        }
        
        else if piece.pieceType == .queen {
            if abs(col-piece.col) != abs(row-piece.row) && piece.row != row && piece.col != col { return false }
            if piece.col == col {
                for i in min(piece.row,row)+1..<max(piece.row,row) {
                    if let _ = pieceAt(row: i, col: col) { return false }
                }
            } else if piece.row == row {
                for i in min(piece.col,col)+1..<max(piece.col,col) {
                    if let _ = pieceAt(row: row, col: i) { return false }
                }
            }
            if piece.row != row && piece.col != col {
                let colSteps = abs(col - piece.col)
                let rowSteps = abs(row - piece.row)
                let distanceTraveled = max(colSteps, rowSteps)
                if colSteps != rowSteps { return false }
                let direction = (row: (row-piece.row).signum(), col: (col-piece.col).signum())
                var currentLocation = (row: piece.row, col: piece.col)
                if distanceTraveled > 1 {
                    for i in 1..<distanceTraveled {
                        currentLocation = (row: piece.row + i * direction.row, col: piece.col + i * direction.col)
                        if let _ = pieceAt(row: currentLocation.row, col: currentLocation.col) { return false }
                    }
                }
            }
            if let destinationPiece = pieceAt(row: row, col: col) {
                if piece.pieceColor == destinationPiece.pieceColor { return false }
            }
            if checkForCheck && simulateMove(piece: piece, toRow: row, toCol: col) { return false }
            return true
        }
        
        else if piece.pieceType == .king {
            let rowDistance = abs(row - piece.row)
            let colDistance = abs(col - piece.col)
            if rowDistance > 1 || colDistance > 1 { return false }
            if let destinationPiece = pieceAt(row: row, col: col) {
                if piece.pieceColor == destinationPiece.pieceColor { return false }
            }
            if checkForCheck && simulateMove(piece: piece, toRow: row, toCol: col) { return false }
            return true
        }
        
        else if piece.pieceType == .pawn {
            let Direction = piece.pieceColor == .white ? 1 : -1
            let colDistance = abs(col - piece.col)
            let rowMovement = (row - piece.row) * Direction
            
            if colDistance == 0 && rowMovement == 1 {
                if pieceAt(row: row, col: col) != nil { return false }
                if checkForCheck && simulateMove(piece: piece, toRow: row, toCol: col) { return false }
                return true
            }
            else if colDistance == 1 && rowMovement == 1 {
                if let destinationPiece = pieceAt(row: row, col: col) {
                    if piece.pieceColor == destinationPiece.pieceColor { return false }
                    if checkForCheck && simulateMove(piece: piece, toRow: row, toCol: col) { return false }
                    return true
                }
                return false
            }
            else if rowMovement == 2 && colDistance == 0 && piece.hasMoved == false {
                if pieceAt(row: piece.row + Direction, col: col) != nil { return false }
                if pieceAt(row: row, col: col) != nil { return false }
                if checkForCheck && simulateMove(piece: piece, toRow: row, toCol: col) { return false }
                return true
            }
            return false
        }
        
        return false
    }
    func deletePiece(piece_lookup:Piece.ID)->Piece?{
        
        //if piece exists
        if let Piece=(getPiece(piece_lookup: piece_lookup)){
            //remove it
            pieces.removeAll(where: {$0.id==piece_lookup})
            
            //then return it
            print("The piece being removed is ",Piece)
            return Piece
        }
        //else just return nil
        return nil
        
        
        
        
    }
    
    func isInCheck(color:PieceColor)->Bool{
        //early exit
        guard let king = pieces.first(where: { $0.pieceColor == color && $0.pieceType == .king }) else {
            return false
        }
        for enemyPiece in pieces where enemyPiece.pieceColor != color {
            if canMove(piece_lookup: enemyPiece.id, row: king.row, col: king.col,checkForCheck: false) {
                return true
            }
        }
        return false
        
    }
    
    func getPiece(piece_lookup:Piece.ID)->Piece?{
        pieces.first(where: {$0.id==piece_lookup} )
        
        
    }
    
    //point function for different types
    func pointValue(for pieceType:PieceType)->Int{
        
        switch pieceType {
            case .pawn: return 1
            case .knight: return 3
            case .bishop: return 3
            case .rook: return 5
            case .queen: return 9
            case .king: return 0
            }
    }
    
    func simulateMove(piece: Piece, toRow: Int, toCol: Int) -> Bool {
        let originalRow = piece.row
        let originalCol = piece.col
        
        // temporarily remove destination piece if any (but not the moving piece itself)
        var capturedPiece: Piece? = nil
        if let destination = pieceAt(row: toRow, col: toCol), destination.id != piece.id {
            capturedPiece = destination
            pieces.removeAll(where: { $0.id == destination.id })
        }
        
        // temporarily move the piece
        if let index = pieces.firstIndex(where: { $0.id == piece.id }) {
            pieces[index].row = toRow
            pieces[index].col = toCol
        }
        
        // check if own king is in check
        let inCheck = isInCheck(color: piece.pieceColor)
        
        // undo the move
        if let index = pieces.firstIndex(where: { $0.id == piece.id }) {
            pieces[index].row = originalRow
            pieces[index].col = originalCol
        }
        
        // restore captured piece
        if let captured = capturedPiece {
            pieces.append(captured)
        }
        
        return inCheck
    }
}
