import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

gridWithLights(test, steps: 4) // 4
gridWithLights(input, steps: 100) // 1061

gridWithLights(test, steps: 5, cornerOverride: true) // 17
gridWithLights(input, steps: 100, cornerOverride: true) // 1006


func gridWithLights(_ string: String, steps: Int, cornerOverride: Bool = false) {

	let array = string.components(separatedBy: "\n")

	let size = array.first!.count

	var table = [Int](repeating: 0, count: size * size)

	for (column, itemI) in array.enumerated() {
		if itemI.isEmpty {
			continue
		}

		for (row, itemJ) in Array(itemI).enumerated() {
			table[row + column * size] = (itemJ == "#") ? 1 : 0
		}

	}

	// Override corners
	if cornerOverride {
		table[0] = 1
		table[size - 1] = 1
		table[(size * size - 1) - size + 1] = 1
		table[size * size - 1 ] = 1
	}



	for _ in 0..<steps {

		var tmpTable = table

		for column in 0..<size {
			for row in 0..<size {
				let count = numberOfOnLightsAround(row: row, column: column, inTable: table, size: size)
				let isOn = table[row + column * size] == 1

				if isOn && (count == 2 || count == 3) {
					tmpTable[row + column * size] = 1
				} else if !isOn && count == 3 {
					tmpTable[row + column * size] = 1
				} else {
					tmpTable[row + column * size] = 0
				}
			}
		}

		// Override corners
		if cornerOverride {
			tmpTable[0] = 1
			tmpTable[size - 1] = 1
			tmpTable[(size * size - 1) - size + 1] = 1
			tmpTable[size * size - 1 ] = 1
		}

		table = tmpTable
	}

	table.removeAll(where: {$0 == 0})

	print("Number of lights on: \(table.count)")
}


func numberOfOnLightsAround(row: Int, column: Int, inTable: [Int], size: Int) -> Int {

	let backRowGood = (row-1 >= 0) ? true : false
	let frontRowGood = (row+1 < size) ? true : false

	let backColumnGood = (column-1 >= 0) ? true : false
	let frontColumnGood = (column+1 < size) ? true : false


	let light1 = (backRowGood && backColumnGood) ? inTable[row - 1 + (column - 1) * size] : 0
	let light2 = backColumnGood ? inTable[row + (column - 1) * size] : 0
	let light3 = (frontRowGood && backColumnGood) ? inTable[row + 1 + (column - 1) * size] : 0
	let light4 = frontRowGood ? inTable[row + 1 + column * size] : 0
	let light5 = (frontRowGood && frontColumnGood) ? inTable[row + 1 + (column + 1) * size] : 0
	let light6 = frontColumnGood ? inTable[row + (column + 1) * size] : 0
	let light7 = (backRowGood && frontColumnGood) ? inTable[row - 1 + (column + 1) * size] : 0
	let light8 = backRowGood ? inTable[row - 1 + column * size] : 0

	return light1 + light2 + light3 + light4 + light5 + light6 + light7 + light8
}


