import SwiftUI


func MainScreen(gameState: GameState) -> some View {
    ZStack {
        VStack() {
            Text("Welcome to Family Feud!").bold().font(.system(size: 30)).foregroundColor(.black)
            Spacer()
            Image("FrontPage").resizable().scaledToFit()
        
            Button("Start new game") {
                if (!gameState.teamName2.isEmpty && !gameState.teamName1.isEmpty) {
                    gameState.screen = Screen.PassOrPlay
                }
            }.buttonStyle(MyButton())
            Spacer()
        }
    }
}
