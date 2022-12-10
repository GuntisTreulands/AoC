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


//doPart1(test) // Part1: 13
//doPart1(input) // Part1: 5735

//doPart2(test2) // 36 (Correct)

//doPart2(input) //2343 too low  // 2362?

doPart2(input2) // Should be 2630!!! (Benchmark) I get 2530


struct Location: Hashable {
	var x: Int
	var y: Int
}

enum Directions {
	case left, right, top, bottom
}


func doPart1(_ string: String) {

	let instructions = string.components(separatedBy: "\n")

	var visitedLocations: Set<Location> = []


	var head = Location.init(x: 1000, y: 1000)
	var tail1 = Location.init(x: 1000, y: 1000)

	visitedLocations.insert(head)


	for instruction in instructions {
		if instruction.isEmpty  { continue }

		let direction = instruction.split(separator: " ").first!
		let steps = Int(instruction.split(separator: " ").last!)!

		for _ in 0..<steps {

			var previousHeadLocation = head
			var previousTailLocation = tail1

			if direction == "R" {
				head.x = head.x + 1
			} else if direction == "U" {
				head.y = head.y - 1
			} else if direction == "L" {
				head.x = head.x - 1
			} else { // D
				head.y = head.y + 1
			}

			if abs(abs(tail1.x) - abs(head.x)) > 1
				|| abs(abs(tail1.y) - abs(head.y)) > 1 {

				previousTailLocation = tail1
				tail1 = previousHeadLocation
				previousHeadLocation = previousTailLocation

				visitedLocations.insert(tail1)
			}
		}
	}


	print("Visited Locations \(visitedLocations.count)")
}



func doPart2(_ string: String) {

	let instructions = string.components(separatedBy: "\n")

	var visitedLocations: Set<Location> = []


	var head = Location.init(x: 1000, y: 1000)
	var tail1 = Location.init(x: 1000, y: 1000)
	var tail2 = Location.init(x: 1000, y: 1000)
	var tail3 = Location.init(x: 1000, y: 1000)
	var tail4 = Location.init(x: 1000, y: 1000)
	var tail5 = Location.init(x: 1000, y: 1000)
	var tail6 = Location.init(x: 1000, y: 1000)
	var tail7 = Location.init(x: 1000, y: 1000)
	var tail8 = Location.init(x: 1000, y: 1000)
	var tail9 = Location.init(x: 1000, y: 1000)

	visitedLocations.insert(head)


	for instruction in instructions {
		if instruction.isEmpty  { continue }

		let direction = instruction.split(separator: " ").first!
		let steps = Int(instruction.split(separator: " ").last!)!

		var dir: Directions = .top

		for _ in 0..<steps {

			var previousHeadLocation = head
			var previousTailLocation = tail1

			if direction == "R" {
				head.x = head.x + 1
			} else if direction == "U" {
				head.y = head.y - 1
			} else if direction == "L" {
				head.x = head.x - 1
			} else { // D
				head.y = head.y + 1
			}

			if abs(abs(tail1.x) - abs(head.x)) > 1
				|| abs(abs(tail1.y) - abs(head.y)) > 1 {

				previousTailLocation = tail1
				tail1 = previousHeadLocation
				previousHeadLocation = previousTailLocation
			}


			if abs(abs(tail2.x) - abs(tail1.x)) > 1
				|| abs(abs(tail2.y) - abs(tail1.y)) > 1 {


				previousTailLocation = tail2

				if(previousHeadLocation.x != tail1.x && previousHeadLocation.y != tail1.y) {

					let moveX = (tail1.x - previousHeadLocation.x) == 0 ? 0 : ((tail1.x - previousHeadLocation.x) > 0 ? 1 : -1)
					let moveY = (tail1.y - previousHeadLocation.y) == 0 ? 0 : ((tail1.y - previousHeadLocation.y) > 0 ? 1 : -1)
					tail2 = Location.init(x: tail2.x + moveX, y: tail2.y + moveY)
					if isConnected(to: tail1, from: tail2) == false {
						previousTailLocation = tail2
						tail2 = closestLocation(to: tail1, direction: dir)
					}
					dir = cleanConnectionSide(to: tail1, from: tail2)

				} else {
					dir = directionFrom(tail2, to: previousHeadLocation)
					tail2 = previousHeadLocation
				}
				previousHeadLocation = previousTailLocation

			}


			if abs(abs(tail3.x) - abs(tail2.x)) > 1
				|| abs(abs(tail3.y) - abs(tail2.y)) > 1 {

				previousTailLocation = tail3

				if(previousHeadLocation.x != tail2.x && previousHeadLocation.y != tail2.y) {

					let moveX = (tail2.x - previousHeadLocation.x) == 0 ? 0 : ((tail2.x - previousHeadLocation.x) > 0 ? 1 : -1)
					let moveY = (tail2.y - previousHeadLocation.y) == 0 ? 0 : ((tail2.y - previousHeadLocation.y) > 0 ? 1 : -1)
					tail3 = Location.init(x: tail3.x + moveX, y: tail3.y + moveY)

					if isConnected(to: tail2, from: tail3) == false {
						previousTailLocation = tail3
						tail3 = closestLocation(to: tail2, direction: dir)
					}
					dir = cleanConnectionSide(to: tail2, from: tail3)

				} else {
					dir = directionFrom(tail3, to: previousHeadLocation)
					tail3 = previousHeadLocation
				}

				previousHeadLocation = previousTailLocation
			}


			if abs(abs(tail4.x) - abs(tail3.x)) > 1
				|| abs(abs(tail4.y) - abs(tail3.y)) > 1 {

				previousTailLocation = tail4
				if(previousHeadLocation.x != tail3.x && previousHeadLocation.y != tail3.y) {
					let moveX = (tail3.x - previousHeadLocation.x) == 0 ? 0 : ((tail3.x - previousHeadLocation.x) > 0 ? 1 : -1)
					let moveY = (tail3.y - previousHeadLocation.y) == 0 ? 0 : ((tail3.y - previousHeadLocation.y) > 0 ? 1 : -1)
					tail4 = Location.init(x: tail4.x + moveX, y: tail4.y + moveY)
					if isConnected(to: tail3, from: tail4) == false {

						previousTailLocation = tail4
						tail4 = closestLocation(to: tail3, direction: dir)
					}
					dir = cleanConnectionSide(to: tail3, from: tail4)

				} else {
					dir = directionFrom(tail4, to: previousHeadLocation)
					tail4 = previousHeadLocation
				}

				previousHeadLocation = previousTailLocation
			}




			if abs(abs(tail5.x) - abs(tail4.x)) > 1
				|| abs(abs(tail5.y) - abs(tail4.y)) > 1 {

				previousTailLocation = tail5

				if(previousHeadLocation.x != tail4.x && previousHeadLocation.y != tail4.y) {

					let moveX = (tail4.x - previousHeadLocation.x) == 0 ? 0 : ((tail4.x - previousHeadLocation.x) > 0 ? 1 : -1)
					let moveY = (tail4.y - previousHeadLocation.y) == 0 ? 0 : ((tail4.y - previousHeadLocation.y) > 0 ? 1 : -1)
					tail5 = Location.init(x: tail5.x + moveX, y: tail5.y + moveY)
					if isConnected(to: tail4, from: tail5) == false {

						previousTailLocation = tail5

						tail5 = closestLocation(to: tail4, direction: dir)
					}
					dir = cleanConnectionSide(to: tail4, from: tail5)

				} else {
					dir = directionFrom(tail5, to: previousHeadLocation)
					tail5 = previousHeadLocation
				}

				previousHeadLocation = previousTailLocation
			}


			if abs(abs(tail6.x) - abs(tail5.x)) > 1
				|| abs(abs(tail6.y) - abs(tail5.y)) > 1 {

				previousTailLocation = tail6

				if(previousHeadLocation.x != tail5.x && previousHeadLocation.y != tail5.y) {

					let moveX = (tail5.x - previousHeadLocation.x) == 0 ? 0 : ((tail5.x - previousHeadLocation.x) > 0 ? 1 : -1)
					let moveY = (tail5.y - previousHeadLocation.y) == 0 ? 0 : ((tail5.y - previousHeadLocation.y) > 0 ? 1 : -1)
					tail6 = Location.init(x: tail6.x + moveX, y: tail6.y + moveY)
					if isConnected(to: tail5, from: tail6) == false {

						previousTailLocation = tail6
						tail6 = closestLocation(to: tail5, direction: dir)
					}
					dir = cleanConnectionSide(to: tail5, from: tail6)


				} else {
					dir = directionFrom(tail6, to: previousHeadLocation)
					tail6 = previousHeadLocation
				}

				previousHeadLocation = previousTailLocation
			}


			if abs(abs(tail7.x) - abs(tail6.x)) > 1
				|| abs(abs(tail7.y) - abs(tail6.y)) > 1 {

				previousTailLocation = tail7

				if(previousHeadLocation.x != tail6.x && previousHeadLocation.y != tail6.y) {

					let moveX = (tail6.x - previousHeadLocation.x) == 0 ? 0 : ((tail6.x - previousHeadLocation.x) > 0 ? 1 : -1)
					let moveY = (tail6.y - previousHeadLocation.y) == 0 ? 0 : ((tail6.y - previousHeadLocation.y) > 0 ? 1 : -1)
					tail7 = Location.init(x: tail7.x + moveX, y: tail7.y + moveY)

					if isConnected(to: tail6, from: tail7) == false {

						previousTailLocation = tail7

						tail7 = closestLocation(to: tail6, direction: dir)
					}
					dir = cleanConnectionSide(to: tail6, from: tail7)

				} else {
					dir = directionFrom(tail7, to: previousHeadLocation)
					tail7 = previousHeadLocation
				}

				previousHeadLocation = previousTailLocation
			}


			if abs(abs(tail8.x) - abs(tail7.x)) > 1
				|| abs(abs(tail8.y) - abs(tail7.y)) > 1 {

				previousTailLocation = tail8

				if(previousHeadLocation.x != tail7.x && previousHeadLocation.y != tail7.y) {

					let moveX = (tail7.x - previousHeadLocation.x) == 0 ? 0 : ((tail7.x - previousHeadLocation.x) > 0 ? 1 : -1)
					let moveY = (tail7.y - previousHeadLocation.y) == 0 ? 0 : ((tail7.y - previousHeadLocation.y) > 0 ? 1 : -1)
					tail8 = Location.init(x: tail8.x + moveX, y: tail8.y + moveY)

					if isConnected(to: tail7, from: tail8) == false {

						previousTailLocation = tail8

						tail8 = closestLocation(to: tail7, direction: dir)
					}
					dir = cleanConnectionSide(to: tail7, from: tail8)

				} else {
					dir = directionFrom(tail8, to: previousHeadLocation)
					tail8 = previousHeadLocation
				}

				previousHeadLocation = previousTailLocation
			}

			if abs(abs(tail9.x) - abs(tail8.x)) > 1
				|| abs(abs(tail9.y) - abs(tail8.y)) > 1 {

				previousTailLocation = tail9

				if(previousHeadLocation.x != tail8.x && previousHeadLocation.y != tail8.y) {

					let moveX = (tail8.x - previousHeadLocation.x) == 0 ? 0 : ((tail8.x - previousHeadLocation.x) > 0 ? 1 : -1)
					let moveY = (tail8.y - previousHeadLocation.y) == 0 ? 0 : ((tail8.y - previousHeadLocation.y) > 0 ? 1 : -1)
					tail9 = Location.init(x: tail9.x + moveX, y: tail9.y + moveY)
					if isConnected(to: tail8, from: tail9) == false {

						tail9 = closestLocation(to: tail8, direction: dir)
					}
				} else {
					tail9 = previousHeadLocation
				}

				visitedLocations.insert(tail9)
			}
		}
	}


	print("VisitedLocations \(visitedLocations.count)")



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



func closestLocation(to target: Location, direction: Directions) -> Location {

	if direction == .top {
		return Location.init(x: target.x, y: target.y-1)
	} else if direction == .left {
		return Location.init(x: target.x-1, y: target.y)
	} else if direction == .right {
		return Location.init(x: target.x+1, y: target.y)
	} else {
		return Location.init(x: target.x, y: target.y+1)
	}
}

func directionFrom(_ from: Location, to: Location) -> Directions {

	if from.x < to.x {
		return .right
	} else if from.x > to.x {
		return .left
	} else if from.y < to.y {
		return .bottom
	} else  {
		return .top
	}
}


func cleanConnectionSide(to target: Location, from: Location) -> Directions {

	if target.x == from.x && target.y - 1 == from.y {
		return .top
	} else if target.x == from.x && target.y + 1 == from.y {
		return .bottom
	} else if target.x - 1 == from.x && target.y == from.y {
		return .left
	}  else {
		return .right
	}
}

func isConnected(to target: Location, from: Location) -> Bool {

	if target.x == from.x && target.y == from.y {
		return true
	} else if target.x == from.x && target.y - 1 == from.y {
		return true
	} else if target.x == from.x && target.y + 1 == from.y {
		return true
	} else if target.x - 1 == from.x && target.y == from.y {
		return true
	}  else if target.x + 1 == from.x && target.y == from.y {
		return true
	}

	return false
}
