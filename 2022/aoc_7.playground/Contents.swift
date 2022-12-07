import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!


doTask(test) // Part1: 95437      Part2: 24933642
doTask(input) // Part1: 1989474   Part2: 1111607


class DataObject {
	var name: String = ""
	var subData: [String: DataObject] = [:]
	var subFiles: [String] = []
	var parent: DataObject?
	var size: Int {
		var tmp = 0

		for file in subFiles {
			tmp += Int(String(file.components(separatedBy: " ").first!))!
		}

		for data in subData.values {
			tmp += data.size
		}

		return tmp
	}

	init(_ realName: String, parentData: DataObject?) {
		name = realName
		parent = parentData
	}

}


func doTask(_ string: String) {

	let startDataObject = DataObject.init("/", parentData: nil)

	var currentObject: DataObject!

	let instructions = string.components(separatedBy: "\n")

	for instruction in instructions {
		if instruction.isEmpty  { continue }

		if instruction.hasPrefix("$ cd /") { // Go out to outmost level

			currentObject = startDataObject

		} else if instruction.hasPrefix("$ ls") { // List all items
			// Skip this line

		} else if instruction.hasPrefix("$ cd ..") { // Go out one level
			// At this point we probably need to store all sizes for current level
			currentObject = currentObject.parent

		} else if instruction.hasPrefix("$ cd ") { // Go in a directory
			let dirName = String(instruction.split(separator: " ").last!)
			currentObject = currentObject.subData[dirName]!

		} else if instruction.hasPrefix("dir ") { // Contains directory with name.. x

			let newDirName = String(instruction.split(separator: " ").last!)
			let newData = DataObject.init(newDirName, parentData: currentObject)
			currentObject.subData[newDirName] = newData

		} else { // Contains file, size + filename.
			var subFiles = currentObject.subFiles
			subFiles.append(instruction)
			currentObject.subFiles = subFiles
		}
	}


	print("\nTotalSize: \(startDataObject.size)")

	let totalDirectorySizes = returnSizes(directory: startDataObject)

	let filteredSizes = totalDirectorySizes.filter { $0 <= 100000 }

	print("Total sum of smaller ones: \(filteredSizes.reduce(0) {$0 + $1})")

	let necessarySpace = 30000000 - (70000000 - startDataObject.size)

	print("Necessary size to free up: \(necessarySpace)")


	let targetDirectory = totalDirectorySizes.sorted().filter { $0 > necessarySpace }

	print("Target directory size to delete \(targetDirectory.first!)")
}


func returnSizes(directory: DataObject) -> [Int] {
	var sizes: [Int] = []

	for subDirectory in directory.subData.values {
		sizes.append(contentsOf: returnSizes(directory: subDirectory))
		sizes.append(subDirectory.size)
	}

	return sizes
}
