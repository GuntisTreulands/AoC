import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let testData2 = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test2", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var test2 = String(data:testData2, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


//doTask(test) // Part1: 3, 4, 0, 9
//doTask(input) // Part1: 1175

doTask(test2, part2: true) // Part2: 6, 0, 4, 12, 4
doTask(input, part2: true) // Part2: 1166

func doTask(_ string: String, part2: Bool = false) {

	let instructions = string.components(separatedBy: "\n")

	for instruction in instructions {

		if instruction.isEmpty { continue }

		var items = Array(instruction)
		var sum = 0

		if part2 == false {
			items.append(items.first!)

			for index in 0..<items.count - 1 {
				let firstItem = items[index]
				let secondItem = items[index + 1]

				if firstItem == secondItem {
					sum += Int(String(firstItem))!
				}
			}
		} else {
			items += items
			items.append(items.first!)

			for index in 0..<instruction.count {
				let firstItem = items[index]
				let secondItem = items[index + instruction.count / 2]

				if firstItem == secondItem {
					sum += Int(String(firstItem))!
				}
			}
		}

		print("\n\(instruction) produces a sum of \(sum)")
	}

}
