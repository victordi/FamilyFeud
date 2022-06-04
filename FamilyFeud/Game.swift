import SwiftUI
import Foundation

struct GameView: View {
    var player1: Bool
    @State var pointsP1: Int
    @State var pointsP2: Int
    var teamName1: String
    var teamName2: String
    
    @State private var mainScreen = false
    @State private var nextRound = false
    @State private var round: Round = games.randomElement().unsafelyUnwrapped
    @State private var answer = ""
    @State private var strikes = 0
    
    func addPoints(_ points: Int) -> Void {
        if(player1) { pointsP1 = pointsP1 + points }
        else { pointsP2 = pointsP2 + points }
    }
    
    var body: some View {
        if (mainScreen) {
            ContentView()
        }
        else {
            if (nextRound) {
                GameView(player1: !player1, pointsP1: pointsP1, pointsP2: pointsP2, teamName1: teamName1, teamName2: teamName2)
            } else {
                VStack {
                    if (player1) { Text(teamName1) }
                    else { Text(teamName2) }
                    VStack {
                        Spacer()
                        Text(round.question)
                        Spacer()
                      
                        List(round.answers.indices, id: \.self) { i in
                            HStack {
                                Text(round.answers[i].getText())
                                Spacer()
                                Text(round.answers[i].getPoints())
                            }
                        }
                        
                        Spacer()
                        
                        TextField("Your answer...", text: $answer)
                        
                        Spacer()
                        Button("Submit answer") {
                            if (!answer.isEmpty) {
                                let points = round.tryAnswer(answer)
                                if (points < 0) {
                                    strikes = strikes + 1
                                    if(strikes == 3) { nextRound = true }
                                } else {
                                    addPoints(points)
                                }
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Text(teamName1)
                            Text("\(pointsP1)")
                        }
                        Spacer()
                        if (player1) { Text("<---") }
                        else { Spacer() }
                        Text("Strikes: \(strikes)")
                        if (!player1) { Text("--->") }
                        else { Spacer() }
                        Spacer()
                        VStack {
                            Text(teamName2)
                            Text("\(pointsP2)")
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button("Next round") {
                            nextRound = true
                        }
                        Spacer()
                        Spacer()
                        Button("Exit game") {
                            mainScreen = true
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(player1:true, pointsP1:0, pointsP2:0, teamName1: "Victor", teamName2: "Test")
    }
}

struct Round {
    var question: String
    var answers: [Answer]
    
    mutating func tryAnswer(_ ans: String) -> Int {
        for i in 0...answers.count - 1 {
            if (answers[i].isCorrectAnswer(ans)) {
                answers[i].isGuessed = true
                return answers[i].points
            }
        }
        return -1
    }
    
    func isFinished() -> Bool {
        for i in 0...answers.count - 1 {
            if (!answers[i].isGuessed) {
                return false
            }
        }
        return true
    }
}

struct Answer {
    var text: String
    var points: Int
    var isGuessed: Bool = false
    
    func isCorrectAnswer(_ ans: String) -> Bool {
        ans.lowercased() == text.lowercased()
    }
    
    func getText() -> String {
        if (isGuessed) {
            return text
            
        } else {
            return ""
        }
    }
    
    func getPoints() -> String {
        if (isGuessed) {
            return "\(points)"
            
        } else {
            return ""
        }
    }
}

var game1 = Round(
    question: "What is your favourite animal?",
     answers: [
        Answer(text: "Dog", points: 40),
        Answer(text: "Cat", points: 30),
        Answer(text: "Turtle", points: 10),
        Answer(text: "Hippo", points: 5),
        Answer(text: "Chiken", points: 4),
        Answer(text: "Human", points: 1)
     ]
)

var game2 = Round(
    question: "What is your favourite animal 2?",
     answers: [
        Answer(text: "Dog", points: 40),
        Answer(text: "Cat", points: 30),
        Answer(text: "Turtle", points: 10),
        Answer(text: "Hippo", points: 5),
        Answer(text: "Chiken", points: 4),
        Answer(text: "Human", points: 1)
     ]
)

var game3 = Round(
    question: "What is your favourite animal 3?",
     answers: [
        Answer(text: "Dog", points: 40),
        Answer(text: "Cat", points: 30),
        Answer(text: "Turtle", points: 10),
        Answer(text: "Hippo", points: 5),
        Answer(text: "Chiken", points: 4),
        Answer(text: "Human", points: 1)
     ]
)

var games = [game1, game2, game3]
