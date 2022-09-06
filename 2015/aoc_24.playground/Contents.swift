import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


var combinations = [[Int]]()

//calculateFromValues(test) // [11, 9], QE: 99
//calculateFromValues(input) // Part 1:  [1, 83, 103, 107, 109, 113], QE: 11266889531
//calculateFromValues(input, part2: true) // Part 2:  [1, 61, 103, 109, 113], QE: 77387711


func calculateFromValues(_ test: String, part2: Bool = false) {

	combinations.removeAll()


	var boxes = test.components(separatedBy: "\n")

	boxes.removeAll(where: {$0.isEmpty})

	let sizes = boxes.map({Int($0)!})
	let totalSize = sizes.reduce(0, +)
	let partSize = totalSize / (part2 ? 4 : 3)
	let maxBoxesCount = sizes.count / (part2 ? 4 : 3) // Max number of boxes, can't be more than average count
	var minBoxesCount = 0 // Minimum number of boxes. Count up starting from largest ones

	var tmpCount = 0

	for item in sizes.reversed() {
		tmpCount += item
		minBoxesCount += 1

		if tmpCount >= partSize {
			break
		}
	}

	for combo in sizes.combinations(ofCount: minBoxesCount...maxBoxesCount-1) {
		let sum = combo.reduce(0, +)
		if sum == partSize {
			combinations.append(combo)
		}
	}


	let sorted = combinations.sorted(by: {$0.count < $1.count})

	let leastCount = sorted.first!.count

	var leastCombination = [Int]()
	var leastQE = 0

	for combination in sorted {
		if combination.count > leastCount {
			break
		}

		let qe = combination.reduce(1, *)

		if leastQE == 0 || (leastQE != 0 && qe < leastQE) {
			leastCombination = combination
			leastQE = qe
		}
	}

	print("Least Combination: \(leastCombination), QE: \(leastQE)")
}
