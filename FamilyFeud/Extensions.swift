import SwiftUI

extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                let screen = UIScreen.main.bounds
                self
                    .navigationBarHidden(true)
                    .frame(width: screen.width, height: screen.height, alignment: Alignment.center)

                NavigationLink(
                    destination: view
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }.isDetailLink(false)
            }
        }
        .navigationViewStyle(.stack)
    }
}

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
