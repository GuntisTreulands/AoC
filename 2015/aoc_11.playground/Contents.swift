import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let test2Data = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test2", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!
let inputData2 = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input2", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var test2 = String(data:test2Data, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!
var input2 = String(data:inputData2, encoding:String.Encoding.utf8)!

test = test.replacingOccurrences(of: "\n", with: "")
test2 = test2.replacingOccurrences(of: "\n", with: "")
input = input.replacingOccurrences(of: "\n", with: "")
input2 = input2.replacingOccurrences(of: "\n", with: "")

let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m", "n", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
var tmpRowArray = [String]()

for i in 0..<alphabet.count-2 {
	tmpRowArray.append("\(alphabet[i])\(alphabet[i+1])\(alphabet[i+2])")
}

var alphabetRow = tmpRowArray.flatMap { $0.components(separatedBy: " ")}


let result1 = nextPassword(test)     // abcdffaa
let result2 = nextPassword(test2)    // ghjaabbaa
let result3 = nextPassword(input)      // hepxxyzz
let result4 = nextPassword(input2)     // heqaabcc

func nextPassword(_ string: String) -> String {

	var array = Array(string).map {"\($0)"}

	// Override unsupported characters at the beginning

	for (index, item) in array.enumerated() {
		if item == "i" {
			array[index] = "j"
			for i in (index + 1)..<array.count {
				array[i] = alphabet[0]
			}
		}
	}

	for (index, item) in array.enumerated() {
		if item == "l" {
			array[index] = "m"
			for i in (index + 1)..<array.count {
				array[i] = alphabet[0]
			}
		}
	}

	for (index, item) in array.enumerated() {
		if item == "o" {
			array[index] = "p"
			for i in (index + 1)..<array.count {
				array[i] = alphabet[0]
			}
		}
	}

	// Start!

	var result = string

	print("Start password: \(string)")

	repeat {
		let first = alphabet.firstIndex(of:String(array[7]))!
		let second = alphabet.firstIndex(of:String(array[6]))!
		let third = alphabet.firstIndex(of:String(array[5]))!
		let fourth = alphabet.firstIndex(of:String(array[4]))!
		let fifth = alphabet.firstIndex(of:String(array[3]))!
		let sixt = alphabet.firstIndex(of:String(array[2]))!
		let seventh = alphabet.firstIndex(of:String(array[1]))!
		let eight = alphabet.firstIndex(of:String(array[0]))!

		if first < alphabet.count-1 {
			array[7] = alphabet[first + 1]
		} else {
			array[7] = alphabet[0]

			if second < alphabet.count-1 {
				array[6] = alphabet[second + 1]
			} else {
				array[7] = alphabet[0]
				array[6] = alphabet[0]

				if third < alphabet.count-1 {
					array[5] = alphabet[third + 1]
				} else {

					array[7] = alphabet[0]
					array[6] = alphabet[0]
					array[5] = alphabet[0]

					if fourth < alphabet.count-1 {
						array[4] = alphabet[fourth + 1]
					} else {

						array[7] = alphabet[0]
						array[6] = alphabet[0]
						array[5] = alphabet[0]
						array[4] = alphabet[0]

						if fifth < alphabet.count-1 {
							array[3] = alphabet[fifth + 1]
						} else {

							array[7] = alphabet[0]
							array[6] = alphabet[0]
							array[5] = alphabet[0]
							array[4] = alphabet[0]
							array[3] = alphabet[0]

							if sixt < alphabet.count-1 {
								array[2] = alphabet[sixt + 1]
							} else {

								array[7] = alphabet[0]
								array[6] = alphabet[0]
								array[5] = alphabet[0]
								array[4] = alphabet[0]
								array[3] = alphabet[0]
								array[2] = alphabet[0]

								if sixt < alphabet.count-1 {
									array[1] = alphabet[seventh + 1]
								} else {

									array[7] = alphabet[0]
									array[6] = alphabet[0]
									array[5] = alphabet[0]
									array[4] = alphabet[0]
									array[3] = alphabet[0]
									array[2] = alphabet[0]
									array[1] = alphabet[0]

									if sixt < alphabet.count-1 {
										array[0] = alphabet[eight + 1]
									} else {
											// Unsupported
									}
								}
							}
						}
					}
				}
			}
		}

		result = String(array.map {"\($0)"}.reduce("") { $0 + $1 })

	} while validation(result) == false

	print("End password: \(result)")

	return result
}


func validation(_ string: String) -> Bool {

	// Contains at least 3 increasing letters (abc or cde... up to xyz)
	if alphabetRow.filter({ string.range(of:$0) != nil }).count == 0 {
		return false
	}

	// Check if there are repeated letters .. like aa, bb.. cc etc (need two of a kind)
	let tmpArray = Array(string)
	var repeatedResults = Set<String>()

	for i in 0..<string.count {
		let firstChar = tmpArray[i]
		var searchPosition = string.startIndex
		while let range = string.range(of: "\(firstChar)\(firstChar)", range: searchPosition..<string.endIndex) {
			repeatedResults.insert("\(firstChar)")
			searchPosition = range.upperBound
		}
	}


	if Array(repeatedResults).count < 2 {
		return false
	} else {

		// Extra check to make sure there was not an overlapping case of aaa for example
		for letter in Array(repeatedResults){
			if string.contains("\(letter)\(letter)\(letter)") {
				return false
			}
		}

	}

	return true
}

