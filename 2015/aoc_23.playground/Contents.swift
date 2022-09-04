import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


findOutValues(test) // 2
findOutValues(input) // Part 1: 170
findOutValues(input, part2: true) // Part 2: 170


func findOutValues(_ test: String, part2: Bool = false) {

	var instructions = test.components(separatedBy: "\n")

	instructions.removeAll(where: {$0.isEmpty})

	var currentRegisters = [String: UInt]()

	if part2 {
		currentRegisters["a"] = 1
	}

	var shouldContinue = true

	var index = 0

	repeat {

		let instruction = instructions[index]

		if instruction.contains("hlf") {
			let register = instruction.components(separatedBy: "hlf ").last!
			if currentRegisters[register, default: 0] != 0 {
				currentRegisters[register] = currentRegisters[register, default: 0] / 2
			}
			index += 1
		} else if instruction.contains("tpl") {
			let register = instruction.components(separatedBy: "tpl ").last!

			if currentRegisters[register, default: 0] != 0 {
				currentRegisters[register] = currentRegisters[register, default: 0] * 3
			}
			index += 1
		} else if instruction.contains("inc") {
			let register = instruction.components(separatedBy: "inc ").last!
			currentRegisters[register] = currentRegisters[register, default: 0] + 1
			index += 1
		} else if instruction.contains("jmp") {
			let jump = instruction.components(separatedBy: "jmp ").last!
			index = index + (Int(jump)!)
		} else if instruction.contains("jie") {
			let registerAndJump = instruction.components(separatedBy: "jie ").last!
			let register = registerAndJump.components(separatedBy: ", ").first!
			let jump = registerAndJump.components(separatedBy: ", ").last!

			if currentRegisters[register, default: 0] % 2 == 0 {
				index = index + (Int(jump)!)
			} else {
				index += 1
			}
		} else if instruction.contains("jio") {
			let registerAndJump = instruction.components(separatedBy: "jio ").last!
			let register = registerAndJump.components(separatedBy: ", ").first!
			let jump = registerAndJump.components(separatedBy: ", ").last!

			if currentRegisters[register, default: 0] == 1 {
				index = index + (Int(jump)!)
			} else {
				index += 1
			}
		}

		if index < 0 || index >= instructions.count {
			shouldContinue = false
		}

	} while shouldContinue


	for key in currentRegisters.keys {
		print("Register \(key) = \(currentRegisters[key]!)")
	}
}
