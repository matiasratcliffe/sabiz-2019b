"
This class contains tests about players
"
Class {
	#name : #PlayerTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
PlayerTest >> testCantPlayACardThatIsNotInTheHand [
	| game cardToPlay |
	game := Game
		playedBy: {player1. player2}
		on: testResource standardBoard
		using: (Deck with: {RepeatEffect new}).
	cardToPlay := Card with: OverloadEffect new.
	self
		should: [ game play: cardToPlay for: player1 on: player2 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'That card is not in the hand of the player'
]

{ #category : #tests }
PlayerTest >> testCardsInHandOfReturnsEmptyColectionIfThePlayerHasNoCards [ 
	| game |
	game := Game
		playedBy: {player1. player2}
		on: testResource standardBoard
		using: (Deck with: {AccelerationEffect new}).
	game play: (Card with: AccelerationEffect new) for: player1 on: game players.
	game play: (Card with: AccelerationEffect new) for: player1 on: game players.
	self assert: (game cardsInHandOf: player1) asArray equals: {  }

]

{ #category : #tests }
PlayerTest >> testPlayerStateTurnsIntoExpectedDescriptiveString [
	self assert: (PlayerState on: 1 and: 1 holding: {}) asString equals: '(1, 1, 0)()'
]

{ #category : #tests }
PlayerTest >> testPlayerThatFinishedCantPlayACard [
	| game card |
	game := Game
		playedBy: {player1. player2}
		on: (testResource effectlessRegularBoardWithDiceLoadedWithSpotsNumberAndSpots: 10)
		using: (Deck with: {(Card with: RepeatEffect new)}).
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	card := (game cardsInHandOf: player1) first.
	self should: [ game play: card for: player1 on: {player2} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Trying to play a card for a player that has already finished'
]

{ #category : #tests }
PlayerTest >> testPlayerTurnsIntoExpectedDescriptiveString [
	self assert: (Player named: 'player') asString equals: 'player'
]

{ #category : #tests }
PlayerTest >> testTwoIdenticalPlayerStatesYieldSameHash [
	| state1 state2 |
	state1 := PlayerState on: 1 and: 1 holding: {  }.
	state2 := PlayerState on: 1 and: 1 holding: {  }.
	self assert: state1 equals: state2.
	self assert: state1 hash equals: state2 hash
]

{ #category : #tests }
PlayerTest >> testTwoPlayersWithTheDifferentNamesAreTheDifferentPlayers [
	self deny: (Player named: #player1) equals: (Player named: #player2)
]

{ #category : #tests }
PlayerTest >> testTwoPlayersWithTheSameNameAreTheSamePlayer [
	self assert: (Player named: #player1) equals: (Player named: #player1)
]
