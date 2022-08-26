import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

test = test.replacingOccurrences(of: "\n", with: "")
input = input.replacingOccurrences(of: "\n", with: "")

houseNumberWithPresentCount(Int(test)!)
houseNumberWithPresentCount(Int(input)!)  // Part 1: 776160 (presents: 33611760) (Previous largest: 720720)
houseNumberWithPresentCountPart2(Int(input)!) // Part 2: 786240 (presents: 33161590) (Previous largest: 776160)


extension Collection {
	func separate(_ predicate: (Iterator.Element) -> Bool) -> [Iterator.Element] {
        var results = [Iterator.Element]()
        for element in self {
            if predicate(element) {
                results.append(element)
            }
        }
        return results
    }
}


func houseNumberWithPresentCountPart2(_ number: Int) {

	print("Target presents: \(number)")

	let elvesCount = 1_000_000

	var maxEncountered = 0

	var houseIndex = 1

	repeat {

		let minDivisor: Int = houseIndex / 50

		var factors = factors(of: houseIndex)

		factors.removeAll(where: { $0 <= minDivisor})

		let value = factors.reduce(0, +) * 11


		if value > number {
			print("Target houseIndex: \(houseIndex), contains \(value) presents.")
			break
		}

		if value >= maxEncountered {

			maxEncountered = value
			print("number - value: \(number - value) value: \(value) houseIndex: \(houseIndex)")
		}

		houseIndex += 1

	} while houseIndex < elvesCount
}


func houseNumberWithPresentCount(_ number: Int) {

	print("Target presents: \(number)")

	let elvesCount = 1_000_000_000_000

	var maxEncountered = 0

	var houseIndex = 1

	repeat {
		if houseIndex > 10000 && houseIndex % 10 != 0 {
			houseIndex += 9
		}

		var value = 0

		let factors = factors(of: houseIndex)

		value = factors.map({$0 * 10}).reduce(0, +)

		if value > number {
			print("Target houseIndex: \(houseIndex), contains \(value) presents.")
			break
		}

		if value >= maxEncountered {
			maxEncountered = value
			print("number - value: \(number - value) value: \(value) houseIndex: \(houseIndex)")
		}

		houseIndex += 1

	} while houseIndex < elvesCount
}


func factors(of n: Int) -> [Int] {
    let sqrtn = Int(Double(n).squareRoot())
    var factors: [Int] = []
    factors.reserveCapacity(2 * sqrtn)
    for i in 1...sqrtn {
        if n % i == 0 {
            factors.append(i)
        }
    }
    var j = factors.count - 1
    if factors[j] * factors[j] == n {
        j -= 1
    }
    while j >= 0 {
        factors.append(n / factors[j])
        j -= 1
    }
    return factors
}
