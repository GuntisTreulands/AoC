import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

numberOfDistinctMolecules(test) // 7 results,  6 steps
numberOfDistinctMolecules(input) // 509 results, 195 steps


func numberOfDistinctMolecules(_ string: String) {

	let inputArray = string.components(separatedBy: "\n")

	var instructions = [String]()

	var targetMolecule = ""

	var distinctResults = Set<String>()

	for input in inputArray {
		if input.isEmpty {
			continue
		}

		if input.contains("=>") {
			instructions.append(input)
		} else {
			targetMolecule = input
		}
	}


	// PART 1....


	for instruction in instructions {
		let components = instruction.components(separatedBy: " => ")
		let firstPart = components.first!
		let secondPart = components.last!


		var searchStartIndex = targetMolecule.startIndex

        while searchStartIndex < targetMolecule.endIndex,
            let range = targetMolecule.range(of: firstPart, range: searchStartIndex..<targetMolecule.endIndex),
            !range.isEmpty
        {
            searchStartIndex = range.upperBound

			var tmpString = targetMolecule
			tmpString.replaceSubrange(range.lowerBound..<range.upperBound, with: secondPart)

			distinctResults.insert(tmpString)
        }
	}

	print("Number of results: \(distinctResults.count)")


	/// PART 2....


	var countOfReplaces = 0

	var revertedMolecule = targetMolecule

	var instructionsToSkip = [String]()

	var shouldTryOneMoreTime = false

	repeat {
		// Clear up used instructions
		instructionsToSkip.removeAll()

		shouldTryOneMoreTime = false

		for instruction in instructions {

			let components = instruction.components(separatedBy: " => ")
			let firstPart = components.first!
			let secondPart = components.last!


			var searchStartIndex = revertedMolecule.startIndex

			// Skip, if such instruction was used already in this set. (So that I would use only one "H" at a time)
			if instructionsToSkip.contains(firstPart) {
				continue
			}

			// Add the used instructions.
			if revertedMolecule.contains(secondPart) {
				instructionsToSkip.append(firstPart)
			}

			while searchStartIndex < revertedMolecule.endIndex,
				let range = revertedMolecule.range(of: secondPart, range: searchStartIndex..<revertedMolecule.endIndex),
				!range.isEmpty
			{
				searchStartIndex = range.upperBound

				var tmpString = revertedMolecule
				tmpString.replaceSubrange(range.lowerBound..<range.upperBound, with: firstPart)

				revertedMolecule = tmpString
				shouldTryOneMoreTime = true
				countOfReplaces += 1
			}
		}

	} while shouldTryOneMoreTime == true

	print("Number of steps: \(countOfReplaces)")
}
