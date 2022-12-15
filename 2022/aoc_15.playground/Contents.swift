import UIKit
import Foundation
import GameplayKit


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

//doTask(test, targetLine: 10) // Part1: 26
//doTask(input, targetLine: 2000000) // Part1: 5240818


doTask(test, maxCoordinate: 20) // Part2: 56000011
//doTask(input, maxCoordinate: 4000000) // Part2: Y: 2906101  X:3303271  Tuning: 13213086906101


struct Location: Hashable {
	var posX: Int
	var posY: Int
}

struct Result {
	var posX: Int
	var posY: Int
	var beaconX: Int
	var beaconY: Int


	func getInterval(targetLine: Int) -> (x1: Int, x2: Int)? {

		let xDiff = abs(beaconX - posX)
		let yDiff = abs(beaconY - posY)

		let extended = xDiff + yDiff

		if posY-extended < targetLine && posY+extended > targetLine {
			var interval = (x1: 0, x2: 0)

			let difference = posY - targetLine

			interval.x1 = posX - (extended - abs(difference))
			interval.x2 = posX + (extended - abs(difference))

			return interval
		}

		return nil
	}
}


func doTask(_ string: String, targetLine: Int = 0, maxCoordinate: Int = 0) {

	var dataArray: [Result] = []

	let instructions = string.components(separatedBy: "\n")
	
	for instruction in instructions {
		if instruction.isEmpty  { continue }

		let tmp = instruction.components(separatedBy: ": closest beacon is at x=")

		let sensorX = Int(tmp.first!.components(separatedBy: "x=").last!.components(separatedBy: ", ").first!)!
		let sensorY = Int(tmp.first!.components(separatedBy: "y=").last!)!

		let beaconX = Int(tmp.last!.components(separatedBy: ", y=").first!)!
		let beaconY = Int(tmp.last!.components(separatedBy: ", y=").last!)!

		dataArray.append(Result.init(posX: sensorX, posY: sensorY, beaconX: beaconX, beaconY: beaconY))
	}


	if maxCoordinate == 0 {
		var coordinates = Set<Int>()
		var items = [Int]()

		var index = 0
		for result in dataArray {
			print("\(index) \\ \(dataArray.count)")
			index += 1
			if let interval = result.getInterval(targetLine: targetLine) {
				let array = Array(interval.x1...interval.x2)
				items.append(contentsOf: array)
			}
		}

		coordinates = Set(items)

		for result in dataArray {
			if result.beaconY == targetLine {
				coordinates.remove(result.beaconX)
			}
		}


		print("In the row where y=\(targetLine), \(coordinates.count) positions cannot contain a beacon.")

	} else {

		var targetX = 0
		var targetY = 0

		// Test draw
		if maxCoordinate < 100 {
			for y in 0...maxCoordinate {
				var line = "\(y)\t"
				for x in 0...maxCoordinate {

					var sFound = false
					var bFound = false
					var rFound = false

					for result in dataArray {
						let interval = result.getInterval(targetLine: y)

						if !sFound && result.posX == x && result.posY == y {
							line += "S"
							sFound = true
						} else if !bFound && result.beaconX == x && result.beaconY == y {
							line += "B"
							bFound = true
						}

						if !rFound && !bFound && !sFound {
							if let interval = interval {
								let array = Array(interval.x1...interval.x2)
								if array.contains(x) {
									line += "#"
									rFound = true
								}
							}
						}
					}

					if !sFound && !bFound && !rFound {
						line += "."
					}
				}

				print(line)
			}
		}


		for y in 0...maxCoordinate {
			var intervals = [(x1: Int, x2: Int)]()
			for result in dataArray {
				if let interval = result.getInterval(targetLine: y) {
					intervals.append(interval)
				}
			}

			if intervals.isEmpty {
				break
			}

			let mergedIntervals = mergedIntervals(intervals: intervals)

			if mergedIntervals.count > 1 {
				print("\(y) = \(intervals.sorted { $0.x1 < $1.x2 }) -> \t\(mergedIntervals)")

				targetX = mergedIntervals.first!.x2 + 1
				targetY = y
			}
		}

		print("Tuning frequency of the distress signal at coordinates \(targetX) \(targetY) is \(targetX * 4000000 + targetY)")
	}
}



func mergedIntervals(intervals: [(x1: Int, x2: Int)]) -> [(x1: Int, x2: Int)] {

	var sortedIntervals = intervals.sorted { $0.x1 < $1.x2 }
	var mergedIntervals = [sortedIntervals.first!]

	var canMerge = true

	repeat {
		canMerge = false
		for index in 1..<sortedIntervals.count {
			let current = sortedIntervals[index]
			var previous = mergedIntervals.last!
			if current.x1 - 1  <= previous.x2 {
				previous.x1 = min(previous.x1, current.x1)
				previous.x2 = max(previous.x2, current.x2)
				mergedIntervals.removeLast()
				mergedIntervals.append(previous)
				canMerge = true
			} else {
				mergedIntervals.append(current)
			}
		}
		if canMerge {
			sortedIntervals = mergedIntervals
			mergedIntervals = [sortedIntervals.first!]
		}
	} while canMerge == true
	

	return mergedIntervals
}
