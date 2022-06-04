import SwiftUI

struct GameState {
    var player1: Bool
    var pointsP1: Int = 0
    var pointsP2: Int = 0
    var teamName1: String
    var teamName2: String
    var roundCount: Int = 0
    @State var round: Round = games.randomElement().unsafelyUnwrapped
    
    mutating func addPoints(_ points: Int) -> Void {
        if(player1) { pointsP1 += points }
        else { pointsP2 += points }
    }
    
    func nextRound() -> GameState {
        GameState(player1: !player1, pointsP1: pointsP1, pointsP2: pointsP2, teamName1: teamName1, teamName2: teamName2, roundCount: roundCount + 1)
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
