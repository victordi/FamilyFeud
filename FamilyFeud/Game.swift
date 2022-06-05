import SwiftUI
import Foundation

struct GameView: View {
    @State var gameState: GameState
    
    @State private var mainScreen = false
    @State private var answer = ""
        
    var body: some View {
        if (mainScreen) {
            ContentView()
        }
        else {
            if (gameState.round.isFinished() || gameState.round.strikes == 3) {
                // TODO(): if 3 strikes -> allow opponents to steal
                // TODO(): before going to next round Reveal all answers and have a button for next round
                // TODO(): for the above maybe have a view in gameState.reveal() + button here
                PassOrPlayView(gameState: gameState.nextRound())
            } else {
                VStack {
                    Text(gameState.currentTeam)
                    
                    gameState.body
                        
                    TextField("Your answer...", text: $answer)
                    Spacer()
                    Button("Submit answer") {
                        if (!answer.isEmpty) {
                            let points = gameState.round.tryAnswer(answer)
                            if (points == 0) {
                                gameState.round.strikes += 1
                            } else {
                                gameState.currentPoints += points
                            }
                        }
                        answer = ""
                    }
                    
                    Spacer()
                    gameState.scoreTable
                    Text("Strikes: \(gameState.round.strikes)")
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Next round") {
                            gameState.round.strikes = 3
                        }
                        Spacer()
                        Spacer()
                        Button("Exit game") {
                            mainScreen = true
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameState: GameState(player1:true, pointsP1:0, pointsP2:0, teamName1: "Victor", teamName2: "Test"))
    }
}
