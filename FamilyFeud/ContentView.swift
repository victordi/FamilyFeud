import SwiftUI

struct ContentView: View {
    @ObservedObject var gameState: GameState = GameState()
    @State private var team1 = ""
    @State private var team2 = ""
    @State private var alert = false
    
    var body: some View {
        VStack {
            if (gameState.screen == Screen.Main) {
                ZStack {
                    VStack() {
                        Text("Welcome to Family Feud!").bold().font(.system(size: 30)).foregroundColor(.black)
                        Spacer()
                        Image("FrontPage").resizable().scaledToFit()
                        
                        Form {
                            TextField("Team 1...", text: $team1)
                            TextField("Team 2...", text: $team2)
                        }.onSubmit {
                            guard !team1.isEmpty && !team2.isEmpty else { return }
                            gameState.teamName1 = team1
                            gameState.teamName2 = team2
                        }.frame(width: 390, height: 164)
                    
                        Button("Start new game") {
                            if (!gameState.teamName2.isEmpty && !gameState.teamName1.isEmpty) {
                                gameState.screen = Screen.PassOrPlay
                            } else {
                                alert = true
                            }
                        }
                            .buttonStyle(MyButton())
                            .alert("Please insert names for both teams before starting a new game", isPresented: $alert) {
                                    Button("OK", role: .cancel) { }
                                }
                        Spacer()
                    }
                }
            }
            else {
                if (gameState.screen != Screen.Confirmation) {
                    Button {
                        gameState.prevScreen = gameState.screen
                        gameState.screen = Screen.Confirmation
                    } label: {
                        Spacer()
                        Image(systemName: "house.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 390, height: 32)
                            .foregroundColor(.blue)
                    }
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
                case Screen.Confirmation:
                    ConfirmationScreen(gameState: gameState)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GameState())
    }
}
