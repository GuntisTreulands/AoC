import UIKit
import Foundation


let testData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"test", ofType: "txt")!)!
let inputData = FileManager.default.contents(atPath: Bundle.main.path(forResource:"input", ofType: "txt")!)!

var test = String(data:testData, encoding:String.Encoding.utf8)!
var input = String(data:inputData, encoding:String.Encoding.utf8)!

let alphabeth = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

//sumOfSectorIDsOfRealRooms(test) // 1514
//sumOfSectorIDsOfRealRooms(input) // 185371
sumOfSectorIDsOfRealRooms(input, part2: true) // 984

func sumOfSectorIDsOfRealRooms(_ input: String, part2: Bool = false) {
	var rooms = input.components(separatedBy: "\n")
	rooms.removeAll(where: { $0.isEmpty })

	var sectorIDSum = 0

	for room in rooms {
		let parts = room.components(separatedBy: "[")
		let roomName = parts.first!
		let roomChecksum = parts.last!.replacingOccurrences(of: "]", with: "")
		let sectorID = roomName.components(separatedBy: "-").last!
		let clearRoomName = roomName.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: sectorID, with: "")

		let checkSumRepeatsList = roomChecksum.map({ roomName.components(separatedBy: String($0)).count-1 })

		// In case checkum repeats list does not contain any item with 0 count, and it is in sorted order (Most repeats come first)
		if !checkSumRepeatsList.contains(0) && checkSumRepeatsList == checkSumRepeatsList.sorted().reversed()  {

			let allLettersRepeatsList = Array(clearRoomName).map({ clearRoomName.components(separatedBy: String($0)).count-1 })

			let maxRepeatedLetter = Array(allLettersRepeatsList.sorted().reversed()).first!

			// In case the actual room name does not contain a letter that is even more repeated
			if maxRepeatedLetter == checkSumRepeatsList.first! {
				sectorIDSum += Int(sectorID)!

				if part2 == true {
					let validRoomName = roomName.replacingOccurrences(of: "-", with: " ").replacingOccurrences(of: sectorID, with: "")
					var decodedRoomName = ""
					for letter in validRoomName {
						decodedRoomName += adjustedItemUsing(start: String(letter), counter: Int(sectorID)!)
					}

					if decodedRoomName == "northpole object storage " {
						print("North Pole object storage sector ID: \(sectorID)")
					}
				}
			}
		}
	}

	if part2 == false {
		print("Sector ID Sum: \(sectorIDSum)")
	}
}

func adjustedItemUsing(start item: String, counter: Int) -> String {
	if item == " " { return " " }

 	let startIndex = alphabeth.firstIndex(of: item)!
 	var addition = (counter % alphabeth.count)
 	addition += startIndex
	let newIndex = addition > alphabeth.count-1 ? (addition - alphabeth.count) : addition

	return String(alphabeth[newIndex])
}
