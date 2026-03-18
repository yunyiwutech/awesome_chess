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
    @ObservedObject var board:boardLogic
    //var boardLayout=boardView()
    @State var selectedPieceId: UUID?
    @State private var whiteShakeAmount: CGFloat = 0
    @State private var blackShakeAmount: CGFloat = 0
    
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
                                    .fill(Color.white.opacity(0.001))
                                    .frame(width: squareSize, height: squareSize)
                                
                                    .onDrop(of: ["public.text"], isTargeted: nil,  perform: {
                                        itemProvider, _ in
                                  
                                        
                                      
                                            if let item = itemProvider.first {
                                                
                                       
                                              
                                            
                                                // 3. load item as NSString
                                                
                                                item.loadObject(ofClass:NSString.self) { (data, err) in
                                                    
                                                    if let info=data as? NSString{
                                                       let conversion=info as String
                                                        let piece_id=UUID(uuidString:conversion)
                                                        //print(piece_id!)
                                                        
                                                       
                                                        //if piece exists
                                                        if let piece = board.getPiece(piece_lookup: piece_id!){
                                                            DispatchQueue.main.async{
                                                                board.movePiece(piece_lookup: piece_id!, row: row, col: col)
                                                            }
                                                        }
                                                        
                                                       
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                }
                                               
                                            
                                            // 6. drop operation completed successfully!
                                            
                                            return true
                                        }
                                        
                                        
                                        
                                        return false
                                        
                                        
                                    })
                                
                                
                                
                                
                                // legal move highlight
                                  if board.legalMoves.contains(where: { $0.row == row && $0.col == col }) {
                                      Rectangle()
                                          .fill(Color.green.opacity(0.4))
                                          .frame(width: squareSize, height: squareSize)
                                  }
                                
                                ForEach(board.pieces){
                                    Piece in
                                    if (row==Piece.row&&col==Piece.col){
                                        //Image(Piece.imageName).frame(width:squareSize,height:squareSize)
                                        Image(Piece.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: squareSize * 0.8, height: squareSize * 0.8)
                                            .modifier(ShakeEffect(animatableData: Piece.pieceType == .king ? (Piece.pieceColor == .white ? whiteShakeAmount : blackShakeAmount) : 0))
                                            .onChange(of: board.isKingInCheck) { newValue in
                                                if Piece.pieceType == .king && Piece.pieceColor == board.turnColor {
                                                    if newValue {
                                                        withAnimation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true)) {
                                                            if Piece.pieceColor == .white {
                                                                whiteShakeAmount = 1
                                                            } else {
                                                                blackShakeAmount = 1
                                                            }
                                                        }
                                                    } else {
                                                        withAnimation(.default) {
                                                            whiteShakeAmount = 0
                                                            blackShakeAmount = 0
                                                        }
                                                    }
                                                }
                                            }
                                            .onDrag {
                                                NSItemProvider(object: Piece.id.uuidString as NSString)
                                            }
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                            }.onTapGesture {
                                if let id = selectedPieceId {
                                    if let piece = board.pieceAt(row: row, col: col), piece.id == id {
                                        selectedPieceId = nil
                                        board.legalMoves = []
                                    } else {
                                        board.movePiece(piece_lookup: id, row: row, col: col)
                                        selectedPieceId = nil
                                        board.legalMoves = []
                                    }
                                } else if let piece = board.pieceAt(row: row, col: col) {
                                    selectedPieceId = piece.id
                                    board.getLegalMoves(for: piece)
                                }
                            }
                            
                        }
                    }
                    
                }
                
                
                
                
                
            }.onAppear(){
                if board.pieces.isEmpty{
                    board.start()
                }
               
                
            }
            
        }
        
        
    }
    
    
    
    
    struct ShakeEffect: GeometryEffect {
        var animatableData: CGFloat
        
        func effectValue(size: CGSize) -> ProjectionTransform {
            let offset = sin(animatableData * .pi * 4) * 5
            return ProjectionTransform(CGAffineTransform(translationX: offset, y: 0))
        }
    }
    
}
#Preview {
    PieceView(board:boardLogic())
}
