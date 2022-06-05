import SwiftUI

struct ConfirmPassOrPlayAnswerView: View {
    var answer: String
    var isTeam1: Bool
    @State var gameState: GameState
    @State var team1Finished: Bool
    @State var team2Finished: Bool
    @State var team1Points: Int
    @State var team2Points: Int
    
    @State private var confirmAnswer = false
    
    var body: some View {
        VStack {
            Text("Choose an answer that matches \(answer)")
            Spacer()
            ForEach(gameState.round.answers.indices, id: \.self) { i in
                let ans = gameState.round.answers[i]
                if (!ans.isGuessed) {
                    Button(ans.text) {
                        gameState.round.answers[i].isGuessed = true
                        if (isTeam1) {
                            team1Points = ans.points
                            team1Finished = true
                            if (ans.points == gameState.round.maxPoints()) {
                                team2Finished = true
                            }
                        } else {
                            team2Points = ans.points
                            team2Finished = true
                            if (ans.points == gameState.round.maxPoints()) {
                                team1Finished = true
                            }
                        }
                        if (team1Points > team2Points) {
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
                if (isTeam1) { team1Finished = true }
                else { team2Finished = true }
                confirmAnswer = true
            }
            Spacer()
        }.navigate(to: PassOrPlayView(gameState: gameState, team1Finished: team1Finished, team2Finished: team2Finished, team1Points: team1Points, team2Points: team2Points), when: $confirmAnswer)
    }
}

struct ConfirmPassOrPlay_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmPassOrPlayAnswerView(answer: "Doggy", isTeam1: true, gameState: GameState(player1:true, pointsP1:0, pointsP2:0, teamName1: "Victor", teamName2: "Test"), team1Finished: false, team2Finished: false, team1Points: 0, team2Points: 0)
    }
}
