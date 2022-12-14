import UIKit
import Foundation
import GameplayKit


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

//doTask(test) // Part1: 24
//doTask(input) // Part1: 838


//doTask(test, addFloor: true) // Part2: 93
doTask(input, addFloor: true) // Part2: 27539

enum Fill {
	case Sand, Rock, Air
}


var leastX = 500
var leastY = 0
var maxX = 500
var maxY = 0

func doTask(_ string: String, addFloor: Bool = false) {

	var fillCoordinates: [String: Fill] = [:]

	leastX = 500
	leastY = 0
	maxX = 500
	maxY = 0

	let instructions = string.components(separatedBy: "\n")

	for instruction in instructions {
		if instruction.isEmpty  { continue }

		let steps = instruction.components(separatedBy: " -> ")

		for index in 0..<steps.count-1 {
			let firstCoordinates = steps[index].split(separator: ",")
			let lastCoordinates = steps[index + 1].split(separator: ",")

			var firstCoodinatesX = Int(firstCoordinates.first!)!
			var firstCoodinatesY = Int(firstCoordinates.last!)!

			var lastCoodinatesX = Int(lastCoordinates.first!)!
			var lastCoodinatesY = Int(lastCoordinates.last!)!


			if firstCoodinatesX < leastX || leastX == 0 { leastX = firstCoodinatesX }
			if lastCoodinatesX < leastX || leastX == 0 { leastX = lastCoodinatesX }

			if firstCoodinatesY < leastY { leastY = firstCoodinatesY }
			if lastCoodinatesY < leastY { leastY = lastCoodinatesY }

			if lastCoodinatesX > maxX || maxX == 0 { maxX = lastCoodinatesX }
			if firstCoodinatesX > maxX || maxX == 0 { maxX = firstCoodinatesX }

			if lastCoodinatesY > maxY{ maxY = lastCoodinatesY }
			if firstCoodinatesY > maxY{ maxY = firstCoodinatesY }



			if firstCoodinatesX > lastCoodinatesX {
				firstCoodinatesX = Int(lastCoordinates.first!)!
				lastCoodinatesX = Int(firstCoordinates.first!)!
			}

			if firstCoodinatesY > lastCoodinatesY {
				firstCoodinatesY = Int(lastCoordinates.last!)!
				lastCoodinatesY = Int(firstCoordinates.last!)!
			}

			for x in firstCoodinatesX...lastCoodinatesX {
				for y in firstCoodinatesY...lastCoodinatesY {
					fillCoordinates["\(x)-\(y)"] = .Rock
				}
			}
		}
	}

	if addFloor {
		leastX -= 10
		maxX += 10
		maxY += 2
		for x in (leastX - 4000)...(maxX + 4000) {
			fillCoordinates["\(x)-\(maxY)"] = .Rock
		}
	}


	var maxCount = 0

	for index in 0..<1000000 {
		let result = dropSand(fillCoordinates: &fillCoordinates)

//		if index % 1000 == 0 {
//			draw(fillCoordinates: fillCoordinates)
//		}

		if result == false {
			break
		} else {
			maxCount += 1

			if fillCoordinates["\(500)-\(0)", default: .Air] == Fill.Sand {
				break
			}
		}
	}

	draw(fillCoordinates: fillCoordinates)

	print("In total \(maxCount) units of sand come to rest before sand starts flowing into the abyss below.")
}

func dropSand(fillCoordinates: inout [String: Fill]) -> Bool {

	var posY = 0
	var posX = 500

	for _ in 0..<1000 {
		
		let down = fillCoordinates["\(posX)-\(posY+1)", default: .Air]
		let downLeft = fillCoordinates["\(posX-1)-\(posY+1)", default: .Air]
		let downRight = fillCoordinates["\(posX+1)-\(posY+1)", default: .Air]

		if down == .Air {
			posY = posY + 1
		} else if downLeft == .Air {
			posY = posY + 1
			posX = posX - 1
		} else if downRight == .Air {
			posY = posY + 1
			posX = posX + 1
		} else {
			fillCoordinates["\(posX)-\(posY)"] = .Sand
			return true
		}

//		print("posX \(posX) | posY \(posY)")
//
//		draw(fillCoordinates: fillCoordinates, tmpX: posX, tmpY: posY)
	}

	return false
}


func draw(fillCoordinates: [String: Fill], tmpX: Int = -1, tmpY: Int = -1) {
	print("\n")

//	print("leastX \(leastX) maxX \(maxX) leastY \(leastY) maxY \(maxY)")
	for y in (leastY - 1)...(maxY + 1) {
		var line = ""
		for x in (leastX - 1)...(maxX + 1) {

			let fill = fillCoordinates["\(x)-\(y)", default: .Air]

			if fill == .Rock {
				line += "#"
			} else if fill == .Sand {
				line += "o"
			} else if x == 500 && y == 0 {
				line += "+"
			} else if x == tmpX && y == tmpY {
				line += "*"
			} else {
				line += "."
			}
		}

		print(line)
	}
}
