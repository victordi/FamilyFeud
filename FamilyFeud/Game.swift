import SwiftUI
import Foundation

struct GameView: View {
    @State var gameState: GameState
    
    @State private var mainScreen = false
    @State private var next = false
    @State private var confirmAnswer = false
        
    var body: some View {
        ZStack {
            if (mainScreen) {
                ContentView()
            }
            else if (next) {
                PassOrPlayView(gameState: gameState.nextRound(), passOrPlayState: emptyPassOrPlayState)
            }
            else if (confirmAnswer) {
                VStack {
                    Text("Choose an answer that matches.")
                    Spacer()
                    ForEach(gameState.round.answers.indices, id: \.self) { i in
                        let ans = gameState.round.answers[i]
                        if (!ans.isGuessed) {
                            Button(ans.text) {
                                gameState.round.answers[i].isGuessed = true
                                gameState.currentPoints += ans.points
                                confirmAnswer = false
                            }
                            Spacer()
                        }
                    }
                    Button("Wrong answer") {
                        gameState.round.strikes += 1
                        confirmAnswer = false
                    }
                    Spacer()
                }
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
                    }
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameState: previewGameState)
    }
}
