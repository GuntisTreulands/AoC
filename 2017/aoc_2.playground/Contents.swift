import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let testData2 = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test2", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var test2 = String(data:testData2, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


//doTask(test) // Part1: 18
//doTask(input) // Part1: 50376

doTask(test2, part2: true) // Part2: 9
doTask(input, part2: true) // Part2: 267

func doTask(_ string: String, part2: Bool = false) {

	let instructions = string.components(separatedBy: "\n")

	var sum = 0

	for instruction in instructions {

		if instruction.isEmpty { continue }

		let numbers = instruction.components(separatedBy: "\t")

		if part2 == false {
			var minNumber = Int(numbers.first!)!
			var maxNumber = Int(numbers.first!)!

			for number in numbers {
				minNumber = min(minNumber, Int(number)!)
				maxNumber = max(maxNumber, Int(number)!)
			}

			sum += maxNumber - minNumber
		} else {
			for index1 in 0..<numbers.count {
				for index2 in 0..<numbers.count {
					if index1 != index2 {
						let number1 = Int(numbers[index1])!
						let number2 = Int(numbers[index2])!
						if number1 % number2 == 0 {
							sum += number1 / number2
						}
					}
				}
			}
		}
	}

	if part2 == false {
		print("Spreadsheet checksum: \(sum)")
	} else {
		print("Sum of each row's result: \(sum)")
	}
}
