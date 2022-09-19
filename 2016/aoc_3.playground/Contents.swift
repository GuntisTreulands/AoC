import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


calculateValidTriangleCount(test)
calculateValidTriangleCount(input) // 983
calculateValidTriangleCountV2(input) // 1836


func calculateValidTriangleCount(_ measurements: String) {
	var measurementList = measurements.components(separatedBy: "\n")
	measurementList.removeAll(where: { $0.isEmpty == true })

	var validTriangles = [String]()

	for measurement in measurementList {
		var components = measurement.components(separatedBy: " ")
		components.removeAll(where: { $0.isEmpty == true })


		if Int(components[0])! + Int(components[1])! > Int(components[2])!
			&& Int(components[0])! + Int(components[2])! > Int(components[1])!
			&& Int(components[1])! + Int(components[2])! > Int(components[0])! {
			validTriangles.append(measurement)
		}
	}

	print("Valid triangles: \(validTriangles.count)")
}

func calculateValidTriangleCountV2(_ measurements: String) {
	var measurementList = measurements.components(separatedBy: "\n")
	measurementList.removeAll(where: { $0.isEmpty == true })

	var validTriangles = [String]()

	var index = 0

	repeat {
		var components1 = measurementList[index].components(separatedBy: " ")
		components1.removeAll(where: { $0.isEmpty == true })

		var components2 = measurementList[index+1].components(separatedBy: " ")
		components2.removeAll(where: { $0.isEmpty == true })

		var components3 = measurementList[index+2].components(separatedBy: " ")
		components3.removeAll(where: { $0.isEmpty == true })

		if Int(components1[0])! + Int(components2[0])! > Int(components3[0])!
			&& Int(components1[0])! + Int(components3[0])! > Int(components2[0])!
			&& Int(components2[0])! + Int(components3[0])! > Int(components1[0])! {
			validTriangles.append("\(components1[0]) \(components2[0]) \(components3[0])")
		}

		if Int(components1[1])! + Int(components2[1])! > Int(components3[1])!
			&& Int(components1[1])! + Int(components3[1])! > Int(components2[1])!
			&& Int(components2[1])! + Int(components3[1])! > Int(components1[1])! {
			validTriangles.append("\(components1[1]) \(components2[1]) \(components3[1])")
		}

		if Int(components1[2])! + Int(components2[2])! > Int(components3[2])!
			&& Int(components1[2])! + Int(components3[2])! > Int(components2[2])!
			&& Int(components2[2])! + Int(components3[2])! > Int(components1[2])! {
			validTriangles.append("\(components1[2]) \(components2[2]) \(components3[2])")
		}

		index += 3

	} while index <= measurementList.count-3

	print("Valid triangles: \(validTriangles.count)")
}

