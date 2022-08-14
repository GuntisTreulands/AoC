import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let test2Data = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test2", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var test2 = String(data:test2Data, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

test = test.replacingOccurrences(of: "\n", with: "")
test2 = test2.replacingOccurrences(of: "\n", with: "")
input = input.replacingOccurrences(of: "\n", with: "")

let result1 = sumOfNumbers(test)
let result2 = sumOfNumbers(test2)
let result3 = sumOfNumbers(input)

let result4 = sumOfNonRedNumbers(test)  // 65402
let result5 = sumOfNonRedNumbers(test2) // 4
let result6 = sumOfNonRedNumbers(input) // 96852

// Just count up all numbers
func sumOfNumbers(_ string: String) -> Int {
	var result = string.numericString

	result = result.replacingOccurrences(of: ":", with: ",")
	result = result.replacingOccurrences(of: ",,,", with: ",")
	result = result.replacingOccurrences(of: ",,", with: ",")
	result = result.replacingOccurrences(of: ",,", with: ",")
	result = result.replacingOccurrences(of: ",,", with: ",")

	result = result.replacingOccurrences(of: ",", with: "\n")

	let arrayOfNumbers: [Int] = result.components(separatedBy: "\n").compactMap { Int($0) }

	return arrayOfNumbers.reduce(0, +)
}


// Same thing, just ignore those, that has text "red", within {}
func sumOfNonRedNumbers(_ string: String) -> Int {

	let adjustedString = string.replacingOccurrences(of: "red", with: "$")

	var returnedResultsArray = [String]()
	returnedResultsArray.append(adjustedString)


	var totalCount = 0

	repeat {

		let tmpArray = returnedResultsArray
		returnedResultsArray.removeAll()

		for item in tmpArray {

			var nestedCollector = ""
			var firstLevelCollector = ""

			var level = 0

			var redFound = false

			// In case we got a clear case (no sub-arrays or sub-objects, just sum it up.
			if !item.contains("[") && !item.contains("{") {
				totalCount += sumOfNumbers(item)
				continue
			}

			for element in Array(item) {
				if element == "[" {
					level += 1
				} else if element == "{" {
					level += 1
				} else if element == "]" {
					level -= 1
				} else if element == "}" {
					level -= 1
				}

				if level == 1 && element == "$" {
					redFound = true
				}

				nestedCollector.append(element)

				// In case we are back to level 0, add the second level to array for next iteration..
				if(level == 0) {
					if(nestedCollector.count > 2) {
						let finalString = String(String(nestedCollector.prefix(nestedCollector.count-1)).suffix(nestedCollector.count-2))

						if redFound && element == "}" {
							// Skip, as it is not important - it is {} and contains red (or.. $)
						} else {
							returnedResultsArray.append(finalString)
						}
					} else {
						// In case we are level 0 - add all items and count right now.
						// It is safe to assume, that any red (or $) at this point is not important, as it is filtered in previous iteration
						firstLevelCollector.append(element)
					}

					nestedCollector = ""
					redFound = false
				}
			}

			totalCount += sumOfNumbers(firstLevelCollector)
		}

	} while returnedResultsArray.count > 0

	return totalCount
}


extension String {

    /// Returns a string with all non-numeric characters removed
    public var numericString: String {
        let characterSet = CharacterSet(charactersIn: "0123456789.-:,").inverted
        return components(separatedBy: characterSet)
            .joined()
    }
}

