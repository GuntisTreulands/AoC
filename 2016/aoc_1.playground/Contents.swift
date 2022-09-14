import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let testData2 = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test2", ofType: "txt")!)!
let testData3 = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test3", ofType: "txt")!)!
let testData4 = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test4", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var test2 = String(data:testData2, encoding:String.Encoding.utf8)!
var test3 = String(data:testData3, encoding:String.Encoding.utf8)!
var test4 = String(data:testData4, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

test = test.replacingOccurrences(of: "\n", with: "")
test2 = test2.replacingOccurrences(of: "\n", with: "")
test3 = test3.replacingOccurrences(of: "\n", with: "")
test4 = test4.replacingOccurrences(of: "\n", with: "")
input = input.replacingOccurrences(of: "\n", with: "")

calculateDistanceAfterSteps(test)  // 5
calculateDistanceAfterSteps(test2) // 2
calculateDistanceAfterSteps(test3) // 12
calculateDistanceAfterSteps(input) // 250
calculateDistanceAfterSteps(test4, part2: true) // 4
calculateDistanceAfterSteps(input, part2: true) // 151

enum Direction {
  case top, right, bottom, left
}

func calculateDistanceAfterSteps(_ input: String, part2: Bool = false) {
	var steps = input.components(separatedBy: ", ")
	steps.removeAll(where: { $0.isEmpty == true })

	var x = 0
	var y = 0

	var direction: Direction = .top

	var stopPoints = [String]()

	for step in steps {
		let distance = Int(step.suffix(step.count-1))!

		if step.contains("L") {
			direction = directionFrom(current: direction, toLeft: true)
		} else {
			direction = directionFrom(current: direction, toLeft: false)
		}

		for _ in 0..<distance
		{
			switch direction {
				case .top:
					x += 1
				case .right:
					y += 1
				case .bottom:
					x -= 1
				case .left:
					y -= 1
			}

			if part2 == true && stopPoints.contains("\(x) - \(y)") {
				print("Part 2: x = \(x), y = \(y), Total: \(abs(x)+abs(y))")
				return
			}

			stopPoints.append("\(x) - \(y)")
		}
	}

	print("Part 1: x = \(x), y = \(y), Total: \(abs(x)+abs(y))")
}


func directionFrom(current direction: Direction, toLeft: Bool) -> Direction {
	if direction == .top {
		return toLeft == true ? .left : .right
	} else if direction == .left {
		return toLeft == true ? .bottom : .top
	} else if direction == .bottom {
		return toLeft == true ? .right : .left
	} else {
		return toLeft == true ? .top : .bottom
	}
}
