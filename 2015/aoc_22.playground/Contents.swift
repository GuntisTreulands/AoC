import UIKit
import Foundation


struct Action: Equatable {
	var name: String
	var priceMana: Int
	var doDamage: Int = 0
	var doIncreaseMana: Int = 0
	var doIncreaseArmor: Int = 0
	var doHeal: Int = 0
	var repeats: Int = 0
}

let magicMissle = Action.init(name: "Magic Missile", priceMana: 53, doDamage: 4)
let drain = Action.init(name: "Drain", priceMana: 73, doDamage: 2, doHeal: 2)
let shield = Action.init(name: "Shield", priceMana: 113, doIncreaseArmor: 7, repeats: 6)
let poison = Action.init(name: "Poison", priceMana: 173, doDamage: 3, repeats: 6)
let recharge = Action.init(name: "Recharge", priceMana: 229, doIncreaseMana: 101, repeats: 5)


struct Stats {
	var hitPoints: Int
	var mana: Int = 0
	var damage: Int = 0
}


var testPlayer = Stats.init(hitPoints: 10, mana: 250)
var testBoss = Stats.init(hitPoints: 13, damage: 8)  // 226

var testPlayer2 = Stats.init(hitPoints: 10, mana: 250)
var testBoss2 = Stats.init(hitPoints: 14, damage: 8)  // 641


var inputPlayer = Stats.init(hitPoints: 50, mana: 500)
var inputBoss = Stats.init(hitPoints: 51, damage: 9)  // Part1:900  Part2: 1216



var goodMinimum = 0

let result = gameOn(inputPlayer.hitPoints, playerMana:inputPlayer.mana, enemyHP: inputBoss.hitPoints, enemyDamage: inputBoss.damage, minimum: 0, shieldR: 0, poisonR: 0, rechargeR: 0, levelHard: false)

print("Lowest mana count required to win: \(result.minimum)\n")




func gameOn(_ playerHP: Int, playerMana: Int, enemyHP: Int, enemyDamage: Int, minimum: Int, shieldR: Int, poisonR: Int, rechargeR: Int, levelHard: Bool) -> (minimum: Int, playerHP: Int, playerMana: Int, enemyHP: Int, enemyDamage: Int) {

	if minimum > goodMinimum && goodMinimum > 0 {
		return (minimum:50000, playerHP: -1, playerMana: playerMana, enemyHP: enemyHP, enemyDamage: enemyDamage)
	}

	if enemyHP <= 0 && playerHP > 0 {
		return (minimum: minimum, playerHP: playerHP, playerMana: playerMana, enemyHP: enemyHP, enemyDamage: enemyDamage)
	}



	var playerHitPointsAdjust = playerHP
	var playerManaAdjust = playerMana
	var enemyHitPointsAdjust = enemyHP


	var enemyHP = enemyHP
	enemyHP -= poisonR >= 1 ? poison.doDamage : 0


	let playerHP = playerHP - (levelHard ? 1 : 0)

	if playerHP <= 0 || minimum > 1500 || playerMana < magicMissle.priceMana {
		return (minimum:50000, playerHP: -1, playerMana: playerMana, enemyHP: enemyHP, enemyDamage: enemyDamage)
	}


	if enemyHP <= 0 && playerHP > 0 {
		return (minimum: minimum, playerHP: playerHP, playerMana: playerMana, enemyHP: enemyHP, enemyDamage: enemyDamage)
	}

	if poisonR >= 2 {
		enemyHP -= poisonR >= 1 ? poison.doDamage : 0
	}



	var playerMana = playerMana
	playerMana += rechargeR >= 1 ? recharge.doIncreaseMana : 0
	playerMana += rechargeR >= 1 ? recharge.doIncreaseMana : 0


	let canDoMissle = playerMana >= magicMissle.priceMana
	let canDoDrain = playerMana >= drain.priceMana
	let canDoShield = playerMana >= shield.priceMana && shieldR <= 2
	let canDoPoison = playerMana >= poison.priceMana && poisonR <= 2
	let canDoRecharge = playerMana >= recharge.priceMana && rechargeR <= 2

	if !canDoMissle && !canDoDrain && !canDoRecharge && !canDoShield && !canDoPoison {
		return (minimum: 0, playerHP: -1, playerMana: playerMana, enemyHP: enemyHP, enemyDamage: enemyDamage)
	}


	var finalMinimum = 0


	if canDoMissle {

		var tmpPlayerHitPoints1 = playerHP
		var tmpEnemyHitPoints1 = enemyHP
		var tmpPlayerMana1 = playerMana
		var tmpMin1 = minimum

		tmpEnemyHitPoints1 -= magicMissle.doDamage
		tmpPlayerMana1 -= magicMissle.priceMana
		tmpMin1 += magicMissle.priceMana

		if tmpEnemyHitPoints1 > 0 {

			tmpPlayerHitPoints1 = tmpPlayerHitPoints1 - max(1, enemyDamage - (shieldR > 1 ? shield.doIncreaseArmor : 0))

			let result = gameOn(tmpPlayerHitPoints1, playerMana: tmpPlayerMana1, enemyHP: tmpEnemyHitPoints1, enemyDamage: enemyDamage, minimum: tmpMin1, shieldR: shieldR - 2, poisonR: poisonR - 2, rechargeR: rechargeR - 2, levelHard: levelHard)

			tmpMin1 = result.minimum
			tmpPlayerHitPoints1 = result.playerHP
			tmpEnemyHitPoints1 = result.enemyHP
			tmpPlayerMana1 = result.playerMana
		}

		if(tmpPlayerHitPoints1 > 0 && tmpEnemyHitPoints1 <= 0 && (tmpMin1 < finalMinimum || finalMinimum == 0)) {

			finalMinimum = tmpMin1
			playerHitPointsAdjust = tmpPlayerHitPoints1
			enemyHitPointsAdjust = tmpEnemyHitPoints1
			playerManaAdjust = tmpPlayerMana1
		}

	}

	if canDoDrain {

		var tmpPlayerHitPoints2 = playerHP
		var tmpEnemyHitPoints2 = enemyHP
		var tmpPlayerMana2 = playerMana
		var tmpMin2 = minimum

		tmpEnemyHitPoints2 -= drain.doDamage
		tmpPlayerHitPoints2 += drain.doHeal
		tmpPlayerMana2 -= drain.priceMana

		tmpMin2 += drain.priceMana

		if tmpEnemyHitPoints2 > 0 {

			tmpPlayerHitPoints2 = tmpPlayerHitPoints2 - max(1, enemyDamage - (shieldR > 1 ? shield.doIncreaseArmor : 0))

			let result = gameOn(tmpPlayerHitPoints2, playerMana: tmpPlayerMana2, enemyHP: tmpEnemyHitPoints2, enemyDamage: enemyDamage, minimum: tmpMin2, shieldR: shieldR - 2, poisonR: poisonR - 2, rechargeR: rechargeR - 2, levelHard: levelHard)

			tmpMin2 = result.minimum
			tmpPlayerHitPoints2 = result.playerHP
			tmpEnemyHitPoints2 = result.enemyHP
			tmpPlayerMana2 = result.playerMana
		}

		if(tmpPlayerHitPoints2 > 0 && tmpEnemyHitPoints2 <= 0 && (tmpMin2 < finalMinimum || finalMinimum == 0)) {

			finalMinimum = tmpMin2
			playerHitPointsAdjust = tmpPlayerHitPoints2
			enemyHitPointsAdjust = tmpEnemyHitPoints2
			playerManaAdjust = tmpPlayerMana2
		}

	}

	if canDoShield {

		var tmpPlayerHitPoints3 = playerHP
		var tmpEnemyHitPoints3 = enemyHP
		var tmpPlayerMana3 = playerMana
		var tmpMin3 = minimum


		tmpPlayerMana3 -= shield.priceMana
		tmpMin3 += shield.priceMana


		if tmpEnemyHitPoints3 > 0 {

			tmpPlayerHitPoints3 = tmpPlayerHitPoints3 - max(1, enemyDamage - shield.doIncreaseArmor)

			let result = gameOn(tmpPlayerHitPoints3, playerMana: tmpPlayerMana3, enemyHP: tmpEnemyHitPoints3, enemyDamage: enemyDamage, minimum: tmpMin3, shieldR: shield.repeats - 1, poisonR: poisonR - 2, rechargeR: rechargeR - 2, levelHard: levelHard)

			tmpMin3 = result.minimum
			tmpPlayerHitPoints3 = result.playerHP
			tmpEnemyHitPoints3 = result.enemyHP
			tmpPlayerMana3 = result.playerMana
		}

		if(tmpPlayerHitPoints3 > 0 && tmpEnemyHitPoints3 <= 0 && (tmpMin3 < finalMinimum || finalMinimum == 0)) {

			finalMinimum = tmpMin3
			playerHitPointsAdjust = tmpPlayerHitPoints3
			enemyHitPointsAdjust = tmpEnemyHitPoints3
			playerManaAdjust = tmpPlayerMana3
		}
	}

	if canDoPoison {

		var tmpPlayerHitPoints4 = playerHP
		var tmpEnemyHitPoints4 = enemyHP
		var tmpPlayerMana4 = playerMana
		var tmpMin4 = minimum

		tmpEnemyHitPoints4 -= poison.doDamage
		tmpPlayerMana4 -= poison.priceMana

		tmpMin4 += poison.priceMana

		if tmpEnemyHitPoints4 > 0 {

			tmpPlayerHitPoints4 = tmpPlayerHitPoints4 - max(1, enemyDamage - (shieldR > 1 ? shield.doIncreaseArmor : 0))

			let result = gameOn(tmpPlayerHitPoints4, playerMana: tmpPlayerMana4, enemyHP: tmpEnemyHitPoints4, enemyDamage: enemyDamage, minimum: tmpMin4, shieldR: shieldR - 2, poisonR: poison.repeats - 1, rechargeR: rechargeR - 2, levelHard: levelHard)

			tmpMin4 = result.minimum
			tmpPlayerHitPoints4 = result.playerHP
			tmpEnemyHitPoints4 = result.enemyHP
			tmpPlayerMana4 = result.playerMana
		}

		if(tmpPlayerHitPoints4 > 0 && tmpEnemyHitPoints4 <= 0 && (tmpMin4 < finalMinimum || finalMinimum == 0)) {

			finalMinimum = tmpMin4
			playerHitPointsAdjust = tmpPlayerHitPoints4
			enemyHitPointsAdjust = tmpEnemyHitPoints4
			playerManaAdjust = tmpPlayerMana4
		}
	}

	if canDoRecharge {

		var tmpPlayerHitPoints5 = playerHP
		var tmpEnemyHitPoints5 = enemyHP
		var tmpPlayerMana5 = playerMana
		var tmpMin5 = minimum

		tmpPlayerMana5 += recharge.doIncreaseMana
		tmpPlayerMana5 -= recharge.priceMana

		tmpMin5 += recharge.priceMana

		if tmpEnemyHitPoints5 > 0 {

			tmpPlayerHitPoints5 = tmpPlayerHitPoints5 - max(1, enemyDamage - (shieldR > 1 ? shield.doIncreaseArmor : 0))

			let result = gameOn(tmpPlayerHitPoints5, playerMana: tmpPlayerMana5, enemyHP: tmpEnemyHitPoints5, enemyDamage: enemyDamage, minimum: tmpMin5, shieldR: shieldR - 2, poisonR: poisonR - 2, rechargeR: recharge.repeats - 1, levelHard: levelHard)

			tmpMin5 = result.minimum
			tmpPlayerHitPoints5 = result.playerHP
			tmpEnemyHitPoints5 = result.enemyHP
			tmpPlayerMana5 = result.playerMana
		}

		if(tmpPlayerHitPoints5 > 0 && tmpEnemyHitPoints5 <= 0 && (tmpMin5 < finalMinimum || finalMinimum == 0)) {

			finalMinimum = tmpMin5
			playerHitPointsAdjust = tmpPlayerHitPoints5
			enemyHitPointsAdjust = tmpEnemyHitPoints5
			playerManaAdjust = tmpPlayerMana5
		}
	}

	if (goodMinimum == 0 && finalMinimum != 0) || (goodMinimum > finalMinimum && finalMinimum != 0) {
		goodMinimum = finalMinimum
		print("\(goodMinimum)")
	}

	return (minimum: finalMinimum, playerHP: playerHitPointsAdjust, playerMana: playerManaAdjust, enemyHP: enemyHitPointsAdjust, enemyDamage: enemyDamage)
}
