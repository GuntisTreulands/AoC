import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let testData2 = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test2", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var test2 = String(data:testData2, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

doTheTask(test) // 5, 6, 10, 11
doTheTask(input) // 1356

doTheTask(test2, markerLength: 14) // 19, 23, 23, 29, 26
doTheTask(input, markerLength: 14) // 2564


func doTheTask(_ string: String, markerLength: Int = 4) {

	let instructions = string.components(separatedBy: "\n")

	for instruction in instructions {
		if instruction.isEmpty  { continue }

		var buffer: [String] = []

		var index = 0

		for char in instruction {

			index += 1
			buffer.append(String(char))

			if(buffer.count > markerLength) {
				buffer.removeFirst()
			}

			if buffer.count == markerLength && Set.init(buffer).count == buffer.count {
				break
			}

		}

		print("Instruction \(instruction) - start at \(index)")
	}
}
