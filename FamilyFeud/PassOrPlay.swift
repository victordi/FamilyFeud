import SwiftUI

struct PassOrPlayView: View {
    @State private var mainScreen = false
    @State private var team1Answer = ""
    @State private var team2Answer = ""
    @State private var play = false
    @State private var pass = false
    @State private var next = false
    @State private var confirmAnswer = false
    
    @State var gameState: GameState
    @State var passOrPlayState: PassOrPlayState
    
    var body: some View {
        if (mainScreen) {
           ContentView()
        }
        else if (play || pass) {
            let nextPlayer = (passOrPlayState.team1Points > passOrPlayState.team2Points) == play
            GameView(gameState: gameState.copy(player1: nextPlayer, currentPoints: passOrPlayState.team1Points + passOrPlayState.team2Points))
        }
        else if (passOrPlayState.team1Finished && passOrPlayState.team2Finished) {
            if (passOrPlayState.team1Points == 0 && passOrPlayState.team2Points == 0) {
                PassOrPlayView(gameState: gameState, passOrPlayState: emptyPassOrPlayState)
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
                if (!passOrPlayState.team1Finished) {
                    HStack {
                        TextField(gameState.teamName1 + " answer...", text: $team1Answer)
                        Button("Submit answer") {
                            if (!team1Answer.isEmpty) {
                                passOrPlayState.answer = team1Answer
                                passOrPlayState.isTeam1 = true
                                confirmAnswer = true
                            }
                        }
                    }
                }
                if (!passOrPlayState.team2Finished) {
                    HStack {
                        TextField(gameState.teamName2 + " answer...", text: $team2Answer)
                        Button("Submit answer") {
                            if (!team2Answer.isEmpty) {
                                passOrPlayState.answer = team2Answer
                                passOrPlayState.isTeam1 = false
                                confirmAnswer = true
                            }
                        }
                    }
                }
                Spacer()
                gameState.scoreTable
                Spacer()
            }.navigate(
                to: ConfirmPassOrPlayAnswerView(gameState: gameState, state: passOrPlayState),
                when: $confirmAnswer
            )
        }
    }
}

struct PassOrPlayView_Previews: PreviewProvider {
    static var previews: some View {
        PassOrPlayView(gameState: previewGameState, passOrPlayState: emptyPassOrPlayState)
    }
}
