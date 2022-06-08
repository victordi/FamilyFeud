import SwiftUI

func StealScreen(gameState: GameState) -> some View {
    VStack {
        Spacer()
        HStack {
            Image("x").resizable().scaledToFit()
            Image("x").resizable().scaledToFit()
            Image("x").resizable().scaledToFit()
        }
        Spacer()
        Text("\(gameState.currentTeam) can now steal the round.").bold().font(.system(size: 30))
        Spacer()
        Button("Confirm") {
            gameState.prevScreen = Screen.Steal
            gameState.screen = Screen.ConfirmAnswer
        }.buttonStyle(MyButton())
        Spacer()
    }
}

func handleStealAnswer(gameState: GameState, isCorrect: Bool, index: Int) -> Void {
    if (isCorrect) {
        gameState.round.answers[index].isGuessed = true
        gameState.currentPoints += gameState.round.answers[index].points
    } else {
        gameState.player1 = !gameState.player1
    }
    gameState.screen = Screen.Game
}
