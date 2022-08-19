import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


findAllCombinationsUsingContainers(test, toFill:25)
findAllCombinationsUsingContainers(input, toFill:150) //Part1: 1304 combinations. | Part2: 18 combinations.


func findAllCombinationsUsingContainers(_ string: String, toFill: Int) {

	let array = string.components(separatedBy: "\n")

	var allContainers = [Int]()

	for item in array {
		if item.isEmpty {
			continue
		}

		allContainers.append(Int(item)!)
	}

	allContainers.sort()

	// All combinations
	var results = getArrays(allContainers, addTo: [], toFill: toFill)

	// Sort them, to get the smallest combination count
	let sortedResults = results.sorted(by: {$0.count < $1.count})

	// Get the smallest count
	let smallestCount = sortedResults.first!.count

	// Remove all, that are not smallest, to get the combination count of smallest number.
	results.removeAll(where: {$0.count != smallestCount})

	print("Combinations: \(sortedResults.count) | Number of combinations with \(smallestCount) containers: \(results.count)")
}


func getArrays(_ array: [Int], addTo: [Int], toFill: Int) -> [[Int]] {

	var results = [[Int]]()

	var decreasableArray = array

	/*
		Go over each item.
		Append each item to the "addTo array", and check if sum in addTo is now == toFill.

		If less, then remove first from the array we are using, and call this function again, with decreased array, and with new addTo.

		It should then return back any good combinations (resulting in == toFill), and then we return all of the combined results back as a final result.
	 */
	for item in array {

		var addition = addTo
		addition.append(item)

		if addition.sum() == toFill {
			results.append(addition)
		} else if addition.sum() < toFill {
			decreasableArray.removeFirst()

			if !decreasableArray.isEmpty {
				let tmpResults = getArrays(decreasableArray, addTo: addition, toFill: toFill)

				if !tmpResults.isEmpty {
					results.append(contentsOf: tmpResults)
				}
			}
		}
	}

	return results
}


extension Sequence where Element: Numeric {
    /// Returns the sum of all elements in the collection
    func sum() -> Element { return reduce(0, +) }
}
