import SwiftUI


func MainScreen(gameState: GameState) -> some View {
    ZStack {
        VStack() {
            Text("Welcome to Family Feud!").bold().font(.system(size: 30)).foregroundColor(.black)
            Spacer()
            Image("FrontPage").resizable().scaledToFit()
        
            Button("Start new game") {
               gameState.screen = Screen.PassOrPlay
            }.buttonStyle(MyButton())

            Spacer()
        }
    }
}
