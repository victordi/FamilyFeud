import SwiftUI
import Foundation

struct GameView: View {
    @State var gameState: GameState
    
    @State private var mainScreen = false
    @State private var next = false
    @State private var confirmAnswer = false
    @State private var steal = false
    @State private var confirmSteal = false
        
    var body: some View {
        ZStack {
            if (mainScreen) {
                ContentView()
            }
            else if (next) {
                PassOrPlayView(gameState: gameState.nextRound(), passOrPlayState: emptyPassOrPlayState)
            }
            else if (confirmAnswer) {
                VStack {
                    Text("Choose an answer that matches.").bold().font(.system(size: 30))
                    Spacer()
                    ForEach(gameState.round.answers.indices, id: \.self) { i in
                        let ans = gameState.round.answers[i]
                        if (!ans.isGuessed) {
                            Button(ans.text) {
                                gameState.round.answers[i].isGuessed = true
                                gameState.currentPoints += ans.points
                                confirmAnswer = false
                            }.buttonStyle(MyButton())
                            Spacer()
                        }
                    }
                    Button("Wrong answer") {
                        gameState.round.strikes += 1
        
                        if (gameState.round.strikes == 3) {
                            steal = true
                            gameState.player1 = !gameState.player1
                        }
                        confirmAnswer = false
                    }.buttonStyle(MyButton())
                    Spacer()
                }
            }
            else if (steal) {
                if (confirmSteal) {
                    VStack {
                        Text("Choose an answer that matches.").bold().font(.system(size: 30))
                        Spacer()
                        ForEach(gameState.round.answers.indices, id: \.self) { i in
                            let ans = gameState.round.answers[i]
                            if (!ans.isGuessed) {
                                Button(ans.text) {
                                    gameState.round.answers[i].isGuessed = true
                                    gameState.currentPoints += ans.points
                                    confirmAnswer = false
                                    steal = false
                                }.buttonStyle(MyButton())
                                Spacer()
                            }
                        }
                        Button("Wrong answer") {
                            steal = false
                            gameState.player1 = !gameState.player1
                            confirmAnswer = false
                        }.buttonStyle(MyButton())
                        Spacer()
                    }
                } else {
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
                        Button("Confirm") { confirmSteal = true }.buttonStyle(MyButton())
                        Spacer()
                    }
                }
            }
            else {
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
                                next = true
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
                            confirmAnswer = true
                        }.buttonStyle(MyButton())
                        Spacer()
                        gameState.scoreTable
                        Text("Strikes: \(gameState.round.strikes)")
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
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameState: previewGameState)
    }
}
