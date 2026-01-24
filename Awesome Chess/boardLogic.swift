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
    
    
    //clear the pieces before adding
     func start(){
       
    
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
         
         
         
         
         
         
         
         
         
         
         
         
   
         
    }
    
    func pieceAt( row:Int,col:Int,)->Piece?{
        //must iterate through the array
        for piece in pieces{
            if (piece.row==row && piece.col==col){
                print(piece)
              return piece
                
            }
           
            
            
        }
        print("there is not a piece here")
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
            print(pieces)
            return false
            
        }
        
    
    }

    
   
}
