import SwiftUI

struct PassOrPlayView: View {
    @State private var mainScreen = false
    @State private var play = false
    @State private var pass = false
    @State private var next = false
    @State private var confirmAnswer = false
    
    @State var gameState: GameState
    @State var passOrPlayState: PassOrPlayState
    
    var body: some View {
        ZStack {
            if (mainScreen) {
                ContentView()
            }
            else if (play || pass) {
                let nextPlayer = (passOrPlayState.team1Points > passOrPlayState.team2Points) == play
                GameView(gameState: gameState.copy(player1: nextPlayer, currentPoints: passOrPlayState.team1Points + passOrPlayState.team2Points))
            }
            else if (confirmAnswer) {
                VStack {
                    Text("Select the team's answer.").bold().font(.system(size: 30))
                    Spacer()
                    ForEach(gameState.round.answers.indices, id: \.self) { i in
                        let ans = gameState.round.answers[i]
                        if (!ans.isGuessed) {
                            Button(ans.text) {
                                gameState.round.answers[i].isGuessed = true
                                if (passOrPlayState.isTeam1) {
                                    passOrPlayState.team1Points = ans.points
                                    passOrPlayState.team1Finished = true
                                    if (ans.points == gameState.round.maxPoints()) {
                                        passOrPlayState.team2Finished = true
                                    }
                                } else {
                                    passOrPlayState.team2Points = ans.points
                                    passOrPlayState.team2Finished = true
                                    if (ans.points == gameState.round.maxPoints()) {
                                        passOrPlayState.team1Finished = true
                                    }
                                }
                                if (passOrPlayState.team1Points > passOrPlayState.team2Points) {
                                    gameState.player1 = true
                                } else {
                                    gameState.player1 = false
                                }
                                confirmAnswer = false
                            }.buttonStyle(MyButton())
                            Spacer()
                        }
                    }
                    Button("Wrong answer") {
                        if (passOrPlayState.isTeam1) { passOrPlayState.team1Finished = true }
                        else { passOrPlayState.team2Finished = true }
                        if (passOrPlayState.team2Finished && passOrPlayState.team1Finished && passOrPlayState.team1Points == passOrPlayState.team2Points) {
                            passOrPlayState = emptyPassOrPlayState
                        }
                        confirmAnswer = false
                    }.buttonStyle(MyButton())
                    Spacer()
                }
            }
            else if (passOrPlayState.team1Finished && passOrPlayState.team2Finished && (passOrPlayState.team1Points != 0 || passOrPlayState.team2Points != 0)) {
                if (next) {
                    VStack {
                        Text("Do you want to pass or play this round").bold().font(.system(size: 30))
                        HStack {
                            Spacer()
                            Button("Play") { play = true }.buttonStyle(MyButton())
                            Spacer()
                            Button("Pass") { pass = true }.buttonStyle(MyButton())
                            Spacer()
                        }
                    }
                } else {
                    VStack {
                        Text("Pass or Play").bold().font(.system(size: 30))
                        gameState.body
                        Text("Congratulations \(gameState.currentTeam)")
                        Text("You can now choose to pass or play this round")
                        Spacer()
                        Button("Continue") { next = true }.buttonStyle(MyButton())
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
                        if (!passOrPlayState.team1Finished) {
                            Button("\(gameState.teamName1) guess") {
                                passOrPlayState.isTeam1 = true
                                confirmAnswer = true
                            }.buttonStyle(MyButton())
                        }
                        Spacer()
                        if (!passOrPlayState.team2Finished) {
                            Button("\(gameState.teamName2) guess") {
                                passOrPlayState.isTeam1 = false
                                confirmAnswer = true
                            }.buttonStyle(MyButton())
                        }
                        Spacer()
                    }
                    Spacer()
                    gameState.scoreTable
                    Spacer()
                    Button("Exit game") {
                        mainScreen = true
                    }.buttonStyle(MyButton())
                    Spacer()
                }
            }
        }
    }
}

struct PassOrPlayView_Previews: PreviewProvider {
    static var previews: some View {
        PassOrPlayView(gameState: previewGameState, passOrPlayState: emptyPassOrPlayState)
    }
}
