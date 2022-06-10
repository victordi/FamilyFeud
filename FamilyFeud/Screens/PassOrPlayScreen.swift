import SwiftUI

func PassOrPlayScreen(gameState: GameState) -> some View {
    ZStack {
        if (gameState.passOrPlayState.team1Finished && gameState.passOrPlayState.team2Finished && (gameState.passOrPlayState.team1Points != 0 || gameState.passOrPlayState.team2Points != 0)) {
            if (gameState.next) {
                VStack {
                    Spacer()
                    Text("Do you want to pass or play this round").bold().font(.system(size: 30))
                    HStack {
                        Spacer()
                        Button("Play") {
                            gameState.player1 = gameState.passOrPlayState.team1Points >= gameState.passOrPlayState.team2Points
                            gameState.currentPoints = gameState.passOrPlayState.team1Points + gameState.passOrPlayState.team2Points
                            gameState.screen = Screen.Game
                        }.buttonStyle(MyButton())
                        Spacer()
                        Button("Pass") {
                            gameState.player1 = gameState.passOrPlayState.team1Points < gameState.passOrPlayState.team2Points
                            gameState.currentPoints = gameState.passOrPlayState.team1Points + gameState.passOrPlayState.team2Points
                            gameState.screen = Screen.Game
                        }.buttonStyle(MyButton())
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                VStack {
                    Text("Pass or Play").bold().font(.system(size: 30))
                    gameState.body
                    Text("Congratulations \(gameState.currentTeam)")
                    Text("You can now choose to pass or play this round")
                    Spacer()
                    Button("Continue") { gameState.next = true }.buttonStyle(MyButton())
                    Spacer()
                    gameState.scoreTable
                    Spacer()
                }
            }
        }
        else {
            VStack {
                Text("Pass or Play").bold().font(.system(size: 30))
                gameState.body
                Spacer()
                HStack {
                    Spacer()
                    if (!gameState.passOrPlayState.team1Finished) {
                        Button("\(gameState.teamName1) guess") {
                            gameState.passOrPlayState.isTeam1 = true
                            gameState.prevScreen = Screen.PassOrPlay
                            gameState.screen = Screen.ConfirmAnswer
                        }.buttonStyle(MyButton())
                    }
                    Spacer()
                    if (!gameState.passOrPlayState.team2Finished) {
                        Button("\(gameState.teamName2) guess") {
                            gameState.passOrPlayState.isTeam1 = false
                            gameState.prevScreen = Screen.PassOrPlay
                            gameState.screen = Screen.ConfirmAnswer
                        }.buttonStyle(MyButton())
                    }
                    Spacer()
                }
                Spacer()
                gameState.scoreTable
                Spacer()
                HStack {
                    Spacer()
                    Button("Skip question") {
                        gameState.resetPassOrPlayState()
                        gameState.round = games.randomElement().unsafelyUnwrapped
                    }.buttonStyle(MyButton())
                    Spacer()
                    Button("Reset stage") {
                        gameState.resetPassOrPlayState()
                    }.buttonStyle(MyButton())
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

func handlePassOrPlayAnswer(gameState: GameState, isCorrect: Bool, index: Int) -> Void {
    if (isCorrect) {
        let ans = gameState.round.answers[index]
        gameState.round.answers[index].isGuessed = true
        if (gameState.passOrPlayState.isTeam1) {
            gameState.passOrPlayState.team1Points = ans.points
            gameState.passOrPlayState.team1Finished = true
            if (ans.points == gameState.round.maxPoints()) {
                gameState.passOrPlayState.team2Finished = true
            }
        } else {
            gameState.passOrPlayState.team2Points = ans.points
            gameState.passOrPlayState.team2Finished = true
            if (ans.points == gameState.round.maxPoints()) {
                gameState.passOrPlayState.team1Finished = true
            }
        }
        if (gameState.passOrPlayState.team1Points > gameState.passOrPlayState.team2Points) {
            gameState.player1 = true
        } else {
            gameState.player1 = false
        }
    } else {
        if (gameState.passOrPlayState.isTeam1) { gameState.passOrPlayState.team1Finished = true }
        else { gameState.passOrPlayState.team2Finished = true }
        if (gameState.passOrPlayState.team2Finished && gameState.passOrPlayState.team1Finished && gameState.passOrPlayState.team1Points == gameState.passOrPlayState.team2Points) {
            gameState.passOrPlayState = emptyPassOrPlayState
        }
    }
    gameState.screen = Screen.PassOrPlay
}
