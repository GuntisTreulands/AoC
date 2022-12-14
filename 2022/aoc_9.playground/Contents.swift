import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let testData2 = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test2", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!
let inputData2 = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input2", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var test2 = String(data:testData2, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!
var input2 = String(data:inputData2, encoding:String.Encoding.utf8)!

//doTask(test, numberOfKnots: 2) // Part1: 13
//doTask(input, numberOfKnots: 2) // Part1: 5735

doTask(test2, numberOfKnots: 10) // Part2: 36
//doTask(input, numberOfKnots: 10) // Part2: 2478


struct Location: Hashable {
	var x: Int
	var y: Int
}


func movement(startLocation: Location, endLocation: Location) -> Location {

	let realMovementLocation = Location.init(x: startLocation.x - endLocation.x, y: startLocation.y - endLocation.y)

	if abs(realMovementLocation.x) > 1 || abs(realMovementLocation.y) > 1 {
		return Location.init(x: min(1, max(-1, startLocation.x - endLocation.x)), y: min(1, max(-1, startLocation.y - endLocation.y)))
	}

	return Location.init(x: 0, y: 0)
}


func doTask(_ string: String, numberOfKnots: Int) {

	let instructions = string.components(separatedBy: "\n")

	var visitedLocations: Set<Location> = []

	var knots: [Location] = Array.init(repeating: Location.init(x: 1000, y: 1000), count: numberOfKnots)

	visitedLocations.insert(knots.first!)


	for instruction in instructions {
		if instruction.isEmpty  { continue }

		let direction = instruction.split(separator: " ").first!
		let steps = Int(instruction.split(separator: " ").last!)!

		for _ in 0..<steps {

			var tmpKnots: [Location] = []

			var currentKnot = knots.first!



			if direction == "R" {
				currentKnot.x = currentKnot.x + 1
			} else if direction == "U" {
				currentKnot.y = currentKnot.y - 1
			} else if direction == "L" {
				currentKnot.x = currentKnot.x - 1
			} else { // D
				currentKnot.y = currentKnot.y + 1
			}

			tmpKnots.append(currentKnot)

			var previousHeadLocation = currentKnot


			for index in 1..<knots.count {

				currentKnot = knots[index]

				let nextMove = movement(startLocation: previousHeadLocation, endLocation: currentKnot)

				currentKnot.x += nextMove.x
				currentKnot.y += nextMove.y

				previousHeadLocation = currentKnot

				tmpKnots.append(currentKnot)

				if index == knots.count - 1 {
					visitedLocations.insert(currentKnot)
				}
			}

			knots = tmpKnots

		}
	}

	print("Visited Locations \(visitedLocations.count)")



	print("FinalMap \n")
	for r in 980...1020 {
		var line = ""
		for c in 980...1020 {
			let targets = visitedLocations.filter( {$0.x == c && $0.y == r})
			if(1000 == c && 1000 == r) {
				line.append("s")
			}
			else if(targets.isEmpty == false) {
				line.append("#")
			}
			else {
				line.append(".")
			}
		}
		print("\(line)")
	}
}

