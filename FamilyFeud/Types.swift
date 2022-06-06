import SwiftUI

struct GameState {
    var player1: Bool
    var pointsP1: Int = 0
    var pointsP2: Int = 0
    var currentPoints: Int = 0
    var teamName1: String
    var teamName2: String
    var roundCount: Int = 0
    var round: Round = games.randomElement().unsafelyUnwrapped
    
    var body: some View {
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
    
    mutating func addPoints(_ points: Int) -> Void {
        if(player1) { pointsP1 += points }
        else { pointsP2 += points }
    }
    
    func nextRound() -> GameState {
        if (player1) {
            return GameState(player1: false, pointsP1: pointsP1 + currentPoints, pointsP2: pointsP2, teamName1: teamName1, teamName2: teamName2, roundCount: roundCount + 1)
        } else {
            return GameState(player1: true, pointsP1: pointsP1, pointsP2: pointsP2 + currentPoints, teamName1: teamName1, teamName2: teamName2, roundCount: roundCount + 1)
        }
    }
    
    func copy(player1: Bool? = nil, currentPoints: Int? = nil) -> GameState {
        return GameState(
            player1: player1 ?? self.player1,
            pointsP1: self.pointsP1,
            pointsP2: self.pointsP2,
            currentPoints: currentPoints ?? self.currentPoints,
            teamName1: self.teamName1,
            teamName2: self.teamName2,
            roundCount: self.roundCount + 1,
            round: self.round)
    }
}

var previewGameState: GameState {
    GameState(player1:true, pointsP1:0, pointsP2:0, teamName1: "Team1", teamName2: "Team2")
}

struct PassOrPlayState {
    var answer: String
    var isTeam1: Bool
    var team1Finished: Bool
    var team2Finished: Bool
    var team1Points: Int
    var team2Points: Int
}

var emptyPassOrPlayState: PassOrPlayState {
    PassOrPlayState(answer: "", isTeam1: false, team1Finished: false, team2Finished: false, team1Points: 0, team2Points: 0)
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
