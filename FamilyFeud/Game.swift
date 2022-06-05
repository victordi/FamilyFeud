import SwiftUI
import Foundation

struct GameView: View {
    @State var gameState: GameState
    
    @State private var mainScreen = false
    @State private var answer = ""
    @State private var next = false
        
    var body: some View {
        if (mainScreen) {
            ContentView()
        }
        else if (next) {
            PassOrPlayView(gameState: gameState.nextRound())
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
                    HStack {
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
                    }
                    Spacer()
                    gameState.scoreTable
                    Text("Strikes: \(gameState.round.strikes)")
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

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameState: GameState(player1:true, pointsP1:0, pointsP2:0, teamName1: "Victor", teamName2: "Test"))
    }
}
