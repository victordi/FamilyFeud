import SwiftUI

func ConfirmAnswerScreen(gameState: GameState) -> some View {
    VStack {
        Text("Select the team's answer.").bold().font(.system(size: 30))
        Spacer()
        ForEach(gameState.round.answers.indices, id: \.self) { i in
            let ans = gameState.round.answers[i]
            if (!ans.isGuessed) {
                Button(ans.text) {
                    buttonHandler(gameState: gameState, isCorrect: true, index: i)
                }.buttonStyle(MyButton())
                Spacer()
            }
        }
        Button("Wrong answer") {
            buttonHandler(gameState: gameState, isCorrect: false, index: 0)
        }.buttonStyle(MyButton())
        Spacer()
    }
}

func buttonHandler(gameState: GameState, isCorrect: Bool, index: Int) {
    switch gameState.prevScreen {
    case Screen.PassOrPlay:
        handlePassOrPlayAnswer(gameState: gameState, isCorrect: isCorrect, index: index)
    case Screen.Game:
        handleGameAnswer(gameState: gameState, isCorrect: isCorrect, index: index)
    case Screen.Steal:
        handleStealAnswer(gameState: gameState, isCorrect: isCorrect, index: index)
    default:
        print("Should never get here")
    }
}
