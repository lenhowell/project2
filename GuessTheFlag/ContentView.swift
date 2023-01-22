//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Paul Hudson on 20/10/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var questionCounter = 1
    @State private var showingScore = false
    @State private var showingResults = false
    @State private var scoreTitle = ""
    @State private var score = 0
    static let numFlagsInit = 3
    @State private var numFlags = 3
    @State private var numCountries = 10

    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0..<numFlagsInit)
    
    
    // 34 Countries in the Following List
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy"]//, "Nigeria", "Poland", "Russia", "Spain", "Great Britain", "US","Ukraine","Switzerland","Sweden","Portugal","Norway","Netherlands","Wales","Hungary","Isreal","China","Nepal","India","Japan","Vietnam","North Korea","South Korea","Greenland","Guam","Australia","Philippines","Argentina","Aruba","Taiwan","Romania","New Zealand","Mexico","Greece","Cambodia","Canada","Brazil"]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
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
                    ForEach(0..<numFlags,id: \.self){ number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
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
        .alert("Game over!", isPresented: $showingResults) {
            Button("Start Again", action: newGame)
        } message: {
            Text("Your final score was \(score) out of \(questionCounter)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            let needsThe = ["UK", "US"]
            let theirAnswer = countries[number]
            
            if needsThe.contains(theirAnswer) {
                scoreTitle = "Wrong! That's the flag of the \(theirAnswer)."
            } else {
                scoreTitle = "Wrong! That's the flag of \(theirAnswer)."
            }
            
            //          if score > 0 {
            //           score -= 1
            //           }
        }
        
        //        if questionCounter == 8 {
        if countries.count == 3 {
            showingResults = true
        } else {
            showingScore = true
        }
        print("The First three coutries are:\n \(countries[0])\n \(countries[1])\n\(countries[2])\n")
    }
    
    func askQuestion() {
        //        if countries.count == 3 {
        //            print("About to call newGame function!!!!!
        //        (countries.count)//showingResults flag is \(showingResults)")
        //            newGame()
        //        }
        //       print("Remaining Countries \(countries)")
        countries.remove(at: correctAnswer)
        numFlags = min(ContentView.numFlagsInit,countries.count)
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<numFlags)
        questionCounter += 1
    }
    
    func newGame() {
        countries.remove(at: correctAnswer)
        //        print("Remaining Countries \(countries)")
        questionCounter = 1
        score = 0
        countries = Self.allCountries
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<numFlags)
        //        askQuestion()
    }
    
    func initCountries() {
        countries = []
        for i in 0..<numCountries {
            countries.append(ContentView.allCountries[i])
            print (countries)
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
