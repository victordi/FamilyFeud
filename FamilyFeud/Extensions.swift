import SwiftUI

extension String {
    func isQuestion() -> Bool {
        self[index(startIndex, offsetBy: 1)] == "." ||
        self[index(startIndex, offsetBy: 2)] == "." ||
        self[index(startIndex, offsetBy: 3)] == "."
    }
}

extension Array where Element == String {
    func splitQuestions() -> [[String]] {
        var result: [[String]] = [[]]
        var aux: [String] = []
        for line in self {
            if line.isQuestion() {
                result.append(aux)
                aux = [line]
            } else {
                aux.append(line)
            }
        }
        result.append(aux)
        result.removeFirst()
        result.removeFirst()
        
        return result
    }
}
