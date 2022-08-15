import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

test = test.replacingOccurrences(of: ".", with: "")
input = input.replacingOccurrences(of: ".", with: "")

let result1 = sumOfHappinessForBestSeating(test)
let result2 = sumOfHappinessForBestSeating(input)	// 709
let result3 = sumOfHappinessForBestSeating(input, shouldIncludeMyself: true) // 668


func sumOfHappinessForBestSeating(_ string: String, shouldIncludeMyself: Bool = false) -> Int {

	let array = string.components(separatedBy: "\n")

	var instuctions = [String: Int]()

	var participants = Set<String>()

	for description in array {

		if description.isEmpty {
			continue
		}

		print("description \(description)")
		let person = description.components(separatedBy: " would").first!
		let targetPerson = description.components(separatedBy: "to ").last!


		var value = 0

		if description.contains("gain") {
			value = Int(description.components(separatedBy: " happiness").first!.components(separatedBy: "gain ").last!)!
		} else {
			value = Int(description.components(separatedBy: " happiness").first!.components(separatedBy: "lose ").last!)! * -1
		}

		instuctions["\(person)-\(targetPerson)"] = value

		participants.insert(person)
	}

	if shouldIncludeMyself { // Add instructions for myself, but don't add me just yet (so that operation is faster)

		for person in Array(participants) {
			instuctions["\(person)-Me"] = 0
			instuctions["Me-\(person)"] = 0
		}
	}

	print("instuctions \(instuctions)")

	// Convert to string index array and continue using it like that. ["0", "1", "2" ...]
	var indexArray = [String]()
	for (index, _) in Array(participants).enumerated() {
		indexArray.append(("\(index)"))
	}

	var differentCombinations = combinations(indexArray)

	differentCombinations.removeAll(where:{ $0.count < indexArray.count })

	var finalDifferentCombinations = [String]()

	let indexOfMe = participants.count


	// This is somewhat workaround. Take existing combinations, and replace each with added myself.
	// For example, if I am 8,  and I had 01234567, then replace first all "0" with "08" and store all these.
	// Then "1" with "18", and store all these.   And so on, until I kind of have all combinations, if done properly originally with myself.
	if shouldIncludeMyself {

		for i in 0..<indexArray.count-1
		{
			let adjusted = differentCombinations.map({$0.replacingOccurrences(of: "\(i)", with: "\(i)\(indexOfMe)")})
			finalDifferentCombinations.append(contentsOf: adjusted)
		}

		participants.insert("Me")
	} else {
		finalDifferentCombinations = differentCombinations
	}


	var calculatedHappinessDictionary = [String: Int]()

	// Now go through each combination, convert back names and calculate total happiness
	for item in finalDifferentCombinations {

		var totalHappiness = 0

		// Middle items
		for i in 1..<item.count-1
		{
			let name0 = Array(participants)[Int(item[i-1])!]
			let name1 = Array(participants)[Int(item[i])!]
			let name2 = Array(participants)[Int(item[i+1])!]

			let connection1 = "\(name1)-\(name0)"
			totalHappiness += instuctions[connection1]!

			let connection2 = "\(name1)-\(name2)"
			totalHappiness += instuctions[connection2]!
		}

		// First item
		let name0 = Array(participants)[Int(item[item.count-1])!]
		let name1 = Array(participants)[Int(item[0])!]
		let name2 = Array(participants)[Int(item[1])!]

		let connection1 = "\(name1)-\(name0)"
		totalHappiness += instuctions[connection1]!

		let connection2 = "\(name1)-\(name2)"
		totalHappiness += instuctions[connection2]!

		// Last item
		let name3 = Array(participants)[Int(item[item.count-2])!]
		let name4 = Array(participants)[Int(item[item.count-1])!]
		let name5 = Array(participants)[Int(item[0])!]

		let connection3 = "\(name4)-\(name3)"
		totalHappiness += instuctions[connection3]!

		let connection4 = "\(name4)-\(name5)"
		totalHappiness += instuctions[connection4]!


		calculatedHappinessDictionary[item] = totalHappiness
	}

	let leastHappiness = calculatedHappinessDictionary.values.sorted().first!
	let mostHappiness = calculatedHappinessDictionary.values.sorted().last!

	print("leastHappiness \(leastHappiness)")
	print("mostHappiness \(mostHappiness)")

	return mostHappiness
}


func combinations(_ array : [String]) -> [String] {

    // Recursion terminates here:
    if array.count == 0 { return [] }

    // Concatenate all combinations that can be built with element #i at the
    // first place, where i runs through all array indices:
    return array.indices.flatMap { i -> [String] in

        // Pick element #i and remove it from the array:
        var arrayMinusOne = array
        let elem = arrayMinusOne.remove(at: i)

        // Prepend element to all combinations of the smaller array:
        return [elem] + combinations(arrayMinusOne).map { elem + $0 }
    }
}


extension String {
    subscript(i: Int) -> String {
        return  i < count ? String(self[index(startIndex, offsetBy: i)]) : ""
    }
}
