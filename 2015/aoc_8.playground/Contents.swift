import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


let testChars = numberOfChars(test)
let inputChars = numberOfChars(input)


// Start with replacing all \\\\ with ;. This will possibly override any \x** items
test = test.replacingOccurrences(of: "\\\\", with: ";")
input = input.replacingOccurrences(of: "\\\\", with: ";")

var testArray = test.components(separatedBy: "\\x")
var inputArray = input.components(separatedBy: "\\x")


// Remove all \x** items and replace with .
for (index, str) in testArray.enumerated() {
	if index > 0 && str.count >= 2 {
		testArray[index] = ".\(str.suffix(str.count-2))"
	}
}

for (index, str) in inputArray.enumerated() {
	if index > 0 && str.count >= 2 {
		inputArray[index] = ".\(str.suffix(str.count-2))"
	}
}


test = testArray.joined(separator: "\n")
input = inputArray.joined(separator: "\n")


let testRealLength = numberOfRealLength(test)
let inputRealLength = numberOfRealLength(input)

let testEncodedLength = numberOfEncodedRealLength(test)
let inputEncodedLength = numberOfEncodedRealLength(input)


let part1Test = testChars - testRealLength
let part1Input = inputChars - inputRealLength // 1342


let part2Test = testEncodedLength - testChars
let part2Input = inputEncodedLength - inputChars //2074


func numberOfChars(_ string: String) -> Int {
	return string.replacingOccurrences(of: "\n", with: "").count
}

func numberOfRealLength(_ string: String) -> Int {

	var tmp = string

	tmp = tmp.replacingOccurrences(of: "\n", with: "")
	tmp = tmp.replacingOccurrences(of: " ", with: "")
	tmp = tmp.replacingOccurrences(of: "\\\"", with: "+")
	tmp = tmp.replacingOccurrences(of: "\"", with: "")

	return tmp.count
}

func numberOfEncodedRealLength(_ string: String) -> Int {

	var tmp = string

	tmp = tmp.replacingOccurrences(of: "\n", with: "")
	tmp = tmp.replacingOccurrences(of: ".", with: "-----")
	tmp = tmp.replacingOccurrences(of: ";", with: "}}}}")
	tmp = tmp.replacingOccurrences(of: " ", with: "")
	tmp = tmp.replacingOccurrences(of: "\\\"", with: "+|+|")
	tmp = tmp.replacingOccurrences(of: "\"", with: "{{{")

	return tmp.count
}
