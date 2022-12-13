import UIKit
import Foundation
import GameplayKit


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

doTask(test) // Part1: 13   Part2: 140
doTask(input) // Part1: 6240  Part2: 23142


struct MyStruct: Codable {
    let array: [Int]
}


func doTask(_ string: String) {

	let packetPairs = string.components(separatedBy: "\n\n")

	var index: Int = 1

	var sumOfCorrectIndices: Int = 0

	for packetPair in packetPairs {
		if packetPair.isEmpty  { continue }

		let leftPacket = packetPair.split(separator: "\n").first!
		let rightPacket = packetPair.split(separator: "\n").last!

//		print("\n== Pair \(index) ==")
//		print("- Compare \(leftPacket) vs \(rightPacket)")


		let jsonArrayLeft = try! JSONSerialization.jsonObject(with: leftPacket.data(using: .utf8)!, options: []) as! [Any]
		let jsonArrayRight = try! JSONSerialization.jsonObject(with: rightPacket.data(using: .utf8)!, options: []) as! [Any]

		let result: Result = isOrdered(leftItem: jsonArrayLeft, rightItem: jsonArrayRight, level: 0)
//		print("Ordered: \(result)")

		if result != .failure {
			sumOfCorrectIndices += index
		}

		index += 1
	}

	print("\n\nSum of correct indices is \(sumOfCorrectIndices)")


	let packets = string.components(separatedBy: "\n")

	var allPacketLines: [String] = []
	for packet in packets {
		if packet.isEmpty  { continue }
		allPacketLines.append(packet)
	}

	allPacketLines.append("[[2]]")
	allPacketLines.append("[[6]]")

	allPacketLines.sort { (lhs: String, rhs: String) -> Bool in

		let jsonArrayLeft: [Any] = try! JSONSerialization.jsonObject(with: lhs.data(using: .utf8)!, options: []) as! [Any]
		let jsonArrayRight: [Any] = try! JSONSerialization.jsonObject(with: rhs.data(using: .utf8)!, options: []) as! [Any]

		if isOrderedV2(leftItem: jsonArrayLeft, rightItem: jsonArrayRight, level: 0) == .failure {
			return false
		}

		return true
	}


	for packet in allPacketLines {
		print(packet)
	}
	let firstIndex = allPacketLines.firstIndex(of: "[[2]]")! + 1
	let secondIndex = allPacketLines.firstIndex(of: "[[6]]")! + 1

	print("\nDivider packets are \(firstIndex), \(secondIndex) and the decoderKey is \(firstIndex * secondIndex)")
}


enum Result {
	case success, failure, unknown
}





func isOrdered(leftItem: Any, rightItem: Any, level: Int) -> Result {

	var adjustedLeftItem = leftItem
	var adjustedRightItem = rightItem

	//print("leftItem \(leftItem) | rightItem \(rightItem) | level \(level)\n")

	if ((leftItem as? [Any]) != nil || (rightItem as? [Any]) != nil) {
		if ((leftItem as? [Any]) != nil) {
			adjustedLeftItem = leftItem
		} else {
			adjustedLeftItem = [leftItem]
		}

		if ((rightItem as? [Any]) != nil) {
			adjustedRightItem = rightItem
		} else {
			adjustedRightItem = [rightItem]
		}
	}

	var currentResult: Result = .unknown

	if ((adjustedLeftItem as? Int) != nil) {

		if (leftItem as! Int) < (rightItem as! Int) {
			return .success
		} else if (leftItem as! Int) > (rightItem as! Int) {
			return .failure
		} else {
			return .unknown
		}
	}

	if ((adjustedLeftItem as? [Any]) != nil) {
		if((adjustedLeftItem as! [Any]).count == 0) {
			return .success //Left side run out of items, so inputs are in the right order
		}

		if((adjustedRightItem as! [Any]).count == 0) {
			return .failure //Right side run out of items, so inputs are not in the right order
		}

		while((adjustedLeftItem as! [Any]).count > (adjustedRightItem as! [Any]).count) {

			let tmp: [Any] = (adjustedRightItem as! [Any]) + [-1]
			adjustedRightItem = tmp
		}

		while((adjustedRightItem as! [Any]).count > (adjustedLeftItem as! [Any]).count) {

			let tmp: [Any] = (adjustedLeftItem as! [Any]) + [-1]
			adjustedLeftItem = tmp
		}

		for index in 0..<(adjustedLeftItem as! [Any]).count {
			currentResult = isOrdered(leftItem: (adjustedLeftItem as! [Any])[index], rightItem: (adjustedRightItem as! [Any])[index], level: level + 1)

			if currentResult == .failure || currentResult == .success {
				return currentResult
			}
		}
	}

	if level == 0 && currentResult == .unknown {
		return .failure
	}

	return currentResult
}

func isOrderedV2(leftItem: Any, rightItem: Any, level: Int) -> Result {

	if ((leftItem as? [Any]) == nil) { // Not an array
		if ((rightItem as? [Any]) == nil) { // Not an array
			if (leftItem as! Int) < (rightItem as! Int) {
				return .success
			} else if (leftItem as! Int) > (rightItem as! Int) {
				return .failure
			} else {
				return .unknown
			}
		}
		return isOrderedV2(leftItem: [leftItem], rightItem: rightItem, level: level + 1)
	}

	if ((rightItem as? [Any]) == nil) { // Not an array
		return isOrderedV2(leftItem: leftItem, rightItem: [rightItem], level: level + 1)
	}

	// Presume only arrays from now on
	let leftArray = (leftItem as! [Any])
	let rightArray = (rightItem as! [Any])

	if leftArray.count == 0 && rightArray.count == 0 {
		return .unknown
	}

	if leftArray.count == 0 {
		return .success
	}

	if rightArray.count == 0 {
		return .failure
	}

	for index in 0..<min(leftArray.count, rightArray.count) {
		let result = isOrderedV2(leftItem: leftArray[index], rightItem: rightArray[index], level: level + 1)

		if result != .unknown {
			return result
		}
	}

	if leftArray.count > rightArray.count {
		return .failure
	} else {
		return .success
	}
}
