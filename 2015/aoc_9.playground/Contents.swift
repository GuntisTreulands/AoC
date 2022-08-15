import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

calculateShortestAndLongestDistance(test)
calculateShortestAndLongestDistance(input)


func calculateShortestAndLongestDistance(_ string: String) {

	let routesArray = string.components(separatedBy: "\n")

	var distancesDictionary = [String: Int]()

	var calculatedDistancesDictionary = [String: Int]()

	var destinationNames = Set<String>()

	for route in routesArray {
		if route.isEmpty { continue }

		let routeAndDistance = route.components(separatedBy: " = ")
		let destinations = routeAndDistance.first!.components(separatedBy: " to ")
		let distance = Int(routeAndDistance.last!)

		let destinationName1 = destinations.first!
		let destinationName2 = destinations.last!
		
		destinationNames.insert(destinationName1)
		destinationNames.insert(destinationName2)

		distancesDictionary["\(destinationName1)\(destinationName2)"] = distance
		distancesDictionary["\(destinationName2)\(destinationName1)"] = distance
	}

	print("destinationNames \(destinationNames)")
	print("distancesDictionary \(distancesDictionary)")

	// Convert to string index array and continue using it like that. ["0", "1", "2" ...]
	var indexArray = [String]()
	for (index, _) in Array(destinationNames).enumerated() {
		indexArray.append(("\(index)"))
	}

	var differentCombinations = combinations(indexArray)

	differentCombinations.removeAll(where:{ $0.count < indexArray.count })

	// Now go through each combination, convert back names and calculate total distance of each route
	for item in differentCombinations {

		var totalDistance = 0
		for i in 0..<item.count-1
		{
			let name1 = Array(destinationNames)[Int(item[i])!]
			let name2 = Array(destinationNames)[Int(item[i+1])!]

			let route = "\(name1)\(name2)"
			totalDistance += distancesDictionary[route]!

		}

		calculatedDistancesDictionary[item.description] = totalDistance
	}

	let shortestDistance = calculatedDistancesDictionary.values.sorted().first!
	let longestDistance = calculatedDistancesDictionary.values.sorted().last!

	print("Shortest distance: \(shortestDistance)") // 207
	print("Longest distance: \(longestDistance)")   // 804
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

