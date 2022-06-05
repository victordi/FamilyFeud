import SwiftUI

struct PassOrPlayView: View {
    @State private var mainScreen = false
    @State private var team1Answer = ""
    @State private var team2Answer = ""
    @State private var team1Finished = false
    @State private var team2Finished = false
    @State private var team1Points = 0
    @State private var team2Points = 0
    @State private var play = false
    @State private var pass = false
    
    @State var gameState: GameState
    
    var body: some View {
        if (mainScreen) {
           ContentView()
        }
        else if (play) {
            GameView(gameState: gameState.copy(player1: team1Points > team2Points, currentPoints: team1Points + team2Points))
        }
        else if (pass) {
            GameView(gameState: gameState.copy(player1: team2Points > team1Points, currentPoints: team1Points + team2Points))
        }
        else if (team1Finished && team2Finished) {
            if (team1Points == 0 && team2Points == 0) {
                PassOrPlayView(gameState: gameState)
            } else {
                VStack {
                    Text("Do you want to pass or play this round")
                    HStack {
                        Spacer()
                        Button("Play") { play = true }
                        Spacer()
                        Button("Pass") { pass = true }
                        Spacer()
                    }
                }
            }
        }
        else {
            VStack {
                Text("Pass or Play")
                gameState.body
                if (!team1Finished) {
                    HStack {
                        TextField(gameState.teamName1 + " answer...", text: $team1Answer)
                        Button("Submit answer") {
                            if (!team1Answer.isEmpty) {
                                team1Points = gameState.round.tryAnswer(team1Answer)
                                team1Finished = true
                                if (team1Points == gameState.round.maxPoints()) {
                                    team2Finished = true
                                }
                            }
                        }
                    }
                }
                if (!team2Finished) {
                    HStack {
                        TextField(gameState.teamName2 + " answer...", text: $team2Answer)
                        Button("Submit answer") {
                            if (!team2Answer.isEmpty) {
                                team2Points = gameState.round.tryAnswer(team2Answer)
                                team2Finished = true
                                if (team2Points == gameState.round.maxPoints()) {
                                    team1Finished = true
                                }
                            }
                        }
                    }
                }
                Spacer()
                gameState.scoreTable
                Spacer()
            }
        }
    }
}

struct PassOrPlayView_Previews: PreviewProvider {
    static var previews: some View {
        PassOrPlayView(gameState: GameState(player1:true, pointsP1:0, pointsP2:0, teamName1: "Victor", teamName2: "Test"))
    }
}
