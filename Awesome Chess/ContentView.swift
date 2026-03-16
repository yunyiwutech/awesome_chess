import SwiftUI

struct ContentView: View {

    @StateObject var board = boardLogic()

    var body: some View {

        VStack(spacing: 20) {

            // Top info bar
            HStack {

                Text("Black +\(board.blackScore)")
                    .font(.headline)

                Spacer()

                Text(board.turnColor == .white ? "⬜ White's Turn" : "⬛ Black's Turn")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(board.turnColor == .white ? .black : .white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                    .background(board.turnColor == .white ? Color.white : Color.black)
                    .cornerRadius(12)
                    .shadow(radius: 2)

            }
            .padding(.horizontal)

            // Chess board
            ZStack {
                boardView(board: board)
                PieceView(board: board)
            }

            // Bottom info
            HStack {
                Text("White +\(board.whiteScore)")
                    .font(.headline)

                Spacer()
            }
            .padding(.horizontal)

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
