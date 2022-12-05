import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


var testArray:[[String]] = [["N", "Z"], ["D", "C", "M"], ["P"]]
var inputArray:[[String]] = [["T", "Z", "B"], ["N", "D", "T", "H", "V"], ["D", "M", "F", "B"], ["L", "Q", "V", "W", "G", "J", "T"], ["M", "Q", "F", "V", "P", "G", "D", "W"], ["S", "F", "H", "G", "Q", "Z", "V"], ["W", "C", "T", "L", "R", "N", "S", "Z"], ["M", "R", "N", "J", "D", "W", "H", "Z"], ["S", "D", "F", "L", "Q", "M"]]



doTheTask(test, array: testArray) // CMZ
doTheTask(input, array: inputArray) // NTWZZWHFV


doTheTask(test, array: testArray, part2: true) // MCD
doTheTask(input, array: inputArray, part2: true) // BRZGFVBTJ




func doTheTask(_ string: String, array: [[String]], part2: Bool = false) -> String {

	var array = array

	let instructions = string.components(separatedBy: "\n")

	for instruction in instructions {
		if instruction.isEmpty || !instruction.contains("move") { continue }

		let count = Int(instruction.components(separatedBy: " from ").first!.components(separatedBy: "move ").last!)!
		let from = Int(instruction.components(separatedBy: " from ").last!.components(separatedBy: " to ").first!)! - 1
		let to = Int(instruction.components(separatedBy: " to ").last!)! - 1

		var fromArray = array[from]
		var toArray = array[to]

		if part2 {
			var tmpArray: [String] = []
			for _ in 0..<count { tmpArray.append(fromArray.removeFirst()) }

			toArray.insert(contentsOf: tmpArray, at: 0)
		} else {
			for _ in 0..<count { toArray.insert(fromArray.removeFirst(), at: 0) }
		}

		array[from] = fromArray
		array[to] = toArray
	}

	var topStackNames = ""

	for stack in array {
		topStackNames += stack.first ?? ""
	}

	return topStackNames
}
