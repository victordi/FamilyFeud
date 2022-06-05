import SwiftUI
import Foundation

struct GameView: View {
    @State var gameState: GameState
    
    @State private var mainScreen = false
    @State private var answer = ""
    @State private var next = false
    @State private var confirmAnswer = false
        
    var body: some View {
        if (mainScreen) {
            ContentView()
        }
        else if (next) {
            PassOrPlayView(gameState: gameState.nextRound(), team1Finished: false, team2Finished: false, team1Points: 0, team2Points: 0)
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
                            if (!answer.isEmpty) { confirmAnswer = true }
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
                }.navigate(to: ConfirmGameAnswerView(answer: answer, gameState: gameState), when: $confirmAnswer)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameState: GameState(player1:true, pointsP1:0, pointsP2:0, teamName1: "Victor", teamName2: "Test"))
    }
}
