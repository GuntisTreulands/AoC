import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


totalScore(test) //15
totalScore(input) //10310

totalScoreV2(test) //12
totalScoreV2(input) //14859

func totalScore(_ string: String) -> Int {

	var adjustments = string.replacingOccurrences(of: "X", with: "A") // Rock
	adjustments = adjustments.replacingOccurrences(of: "Y", with: "B") // Paper
	adjustments = adjustments.replacingOccurrences(of: "Z", with: "C") // Scissors

	let steps = adjustments.components(separatedBy: "\n")

	var totalPoints = 0

	for step in steps {
		if step.isEmpty {
			continue
		}

		let oponentMove = String(step.prefix(1))
		let myMove = String(step.suffix(1))

		if oponentMove == myMove { // draw
			if myMove == "A" {
				totalPoints += 1 + 3
			} else if myMove == "B" {
				totalPoints += 2 + 3
			} else {
				totalPoints += 3 + 3
			}
		} else if oponentMove == "A" {
			if myMove == "B" {
				// I win
				totalPoints += 6 + 2
			} else if myMove == "C" {
				// I lose
				totalPoints += 0 + 3
			}
		} else if oponentMove == "B" {
			if myMove == "A" {
				// I lose
				totalPoints += 0 + 1
			} else if myMove == "C" {
				// I win
				totalPoints += 6 + 3
			}
		} else if oponentMove == "C" {
			if myMove == "A" {
				// I win
				totalPoints += 6 + 1
			} else if myMove == "B" {
				// I lose
				totalPoints += 0 + 2
			}
		}
	}

	return totalPoints
}



func totalScoreV2(_ string: String) -> Int {

	let steps = string.components(separatedBy: "\n")

	var totalPoints = 0

	for step in steps {
		if step.isEmpty {
			continue
		}

		let oponentMove = String(step.prefix(1))
		let myMove = String(step.suffix(1))

		if myMove == "X" { // I need to lose
			if oponentMove == "A" {
				totalPoints += 0 + 3
			} else if oponentMove == "B" {
				totalPoints += 0 + 1
			} else {
				totalPoints += 0 + 2
			}
		} else if myMove == "Y" { // I need a draw
			if oponentMove == "A" {
				totalPoints += 3 + 1
			} else if oponentMove == "B" {
				totalPoints += 3 + 2
			} else {
				totalPoints += 3 + 3
			}
		} else { // I need to win
			if oponentMove == "A" {
				totalPoints += 6 + 2
			} else if oponentMove == "B" {
				totalPoints += 6 + 3
			} else {
				totalPoints += 6 + 1
			}
		}
	}

	return totalPoints
}
