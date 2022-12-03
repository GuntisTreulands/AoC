import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

var priorityList = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w","x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",]

doTheTask(test) //157
doTheTask(input) //8349

doTheTaskV2(test) //70
doTheTaskV2(input) //2681

func doTheTask(_ string: String) -> Int {

	let rucksacks = string.components(separatedBy: "\n")

	var totalPoints = 0

	// Store in a Set, but afterwards transfer to Array. Because letters can repeat over different rucksacks, but should be only one per rucksack (they do repeat)

	var repeats = [String]()
	var tmpRepeats = Set<String>()

	for rucksack in rucksacks {
		if rucksack.isEmpty { continue }

		let firstCompartment = rucksack.prefix(rucksack.count / 2)
		let secondCompartment = rucksack.suffix(rucksack.count / 2)

		tmpRepeats.removeAll()
		for firstChar in firstCompartment {

			for secondChar in secondCompartment {

				if firstChar == secondChar {
					tmpRepeats.insert(String(firstChar))
				}
			}
		}

		repeats.append(contentsOf: tmpRepeats)
	}

	for letter in repeats {
		totalPoints += priorityList.firstIndex(of: letter)! + 1
	}

	return totalPoints
}


func doTheTaskV2(_ string: String) -> Int {

	let rucksacks = string.components(separatedBy: "\n")

	var totalPoints = 0

	// Store in a Set, but afterwards transfer to Array. Because letters can repeat over different rucksacks, but should be only one per rucksack (they do repeat)
	var repeats = [String]()
	var tmpRepeats = Set<String>()

	var rucksacksToCheck = [String]()

	for rucksack in rucksacks {
		if rucksack.isEmpty { continue }

		rucksacksToCheck.append(rucksack)

		if rucksacksToCheck.count == 3 {

			tmpRepeats.removeAll()

			for firstChar in rucksacksToCheck.first! {

				var foundBadgeInAllRucksacks = true
				for tmpCmpartment in rucksacksToCheck {
					if tmpCmpartment.contains(firstChar) == false {
						foundBadgeInAllRucksacks = false
						break
					}
				}

				if foundBadgeInAllRucksacks {
					tmpRepeats.insert(String(firstChar))
				}

			}

			repeats.append(contentsOf: tmpRepeats)
			rucksacksToCheck.removeAll()
		}
	}

	for letter in repeats {
		totalPoints += priorityList.firstIndex(of: letter)! + 1
	}

	return totalPoints
}

