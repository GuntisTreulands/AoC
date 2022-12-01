import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


maxCalories(test) //24000
maxCalories(input) //69206

maxTop3CaloriesSup(test) //45000
maxTop3CaloriesSup(input) //197400

func maxCalories(_ string: String) -> Int {

	let calories = string.components(separatedBy: "\n")

	var maxCaloryCount = 0

	var currentCount = 0

	for calorie in calories {

		if calorie.isEmpty == false {
			currentCount += Int(calorie)!
		} else {
			maxCaloryCount = max(currentCount, maxCaloryCount)
			currentCount = 0
		}
	}

	return maxCaloryCount
}

func maxTop3CaloriesSup(_ string: String) -> Int {

	let calories = string.components(separatedBy: "\n")

	var caloriesCount: [Int] = []

	var currentCount = 0

	for calorie in calories {

		if calorie.isEmpty == false {
			currentCount += Int(calorie)!
		} else {
			caloriesCount.append(currentCount)
			currentCount = 0
		}
	}

	caloriesCount.sort { $0 > $1 }

	var sum = 0

	for i in 0..<3 {
		sum += caloriesCount[i]
	}

	return sum
}
