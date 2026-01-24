//
//  SwiftUIView.swift
//  Awesome Chess
//
//  Created by Yunyi Wu on 23.01.2026..
//

import SwiftUI

struct PieceView: View {
    //instance of the board model where all the work are done
    //attributes of row and col
    @StateObject var board=boardLogic()
    var boardLayout=boardView()
    
    
    
    
    var body: some View {
        GeometryReader{ geometry in
            
            let squareSize = min(geometry.size.width, geometry.size.height) / 8
            
            //drawing the row and column
            VStack(spacing:0){
                ForEach((0..<8).reversed(), id: \.self){
                    row in
                    
                    //for each row
                    //draw column
                    HStack(spacing: 0){
                        ForEach((0..<8).reversed(), id: \.self) { col in
                            
                            ZStack(){
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: squareSize, height: squareSize)
                                
                                ForEach(board.pieces){
                                    Piece in
                                    if (row==Piece.row&&col==Piece.col){
                                        Image(Piece.imageName).frame(width:squareSize,height:squareSize)
                                            
                                        
                                    }
                                 
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                            }
                        }
                    }
                    
                }
                
                
                
                
                
            }.onAppear(){
                board.start()
            }
            
        }
    }
}
#Preview {
    PieceView()
}
