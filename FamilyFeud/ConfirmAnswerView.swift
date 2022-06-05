import SwiftUI

struct ConfirmAnswerView: View {
    var answer: String
    @State var gameState: GameState
    @State private var confirmAnswer = false
    
    var body: some View {
        contents.navigate(to: GameView(gameState: gameState), when: $confirmAnswer)
    }
    
    var contents: some View {
        VStack {
            Text("Choose an answer that matches \(answer)")
            Spacer()
            ForEach(gameState.round.answers.indices, id: \.self) { i in
                let ans = gameState.round.answers[i]
                if (!ans.isGuessed) {
                    Button(ans.text) {
                        gameState.round.answers[i].isGuessed = true
                        gameState.currentPoints += ans.points
                        confirmAnswer = true
                    }
                }
                Spacer()
                
            }
            Button("Wrong answer") {
                gameState.round.strikes += 1
                confirmAnswer = true
            }
            Spacer()
        }
    }
}

struct ConfirmAnswer_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmAnswerView(answer: "Doggy", gameState: GameState(player1:true, pointsP1:0, pointsP2:0, teamName1: "Victor", teamName2: "Test"))
    }
}
