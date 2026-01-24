//
//  piece.swift
//  Awesome Chess
//
//  Created by Yunyi Wu on 20.12.2025..
//

import Foundation

//using hashable to use set to contain objects of piece type
//struct holds data whereas enums are choices
struct Piece:Identifiable{
    let id=UUID()
    var row:Int
    var col:Int
    var pieceType:PieceType
    var pieceColor:PieceColor
    var imageName:String{
        "\(pieceType.rawValue)_\(pieceColor.rawValue)"
    }
}





public enum PieceType:String{
    case pawn
    case knight
    case king
    case queen
    case rook
    case bishop
}

public enum PieceColor:String{
    case white="white"
    case black="black"
}
