import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

test = test.replacingOccurrences(of: "\n", with: "")
input = input.replacingOccurrences(of: "\n", with: "")

convertInputToElvenText(test, repeatUpTo: 4)

convertInputToElvenText(input, repeatUpTo: 40) // 252594

convertInputToElvenText(input, repeatUpTo: 50) // 3579328



func convertInputToElvenText(_ string: String, repeatUpTo: Int, currentIteration: Int = 1) {

	var result = ""


	result = string.replacingOccurrences(of: "1", with: "*")
	result = result.replacingOccurrences(of: "2", with: "!")
	result = result.replacingOccurrences(of: "3", with: "(")
	result = result.replacingOccurrences(of: "4", with: ")")
	result = result.replacingOccurrences(of: "5", with: ",")

	result = result.replacingOccurrences(of: "*****", with: "51")
	result = result.replacingOccurrences(of: "!!!!!", with: "52")
	result = result.replacingOccurrences(of: "(((((", with: "53")
	result = result.replacingOccurrences(of: ")))))", with: "54")
	result = result.replacingOccurrences(of: ",,,,,", with: "55")

	result = result.replacingOccurrences(of: "****", with: "41")
	result = result.replacingOccurrences(of: "!!!!", with: "42")
	result = result.replacingOccurrences(of: "((((", with: "43")
	result = result.replacingOccurrences(of: "))))", with: "44")
	result = result.replacingOccurrences(of: ",,,,", with: "45")

	result = result.replacingOccurrences(of: "***", with: "31")
	result = result.replacingOccurrences(of: "!!!", with: "32")
	result = result.replacingOccurrences(of: "(((", with: "33")
	result = result.replacingOccurrences(of: ")))", with: "34")
	result = result.replacingOccurrences(of: ",,,", with: "35")

	result = result.replacingOccurrences(of: "**", with: "21")
	result = result.replacingOccurrences(of: "!!", with: "22")
	result = result.replacingOccurrences(of: "((", with: "23")
	result = result.replacingOccurrences(of: "))", with: "24")
	result = result.replacingOccurrences(of: ",,", with: "25")

	result = result.replacingOccurrences(of: "*", with: "11")
	result = result.replacingOccurrences(of: "!", with: "12")
	result = result.replacingOccurrences(of: "(", with: "13")
	result = result.replacingOccurrences(of: ")", with: "14")
	result = result.replacingOccurrences(of: ",", with: "15")


	if(currentIteration < repeatUpTo) {
		print("Iteration  \(currentIteration) / \(repeatUpTo) (Length \(result.count))")
		convertInputToElvenText(result, repeatUpTo: repeatUpTo, currentIteration: currentIteration + 1)
	} else {
		print("Final result \(result), Final length \(result.count)")
	}
}
