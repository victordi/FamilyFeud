import SwiftUI
import Foundation

struct GameView: View {
    @State var gameState: GameState
    
    @State private var mainScreen = false
    @State private var nextRound = false
    @State private var answer = ""
    @State private var strikes = 0
        
    var body: some View {
        if (mainScreen) {
            ContentView()
        }
        else {
            if (nextRound) {
                GameView(gameState: gameState.nextRound())
            } else {
                VStack {
                    if (gameState.player1) { Text(gameState.teamName1) }
                    else { Text(gameState.teamName2) }
                    VStack {
                        Spacer()
                        Text(gameState.round.question)
                        Spacer()
                      
                        List(gameState.round.answers.indices, id: \.self) { i in
                            HStack {
                                Text(gameState.round.answers[i].getText())
                                Spacer()
                                Text(gameState.round.answers[i].getPoints())
                            }
                        }
                        
                        Spacer()
                        
                        TextField("Your answer...", text: $answer)
                        
                        Spacer()
                        Button("Submit answer") {
                            if (!answer.isEmpty) {
                                let points = gameState.round.tryAnswer(answer)
                                if (points < 0) {
                                    strikes = strikes + 1
                                    if(strikes == 3) { nextRound = true }
                                } else {
                                    gameState.addPoints(points)
                                }
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Text(gameState.teamName1)
                            Text("\(gameState.pointsP1)")
                        }
                        Spacer()
                        if (gameState.player1) { Text("<---") }
                        else { Spacer() }
                        Text("Strikes: \(strikes)")
                        if (!gameState.player1) { Text("--->") }
                        else { Spacer() }
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
                            nextRound = true
                        }
                        Spacer()
                        Spacer()
                        Button("Exit game") {
                            mainScreen = true
                        }
                        Spacer()
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
