import UIKit
import Foundation
import CryptoKit

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }


var requirement1 = "abcdef"
var requirement2 = "pqrstuv"
var requirement3 = "yzbqklnj"


hashFromAKey(requirement1)
hashFromAKey(requirement2)
hashFromAKey(requirement3) // 282749
hash6FromAKey(requirement3) // 9962624



func hashFromAKey(_ key: String) {

	let queue = OperationQueue()
	queue.name = "concurrent"
	queue.qualityOfService = .background
	queue.maxConcurrentOperationCount = 4

	for i in 0 ..< 400_000 {
		queue.addOperation {
			let md5 = "\(MD5(string:"\(key)\(i)") as NSData)"
			if md5.hasPrefix("{length = 16, bytes = 0x00000") {
				print("md5 \(md5) found for key \(key) and addition \(i)")
			}
//			let md5 = MD5(string:"\(key)\(i)").map { String(format: "%02hhx", $0) }.joined()
//			if md5.hasPrefix("00000") {
//				print("md5 \(md5) found for key \(key) and addition \(i)")
//			}
		}
	}
}


func hash6FromAKey(_ key: String) {

	let queue = OperationQueue()
	queue.name = "concurrent"
	queue.qualityOfService = .background
	queue.maxConcurrentOperationCount = 8

	for i in 0 ..< 10_000_000 {
		queue.addOperation {
			let md5 = "\(MD5(string:"\(key)\(i)") as NSData)"
			if md5.hasPrefix("{length = 16, bytes = 0x00") {
				if md5.hasPrefix("{length = 16, bytes = 0x000000") {
					print("md5 \(md5) found for key \(key) and addition \(i)")
				}
			}
		}
	}
}

