import SwiftUI

enum Screen {
    case Main, PassOrPlay, Game, ConfirmAnswer, Steal
}

class GameState : ObservableObject {
    @Published var player1: Bool = true
    @Published var pointsP1: Int = 0
    @Published var pointsP2: Int = 0
    @Published var currentPoints: Int = 0
    @Published var teamName1: String = "Team 1"
    @Published var teamName2: String = "Team 2"
    @Published var roundCount: Int = 0
    @Published var round: Round
    @Published var screen: Screen = Screen.Main
    @Published var prevScreen: Screen = Screen.Main
    
    @Published var passOrPlayState: PassOrPlayState = emptyPassOrPlayState
    @Published var next = false
    
    init() {
        let _ = populateGames()
        round = games.randomElement().unsafelyUnwrapped
    }
    
    func reset() -> Void {
        player1 = true
        pointsP1 = 0
        pointsP2 = 0
        currentPoints = 0
        roundCount = 0
        round = games.randomElement().unsafelyUnwrapped
        screen = Screen.Main
        resetPassOrPlayState()
    }
    
    func resetPassOrPlayState() -> Void {
        round.reset()
        passOrPlayState = emptyPassOrPlayState
        next = false
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(round.question)
            Spacer()
          
            List(round.answers.indices, id: \.self) { i in
                HStack {
                    Text(self.round.answers[i].getText())
                    Spacer()
                    Text(self.round.answers[i].getPoints())
                }
            }.lineLimit(8)
        }
    }
    
    var scoreTable: some View {
        HStack {
            Spacer()
            VStack {
                Text(teamName1)
                Text(String(pointsP1))
            }
            Spacer()
            
            Spacer()
            VStack {
                Text(teamName2)
                Text(String(pointsP2))
            }
            Spacer()
        }
    }
    
    var currentTeam: String {
        player1 ? teamName1 : teamName2
    }
    
    func addPoints(_ points: Int) -> Void {
        if(player1) { pointsP1 += points }
        else { pointsP2 += points }
    }
    
    func nextRound() -> Void {
        if (player1) { pointsP1 += currentPoints }
        else { pointsP2 += currentPoints }
        roundCount += 1
        round = games.randomElement().unsafelyUnwrapped
        round.reset()
        resetPassOrPlayState()
    }
}

struct PassOrPlayState {
    var isTeam1: Bool
    var team1Finished: Bool
    var team2Finished: Bool
    var team1Points: Int
    var team2Points: Int
}

var emptyPassOrPlayState: PassOrPlayState {
    PassOrPlayState(isTeam1: false, team1Finished: false, team2Finished: false, team1Points: 0, team2Points: 0)
}

struct Round {
    var question: String
    var answers: [Answer]
    var strikes: Int = 0
    
    mutating func tryAnswer(_ ans: String) -> Int {
        for i in 0...answers.count - 1 {
            if (answers[i].isCorrectAnswer(ans)) {
                answers[i].isGuessed = true
                return answers[i].points
            }
        }
        return 0
    }
    
    func maxPoints() -> Int {
        let sorted: [Answer] = answers.sorted(by: { $0.points > $1.points})
        return sorted[0].points
    }
    
    func isFinished() -> Bool {
        for i in 0...answers.count - 1 {
            if (!answers[i].isGuessed) {
                return false
            }
        }
        return true
    }
    
    mutating func reveal() -> Void {
        for i in 0...answers.count - 1 {
            answers[i].isGuessed = true
        }
    }
    
    mutating func reset() -> Void {
        for i in 0...answers.count - 1 {
            answers[i].isGuessed = false
        }
        strikes = 0
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

var games: [Round] = []

func populateGames() -> Void {
    var text = ""
    let path = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil).first.unsafelyUnwrapped
    do { text = try String(contentsOfFile: path) } catch {}
    let lines = text.split(separator: "\n").map { it in String(it) }
    let rounds = lines.splitQuestions()
    games = rounds.map { round in
        let question = String(round.first.unsafelyUnwrapped.drop(while: { c in c != "."}).dropFirst())
        let remaining: [String] = Array.init(round.dropFirst())
        let answers: [Answer] = remaining.map { answer in
            let split = answer.split(separator: "-")
            let integer = split[1].filter {c in c != " " }
            return Answer(text: String(split[0]), points: Int(integer).unsafelyUnwrapped)
        }
        return Round(question: question, answers: answers)
    }
}

struct MyButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
