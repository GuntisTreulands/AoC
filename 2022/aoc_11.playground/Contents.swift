import UIKit
import Foundation

typealias BigInt = _BigInt<UInt>


enum Operation {
	case add, multiply, multiplyWithSelf
}

class Monkey {
	var name: String = ""
	var items: [Int] = []
	var operation: Operation = .add
	var operationItem: Int = 0
	var divisible: Int = 0
	var trueMonkey: String = ""
	var falseMonkey: String = ""
	var inspectCounter: Int = 0
	init(name: String, items: [Int], operation: Operation, operationItem: Int, divisible: Int, trueMonkey: String, falseMonkey: String) {
		self.name = name
		self.items = items
		self.operation = operation
		self.operationItem = operationItem
		self.divisible = divisible
		self.trueMonkey = trueMonkey
		self.falseMonkey = falseMonkey
	}
}


var testArray: [Monkey] = [
	Monkey.init(name: "0", items: [79, 98], operation: .multiply, operationItem: 19, divisible: 23, trueMonkey: "2", falseMonkey: "3"),
	Monkey.init(name: "1", items: [54, 65, 75, 74], operation: .add, operationItem: 6, divisible: 19, trueMonkey: "2", falseMonkey: "0"),
	Monkey.init(name: "2", items: [79, 60, 97], operation: .multiplyWithSelf, operationItem: 0, divisible: 13, trueMonkey: "1", falseMonkey: "3"),
	Monkey.init(name: "3", items: [74], operation: .add, operationItem: 3, divisible: 17, trueMonkey: "0", falseMonkey: "1"),
]

var inputArray: [Monkey] = [
	Monkey.init(name: "0", items: [89, 84, 88, 78, 70], operation: .multiply, operationItem: 5, divisible: 7, trueMonkey: "6", falseMonkey: "7"),
	Monkey.init(name: "1", items: [76, 62, 61, 54, 69, 60, 85], operation: .add, operationItem: 1, divisible: 17, trueMonkey: "0", falseMonkey: "6"),
	Monkey.init(name: "2", items: [83, 89, 53], operation: .add, operationItem: 8, divisible: 11, trueMonkey: "5", falseMonkey: "3"),
	Monkey.init(name: "3", items: [95, 94, 85, 57], operation: .add, operationItem: 4, divisible: 13, trueMonkey: "0", falseMonkey: "1"),
	Monkey.init(name: "4", items: [82, 98], operation: .add, operationItem: 7, divisible: 19, trueMonkey: "5", falseMonkey: "2"),
	Monkey.init(name: "5", items: [69], operation: .add, operationItem: 2, divisible: 2, trueMonkey: "1", falseMonkey: "3"),
	Monkey.init(name: "6", items: [82, 70, 58, 87, 59, 99, 92, 65], operation: .multiply, operationItem: 11, divisible: 5, trueMonkey: "7", falseMonkey: "4"),
	Monkey.init(name: "7", items: [91, 53, 96, 98, 68, 82], operation: .multiplyWithSelf, operationItem: 0, divisible: 3, trueMonkey: "4", falseMonkey: "2"),
]


//doTask(testArray, rounds: 10000, divider: 3) // Part1: 10605
//doTask(inputArray, rounds: 10000, divider: 3) // Part1: 55930

//doTask(testArray, rounds: 10000) // Part2: 2713310158
doTask(inputArray, rounds: 10000) // Part2: 14636993466



func doTask(_ monkeys: [Monkey], rounds: Int, divider: Int = 1) {

	var superModule = 1 //https://www.reddit.com/r/adventofcode/comments/zih7gf/comment/izr79go/?utm_source=share&utm_medium=web2x&context=3

	for monkey in monkeys {
		superModule *= monkey.divisible
	}

	for _ in 1...rounds {

		for monkey in monkeys {

			if monkey.items.isEmpty {
				continue
			}

			for _ in 0..<monkey.items.count {
				var worryLevel = monkey.items.removeFirst()

				worryLevel = worryLevel % superModule


				monkey.inspectCounter += 1
				if monkey.operation == .add {
					worryLevel = worryLevel + monkey.operationItem
				} else if monkey.operation == .multiply {
					worryLevel = worryLevel * monkey.operationItem
				} else {
					worryLevel = worryLevel * worryLevel
				}

				worryLevel /= divider


				if worryLevel % monkey.divisible == 0 {
					let trueMonkey = monkeys.filter( {$0.name == monkey.trueMonkey }).first!
					trueMonkey.items.append(worryLevel)
				} else {
					let falseMonkey = monkeys.filter( {$0.name == monkey.falseMonkey }).first!
					falseMonkey.items.append(worryLevel)
				}

			}
		}
	}

	let sortedMonkeys = monkeys.sorted(by: {$0.inspectCounter > $1.inspectCounter})

	let topMonkeyBusiness = sortedMonkeys[0].inspectCounter * sortedMonkeys[1].inspectCounter

	print("Monkey business: \(topMonkeyBusiness)") // too low 2713310158
}
