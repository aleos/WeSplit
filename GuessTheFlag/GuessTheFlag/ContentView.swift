//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alexander Ostrovsky on 31.07.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var round = 0
    
    @State private var answer: Int?
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    let roundsPerGame = 3
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)                .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Guess the Flag")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .foregroundColor(.white)
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                                .rotation3DEffect(
                                    number == answer ? Angle(degrees: 360) : Angle(degrees: 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .animation(answer != nil && number == answer ? .easeInOut : nil)
                                .opacity(answer == nil || number == answer ? 1 : 0.25)
                                .scaleEffect(answer == nil || number == answer ? 1 : 0.8)
                                .animation(.easeInOut)
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game over", isPresented: $showingFinalScore) {
            Button("New game", action: reset)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        answer = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            increaseScore()
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            decreaseScore()
        }

        round += 1
        showingScore = true
    }
    
    func askQuestion() {
        guard round < roundsPerGame else {
            showingFinalScore = true
            return
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        answer = nil
    }
    
    func increaseScore() {
        score += 1
    }
    
    func decreaseScore() {
        score -= 2
    }
    
    func reset() {
        round = 0
        score = 0
        showingScore = false
        showingFinalScore = false
        askQuestion()
    }
}

private extension ContentView {
    struct FlagImage: View {
        let name: String
        var body: some View {
            Image(name)
                .renderingMode(.original )
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
