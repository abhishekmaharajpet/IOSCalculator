//
//  ContentView.swift
//  MyFirstIOSApp
//
//  Created by Admin1 on 14/01/25.
//

import SwiftUI

struct ContentView: View {
    @State private var display: String = "0" // Holds the current display text
        @State private var firstNumber: Double? = nil
        @State private var currentOperation: String? = nil
        @State private var isTyping: Bool = false

        let buttons = [
            ["C", "±", "%", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "−"],
            ["1", "2", "3", "+"],
            ["0", ".", "="]
        ]

        var body: some View {
            VStack(spacing: 12) {
                Spacer()
                // Display Area
                Text(display)
                    .font(.system(size: 64))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                // Buttons Grid
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.buttonTapped(button)
                            }) {
                                Text(button)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(for: button),
                                           height: self.buttonHeight())
                                    .background(self.buttonColor(for: button))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
        }

        private func buttonTapped(_ button: String) {
            switch button {
            case "C":
                clear()
            case "±":
                toggleSign()
            case "%":
                applyPercentage()
            case "÷", "×", "−", "+":
                setOperation(button)
            case "=":
                calculateResult()
            default:
                appendNumber(button)
            }
        }

        private func clear() {
            display = "0"
            firstNumber = nil
            currentOperation = nil
            isTyping = false
        }

        private func toggleSign() {
            if let value = Double(display) {
                display = "\(value * -1)"
            }
        }

        private func applyPercentage() {
            if let value = Double(display) {
                display = "\(value / 100)"
            }
        }

        private func setOperation(_ operation: String) {
            currentOperation = operation
            firstNumber = Double(display)
            isTyping = false
        }

        private func calculateResult() {
            guard let operation = currentOperation, let first = firstNumber, let second = Double(display) else { return }
            var result: Double = 0
            switch operation {
            case "+":
                result = first + second
            case "−":
                result = first - second
            case "×":
                result = first * second
            case "÷":
                result = second != 0 ? first / second : 0
            default:
                break
            }
            display = "\(result)"
            currentOperation = nil
            firstNumber = nil
            isTyping = false
        }

        private func appendNumber(_ number: String) {
            if isTyping {
                display += number
            } else {
                display = number == "." ? "0." : number
                isTyping = true
            }
        }

        private func buttonWidth(for button: String) -> CGFloat {
            button == "0" ? (UIScreen.main.bounds.width - 48) / 2 : (UIScreen.main.bounds.width - 60) / 4
        }

        private func buttonHeight() -> CGFloat {
            (UIScreen.main.bounds.width - 60) / 4
        }

        private func buttonColor(for button: String) -> Color {
            if ["÷", "×", "−", "+", "="].contains(button) {
                return Color.orange
            } else if ["C", "±", "%"].contains(button) {
                return Color.gray
            } else {
                return Color.darkGray
            }
        }
    }

    extension Color {
        static let darkGray = Color(white: 0.2)
    }
