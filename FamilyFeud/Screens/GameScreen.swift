import SwiftUI

func GameScreen(gameState: GameState) -> some View {
    ZStack {
        if (gameState.round.isFinished() || gameState.round.strikes == 3) {
            VStack {
                Spacer()
                Text("Congratulations \(gameState.currentTeam)").bold().font(.system(size: 30))
                Text("You won \(gameState.currentPoints) points for this round")
                Spacer()
                gameState.body
                Spacer()
                gameState.scoreTable
                Spacer()
                HStack {
                    Spacer()
                    Button("Reveal all answers") {
                        gameState.round.reveal()
                    }.buttonStyle(MyButton())
                    Spacer()
                    Button("Next round") {
                        gameState.nextRound()
                        gameState.screen = Screen.PassOrPlay
                    }.buttonStyle(MyButton())
                    Spacer()
                }
                Spacer()
            }
        } else {
            VStack {
                Text(gameState.currentTeam).bold().font(.system(size: 30))
                
                gameState.body
            
                Button("\(gameState.currentTeam) guess") {
                    gameState.prevScreen = Screen.Game
                    gameState.screen = Screen.ConfirmAnswer
                }.buttonStyle(MyButton())
                Spacer()
                gameState.scoreTable
                Text("Strikes: \(gameState.round.strikes)")
                Spacer()
            }
        }
    }
}

func handleGameAnswer(gameState: GameState, isCorrect: Bool, index: Int) -> Void {
    if (isCorrect) {
        let ans = gameState.round.answers[index]
        gameState.round.answers[index].isGuessed = true
        gameState.currentPoints += ans.points
        gameState.screen = Screen.Game
    } else {
        gameState.round.strikes += 1
        if (gameState.round.strikes == 3) {
            gameState.player1 = !gameState.player1
            gameState.screen = Screen.Steal
        } else {
            gameState.screen = Screen.Game
        }
    }
}
