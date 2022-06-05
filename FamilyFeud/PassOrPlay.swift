import SwiftUI

struct PassOrPlayView: View {
    @State private var mainScreen = false
    @State private var team1Answer = ""
    @State private var team2Answer = ""
    @State private var play = false
    @State private var pass = false
    @State private var next = false
    @State private var isTeam1 = false
    @State private var currentAnswer = ""
    @State private var confirmAnswer = false
    
    @State var gameState: GameState
    @State var team1Finished: Bool
    @State var team2Finished: Bool
    @State var team1Points: Int
    @State var team2Points: Int
    
    var body: some View {
        if (mainScreen) {
           ContentView()
        }
        else if (play || pass) {
            let nextPlayer = (team1Points > team2Points) == play
            GameView(gameState: gameState.copy(player1: nextPlayer, currentPoints: team1Points + team2Points))
        }
        else if (team1Finished && team2Finished) {
            if (team1Points == 0 && team2Points == 0) {
                PassOrPlayView(gameState: gameState, team1Finished: false, team2Finished: false, team1Points: 0, team2Points: 0)
            } else if (next) {
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
            } else {
                Text("Pass or Play")
                gameState.body
                Text("Congratulations \(gameState.currentTeam)")
                Text("You can now choose to pass or play this round")
                Spacer()
                Button("Continue") {
                    next = true
                }
                Spacer()
                gameState.scoreTable
                Spacer()
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
                                currentAnswer = team1Answer
                                isTeam1 = true
                                confirmAnswer = true
                            }
                        }
                    }
                }
                if (!team2Finished) {
                    HStack {
                        TextField(gameState.teamName2 + " answer...", text: $team2Answer)
                        Button("Submit answer") {
                            if (!team2Answer.isEmpty) {
                                currentAnswer = team2Answer
                                isTeam1 = false
                                confirmAnswer = true
                            }
                        }
                    }
                }
                Spacer()
                gameState.scoreTable
                Spacer()
            }.navigate(
                to: ConfirmPassOrPlayAnswerView(answer:currentAnswer, isTeam1: isTeam1, gameState: gameState, team1Finished: team1Finished, team2Finished: team2Finished, team1Points: team1Points, team2Points: team2Points),
                when: $confirmAnswer
            )
        }
    }
}

struct PassOrPlayView_Previews: PreviewProvider {
    static var previews: some View {
        PassOrPlayView(gameState: GameState(player1:true, pointsP1:0, pointsP2:0, teamName1: "Victor", teamName2: "Test"), team1Finished: false, team2Finished: false, team1Points: 0, team2Points: 0)
    }
}
