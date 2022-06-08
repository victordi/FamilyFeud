import SwiftUI

struct ContentView: View {
    @State private var mainScreen = true
    @State private var teamName1: String = ""
    @State private var teamName2: String = ""
    
    var body: some View {
        if (mainScreen) {
            ZStack {
                Color(red: 0.8, green: 0.45, blue: 0.12).ignoresSafeArea()
                VStack() {
                    let _ = populateGames()
                    Text("Welcome to Family Feud!").bold().font(.system(size: 30)).foregroundColor(.black)
                    Spacer()
                    Image("FrontPage").resizable().scaledToFit()
                    
                    Spacer()
                    HStack {
                        Spacer()
                        TextField("Team 1...", text: $teamName1)
                            .font(.system(size: 30).bold())
                            .foregroundColor(.black)
                            .cornerRadius(5)
                        Spacer()
                        Spacer()
                        TextField("Team 2...", text: $teamName2)
                            .font(.system(size: 30).bold())
                            .foregroundColor(.black)
                            .cornerRadius(5)
                        Spacer()
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button("Start new game") {
                        if (!teamName1.isEmpty && !teamName2.isEmpty) { mainScreen = false }
                    }.buttonStyle(MyButton())
                    
                    Spacer()
                }
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
