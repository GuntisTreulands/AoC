import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


doTask(test) // Part1: 13140
doTask(input) // Part1: 12980   Part2: BRJLFULP


func doTask(_ string: String) {

	let instructions = string.components(separatedBy: "\n")

	var tasks:[Int: [Int]] = [:]

	var counter = 0
	for instruction in instructions {
		if instruction.isEmpty  { continue }

		tasks[counter] = tasks[counter, default: []]

		if instruction == "noop" {
			var tmpArray = tasks[counter, default: []]
			tmpArray.append(0)
			tasks[counter] = tmpArray
		} else {
			let addx = Int(instruction.split(separator: " ").last!)!

			tasks[counter + 1] = tasks[counter + 1, default: []]

			var tmpArray = tasks[counter + 2, default: []]
			tmpArray.append(addx)
			tasks[counter + 2] = tmpArray

			counter += 1
		}

		counter += 1
	}

	
	var x = 1
	var signalSum = 0
	var adjustedCycle = 0

	var lines: [String] = []
	var line: String = ""

	for cycle in 0..<tasks.count {

		if cycle == 20 || cycle == 60 || cycle == 100 || cycle == 140 || cycle == 180 || cycle == 220 {
			signalSum += x * cycle
		}

		if cycle == 40 || cycle == 80 || cycle == 120 || cycle == 160 || cycle == 200 || cycle == 240 {

			adjustedCycle -= 40

			lines.append(line)
			line = ""
		}

		var steps = tasks[cycle]!

		//print("Cycle: \(cycle) | x = \(x) | steps \(steps)")

		for step in steps {
			x += step
		}

		if adjustedCycle == x || adjustedCycle == x - 1 || adjustedCycle == x + 1 {
			line += "#"
		} else {
			line += "."
		}

		adjustedCycle += 1
	}

	lines.append(line)

	print("\nSignal Sum: \(signalSum)\n")

	for line in lines {
		print(line)
	}

}
