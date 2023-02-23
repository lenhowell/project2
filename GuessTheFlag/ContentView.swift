//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Paul Hudson on 20/10/2021.
//

import SwiftUI

struct ContentView: View {
    // 40 Countries in the Following List
    static var allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "Great Britain", "US","Ukraine","Switzerland","Sweden","Portugal","Norway","Netherlands","Wales","Hungary","Isreal","China","Nepal","India","Japan","Vietnam","North Korea","South Korea","Greenland","Guam","Australia","Philippines","Argentina","Aruba","Taiwan","Romania","New Zealand","Mexico","Greece","Cambodia","Canada","Brazil"]
    static let easyCountries = ["US","Canada","Mexico","Great Britain","France","Spain","China","Japan","Germany","Isreal","Ukraine","Russia","Italy","Ireland","Switzerland","Sweden"]
    static let mediumCountries = ["Portugal","Poland","Norway","Wales","Netherlands","India","Greece","Netherlands","Aruba","Brazil","New Zealand","Hungary"]
    static let hardCountries = ["Estonia","Nigeria","Nepal","Vietnam","North Korea","South Korea","Greenland","Guam","Australia","Philippines","Argentina","Taiwan","Romania","Cambodia"]
    static let testCountries = ["Portugal","Poland","Norway","Wales","US"]

    static let numFlagsShownInit = 3
    static private var flagType = FlagType.Test
    @State private var questionCounter = 1
    @State private var showingScore = false
    @State private var showingResults = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var numCountries = 3
//    static private var numCountriesInit = 3
    @State private var tempCountries = []
    @State private var firstTimeSwitch = true
    @State private var countries: [String]
    @State private var archivedCountries: [String] = []
    @State private var correctAnswer = Int.random(in: 0..<numFlagsShownInit)
    @State private var wasCorrect = false
    @State private var countriesCount: Int
    @State private var countriesToDisplay: [String]
    @State private var validAnswers: [String] = []

    enum FlagType {
    case Easy,Medium,Hard,Test
    }
    
    init(){
        let couple = ContentView.initCountries()
        countries = couple.array
        countriesCount = couple.count
        countriesToDisplay = couple.array
    }

    static func initCountries()->(array:[String],count:Int){
        switch flagType {
        case .Easy:
            allCountries = easyCountries
        case .Medium:
            allCountries = mediumCountries
        case .Hard:
            allCountries = hardCountries
        case .Test:
            allCountries = testCountries
        }
        allCountries.shuffle()
        return (allCountries,allCountries.count)
    }
    
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
                    ForEach(0..<ContentView.numFlagsShownInit,id: \.self){ number in
                        Button {
 //                           print("This is what is in countries....\n \(countries)")
 //                           print ("correctAnswer \(correctAnswer) and number has a value of \(number)")
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
            Button("Continue", action: askNextQuestion)
        } message: {
            Text("Your score is \(score) OUT OF \(countriesCount+score) using \(questionCounter) Tries.\n\(countriesCount) Countries To Go\n")
        }
        .alert("Game over!", isPresented: $showingResults) {
            Button("Start Again", action: newGame)
        
            Button("!!!!!!!!End Game!!!!!!!!!", action: endGame)
        }message: {
            Text("Your final score was \(score) out of \(countriesCount+score) in \(questionCounter) Tries!!!\nPerformance score is \(score*100/questionCounter)%")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            countriesCount -= 1
            score += 1
            wasCorrect = true
        } else {
            wasCorrect = false
            let needsThe = ["UK", "US"]
            let theirAnswer = countries[number]
            
            if needsThe.contains(theirAnswer) {
                scoreTitle = "Wrong! That's the flag of the \(theirAnswer)."
            } else {
                scoreTitle = "Wrong! That's the flag of \(theirAnswer)."
            }
        }
       if countriesCount <= 0 {
            showingResults = true
        } else {
            showingScore = true
        }
    }
    func askNextQuestion() {
        let answerRange = min(countriesCount, ContentView.numFlagsShownInit)
            if wasCorrect {
                archivedCountries.append(countries[correctAnswer])
                print("Archived Countries \(archivedCountries)")
                countries.remove(at: correctAnswer)
                countries.shuffle()
                correctAnswer = Int.random(in: 0..<answerRange)
                if countriesCount < ContentView.numFlagsShownInit {
 //                   print("Archived Countries before shuffle \(archivedCountries)")
 //                   archivedCountries.shuffle()
 //                   print("Archived Countries after shuffle \(archivedCountries)")
                    countries.append(archivedCountries[countriesCount-1])
 //                   print("Bacxkfill country is \(archivedCountries[countriesCount-1]) and country count is \(countriesCount)")
 //                   verifyAnswer()
                }
            } else {   //NOT Correct Answer we are here
                if countriesCount >= ContentView.numFlagsShownInit {
                    countries.shuffle()
                }else{
                    if countriesCount == 0{
                        return
                    }else{
                        correctAnswer = Int.random(in: 0..<ContentView.numFlagsShownInit)
                        countries[correctAnswer]=countries[0]
                        print("♥️ Correct Answer is \(correctAnswer) and countries[correctAnswer] is \(countries[correctAnswer])")
                        archivedCountries.shuffle()
                        var ran1 = Int.random(in: 0..<archivedCountries.count-1)
                        while ran1 == correctAnswer{
                            ran1 = Int.random(in: 0..<archivedCountries.count-1)
                        }
                        var ran2 = Int.random(in: 0..<archivedCountries.count-1)
                        while ran1 == ran2 || ran2 == correctAnswer{
                            ran2 = Int.random(in: 0..<archivedCountries.count-1)
                        }
                        print("😎 Ran1 = \(ran1) and Ran2 = \(ran2)!!!\n correctAnswer = \(correctAnswer)")
                        countries[1] = archivedCountries[ran1]
                        countries[2] = archivedCountries[ran2]
                        print("😇 \(countries) when correct answer is \(correctAnswer)")
                    }
                }
                correctAnswer = Int.random(in: 0..<answerRange)
            }
            questionCounter += 1
        }//end func askNextQuestion

    func padInput(){            
        correctAnswer = 0
    }
    func verifyAnswer(){
        let answerRange = min(countriesCount, ContentView.numFlagsShownInit)
       print("Value of countries[correctAnswer] is \(tempCountries[correctAnswer])")
        if validAnswers.contains(countries[correctAnswer]){
            return
        }
//       var myBool = validAnswers.contains(countries[correctAnswer])
    }
    
    func newGame() {
        let couple = ContentView.initCountries()
        countries = couple.array
        countriesCount = couple.count
        archivedCountries = []
        questionCounter = 1
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<ContentView.numFlagsShownInit)
    }
    
    func endGame() {
        exit(1)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
