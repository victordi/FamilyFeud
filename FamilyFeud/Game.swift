import SwiftUI
import Foundation

struct GameView: View {
    @State var gameState: GameState
    
    @State private var mainScreen = false
    @State private var next = false
    @State private var confirmAnswer = false
        
    var body: some View {
        if (mainScreen) {
            ContentView()
        }
        else if (next) {
            PassOrPlayView(gameState: gameState.nextRound(), passOrPlayState: emptyPassOrPlayState)
        }
        else {
            if (gameState.round.isFinished() || gameState.round.strikes == 3) {
                // TODO(): if 3 strikes -> allow opponents to steal
                VStack {
                    Spacer()
                    Text("Congratulations \(gameState.currentTeam)")
                    Text("You won \(gameState.currentPoints) points for this round")
                    Spacer()
                    gameState.body
                    Spacer()
                    gameState.scoreTable
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Reveal all answers") {
                            gameState.round.reveal()
                        }
                        Spacer()
                        Button("Next round") {
                            next = true
                        }
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                VStack {
                    Text(gameState.currentTeam)
                    
                    gameState.body
                
                    Button("\(gameState.currentTeam) guess") {
                        confirmAnswer = true
                    }
                    Spacer()
                    gameState.scoreTable
                    Text("Strikes: \(gameState.round.strikes)")
                    Spacer()
                    Button("Exit game") {
                        mainScreen = true
                    }
                    Spacer()
                }.navigate(to: ConfirmGameAnswerView(gameState: gameState), when: $confirmAnswer)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameState: previewGameState)
    }
}
