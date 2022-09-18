import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

var keyPadPart1 = [
	["1", "2", "3"],
	["4", "5", "6"],
	["7", "8", "9"]
]

var keyPadPart2 = [
	["*", "*", "1", "*", "*"],
	["*", "2", "3", "4", "*"],
	["5", "6", "7", "8", "9"],
	["*", "A", "B", "C", "*"],
	["*", "*", "D", "*", "*"]
]

calculateCodeFromInstructions(test, keyPad: keyPadPart1) // 1985
calculateCodeFromInstructions(input, keyPad: keyPadPart1) // 61529


calculateCodeFromInstructions(test, keyPad: keyPadPart2) // 5DB3
calculateCodeFromInstructions(input, keyPad: keyPadPart2) // C2C28


func calculateCodeFromInstructions(_ instructions: String, keyPad: [[String]]) {
	var codeItems = instructions.components(separatedBy: "\n")
	codeItems.removeAll(where: { $0.isEmpty == true })



	let keypadMax = keyPad.count-1

	var x = 0
	var y = 0

	// Find "5". Always start with "5"
	for (yIndex, yLine) in keyPad.enumerated() {
		for (xIndex, xItem) in yLine.enumerated() {
			if xItem == "5" {
				x = xIndex
				y = yIndex
			}
		}
	}


	var calculatedCode = ""

	for codeItem in codeItems {
		for code in codeItem {
			if code == "U" {
				if keyPad[max(0, y - 1)][x] != "*" {
					y = max(0, y - 1)
				}
			} else if code == "L" {
				if keyPad[y][max(0, x - 1)] != "*" {
					x = max(0, x - 1)
				}
			} else if code == "R" {
				if keyPad[y][min(keypadMax, x + 1)] != "*" {
					x = min(keypadMax, x + 1)
				}
			} else if code == "D" {
				if keyPad[min(keypadMax, y + 1)][x] != "*" {
					y = min(keypadMax, y + 1)
				}
			}
		}
		calculatedCode += keyPad[y][x]
	}

	print("Calculated code: \(calculatedCode)")
}

