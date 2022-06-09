import SwiftUI

struct ContentView: View {
    @ObservedObject var gameState: GameState = GameState()
    
    var body: some View {
        VStack {
            Button {
                gameState.reset()
            } label: {
                Spacer()
                Image(systemName: "house.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 390, height: 32)
                    .foregroundColor(.blue)
            }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GameState())
    }
}
