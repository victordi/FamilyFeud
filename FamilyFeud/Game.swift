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
            if (gameState.round.isFinished()) {
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
                            if (points < 0) {
                                gameState.round.strikes += 1
                            } else {
                                gameState.addPoints(points)
                            }
                        }
                        answer = ""
                    }
                    
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Text(gameState.teamName1)
                            Text("\(gameState.pointsP1)")
                        }
                        Spacer()
                        Text("Strikes: \(gameState.round.strikes)")
                        Spacer()
                        VStack {
                            Text(gameState.teamName2)
                            Text("\(gameState.pointsP2)")
                        }
                        Spacer()
                    }
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
