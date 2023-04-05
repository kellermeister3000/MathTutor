//
//  ContentView.swift
//  MathTutor
//
//  Created by Philip Keller on 4/4/23.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @FocusState private var textFieldIsFocused: Bool
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @State private var audioPlayer: AVAudioPlayer!
    @State private var textFieldIsDisable = false
    @State private var guessButtonDisabled = false
    @State private var message = ""
    
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    var body: some View {
        VStack {
            Group {
                Text(firstNumberEmojis)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                Text("+")
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                Text(secondNumberEmojis)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            Spacer()
            
            Text("\(firstNumber) + \(secondNumber) =")
            
            .font(.largeTitle)
            
            TextField("", text: $answer)
                .font(.largeTitle)
                .textFieldStyle(.roundedBorder)
                .frame(width: 60)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .focused($textFieldIsFocused)
                .disabled(textFieldIsDisable)
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundColor(message == "Correct!" ? .green : .red)
            
            if guessButtonDisabled {
                Button("Play Again?") {
                    guessButtonDisabled = false
                    answer = ""
                    textFieldIsDisable = false
                    message = ""
                    generateNewEquation()
                }
            }
            
            Button("Guess") {
                textFieldIsFocused = false
                let result = firstNumber + secondNumber
                if let answerValue = Int(answer) {
                    if answerValue == result {
                        playSound(soundName: "correct")
                        message = "Correct!"
                    } else {
                        playSound(soundName: "wrong")
                        message = "Sorry, the correct answer is \(firstNumber + secondNumber)"
                    }
                } else {
                    playSound(soundName: "wrong")
                    message = "Sorry, the correct answer is \(firstNumber + secondNumber)"
                }
                textFieldIsDisable = true
                guessButtonDisabled = true
            }
            .padding()
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || guessButtonDisabled)
        }
        .padding()
        .onAppear {
            generateNewEquation()
        }
    }
    
    func generateNewEquation() {
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = String(repeating: emojis.randomElement()!, count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement()!, count: secondNumber)
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 ERROR: Could not read file named \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) playing audioPlayer")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
