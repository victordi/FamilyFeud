import SwiftUI

func ConfirmationScreen(gameState: GameState) -> some View {
    VStack {
        Spacer()
        Text("Are you sure you want to return home and exit the current game?")
        Spacer()
        HStack {
            Spacer()
            Button("Yes") {
                gameState.reset()
            }.buttonStyle(MyButton())
            Spacer()
            Button("No") {
                gameState.screen = gameState.prevScreen
            }.buttonStyle(MyButton())
            Spacer()
        }
        Spacer()
    }
}
