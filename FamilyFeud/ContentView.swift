import SwiftUI

struct ContentView: View {
    @State private var mainScreen = true
    @State private var teamName1: String = ""
    @State private var teamName2: String = ""
    
    var body: some View {
        if (mainScreen) {
            VStack {
                let _ = populateGames()
                Spacer()
                Text("Welcome to Family Feud!")
                    .padding(.all)
                
                Spacer()
                Spacer()
                
                TextField("Team 1...", text: $teamName1)
                TextField("Team 2...", text: $teamName2)
                
                Spacer()
                Spacer()
                
                Button.init("Start new game") {
                    if (!teamName1.isEmpty && !teamName2.isEmpty) { mainScreen = false }
                }
                
                Spacer()
            }
        } else {
            PassOrPlayView(gameState: GameState(player1: true, pointsP1: 0, pointsP2: 0, teamName1: teamName1, teamName2: teamName2), passOrPlayState: emptyPassOrPlayState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
