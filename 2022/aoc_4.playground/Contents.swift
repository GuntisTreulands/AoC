import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

doTheTask(test) // 2
doTheTask(input) // 582


doTheTask(test, p2: true) // 4
doTheTask(input, p2: true) // 893


func doTheTask(_ string: String, p2: Bool = false) -> Int {

	let pairs = string.components(separatedBy: "\n")

	var totalPoints = 0

	for pair in pairs {
		if pair.isEmpty { continue }

		let pair1 = pair.split(separator: ",").first!
		let pair2 = pair.split(separator: ",").last!

		let pair1Numb1 = Int(pair1.split(separator: "-").first!)!
		let pair1Numb2 = Int(pair1.split(separator: "-").last!)!

		let pair2Numb1 = Int(pair2.split(separator: "-").first!)!
		let pair2Numb2 = Int(pair2.split(separator: "-").last!)!

		let range1 = Set(pair1Numb1...pair1Numb2)
		let range2 = Set(pair2Numb1...pair2Numb2)

		if p2 == true {
			for task in range1 {
				if range2.contains(task) {
					totalPoints += 1
					break
				}
			}
		} else {
			if range1.isSubset(of: range2) || range2.isSubset(of: range1) {
				totalPoints += 1
			}
		}
	}

	return totalPoints
}
