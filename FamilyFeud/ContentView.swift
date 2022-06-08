import SwiftUI

struct ContentView: View {
    @ObservedObject var gameState: GameState = GameState()
    
    var body: some View {
        VStack {
            Button("Main screen") {
                gameState.reset()
            }
            Spacer()
            switch gameState.screen {
            case Screen.Main:
                MainScreen(gameState: gameState)
            case Screen.PassOrPlay:
                PassOrPlayScreen(gameState: gameState)
            case Screen.ConfirmAnswer:
                ConfirmAnswerScreen(gameState: gameState)
            case Screen.Game:
                GameScreen(gameState: gameState)
            case Screen.Steal:
                StealScreen(gameState: gameState)
            }
        }
    }
}
