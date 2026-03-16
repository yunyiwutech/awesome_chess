//
//  board.swift
//  Awesome Chess
//
//  Created by Yunyi Wu on 19.12.2025..
//

import SwiftUI

struct boardView: View {
    //variables to store values of the board
   
    @StateObject var board=boardLogic()
    
    var body: some View {
       
        
        GeometryReader { geometry in
            
            let squareSize = min(geometry.size.width, geometry.size.height) / 8
            
            VStack(spacing: 0) {
                ForEach((0..<8).reversed(), id: \.self) { row in
                    
                    
                  
                   

                    HStack(spacing: 0) {
                        ForEach(0..<8, id: \.self) { col in
                            ZStack{
                               Rectangle()
                                
                                    .fill((row + col).isMultiple(of: 2) ? Color.white :  Color.teal)
                                    .frame(width: squareSize, height: squareSize)
                             
                                    
                                
                               
                                
                                
                                
                                    
                            }
                          
                        }
                      
                      
                    }
                }
               
            }
            
        }.frame(maxWidth:.infinity,maxHeight:.infinity)

    }
    
  

}


#Preview {
    boardView()
}
