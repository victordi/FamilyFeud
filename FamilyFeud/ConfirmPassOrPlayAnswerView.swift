import SwiftUI

struct ConfirmPassOrPlayAnswerView: View {
    @State var gameState: GameState
    @State var state: PassOrPlayState
    
    @State private var confirmAnswer = false
    
    var body: some View {
        VStack {
            Text("Choose an answer that matches \(state.answer)")
            Spacer()
            ForEach(gameState.round.answers.indices, id: \.self) { i in
                let ans = gameState.round.answers[i]
                if (!ans.isGuessed) {
                    Button(ans.text) {
                        gameState.round.answers[i].isGuessed = true
                        if (state.isTeam1) {
                            state.team1Points = ans.points
                            state.team1Finished = true
                            if (ans.points == gameState.round.maxPoints()) {
                                state.team2Finished = true
                            }
                        } else {
                            state.team2Points = ans.points
                            state.team2Finished = true
                            if (ans.points == gameState.round.maxPoints()) {
                                state.team1Finished = true
                            }
                        }
                        if (state.team1Points > state.team2Points) {
                            gameState.player1 = true
                        } else {
                            gameState.player1 = false
                        }
                        confirmAnswer = true
                    }
                    Spacer()
                }
            }
            Button("Wrong answer") {
                if (state.isTeam1) { state.team1Finished = true }
                else { state.team2Finished = true }
                confirmAnswer = true
            }
            Spacer()
        }.navigate(to: PassOrPlayView(gameState: gameState, passOrPlayState: state), when: $confirmAnswer)
    }
}

struct ConfirmPassOrPlay_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmPassOrPlayAnswerView(gameState: previewGameState, state: emptyPassOrPlayState)
    }
}
