"
This class contains tests about spots.
"
Class {
	#name : #SpotTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #'tests - atomicbomb' }
SpotTest >> testAtomicBombDoesNotAffectPlayersThatHaveAlreadyFinished [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 10
		and: AtomicBombEffect new
		at: 3
		throwing: {(SequentialDice withSequence: {13 . 1})}.
	game := Game
		playedBy: {player1. player2}
		on: board
		using: testResource standardDeckOfCards.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	self assert: (game playerHasFinished: player1).
	self assert: (game positionOf: player1) equals: 7.
	self assert: (game positionOf: player2) equals: 1
]

{ #category : #'tests - cardgiving' }
SpotTest >> testCardGivingSpotGivesOneCardToPlayerWhoTriggersIt [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 5
		and: CardGivingEffect new
		at: 5
		throwing: {(SequentialDice withSequence: {4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game cardsInHandOf: player1) size equals: 3
]

{ #category : #'tests - jailspot' }
SpotTest >> testJailSpotPreventsFromEscapingUntilPlayerGetsMaximumRollResult [
]

{ #category : #'tests - jailspot' }
SpotTest >> testJailSpotProducesNoEffectAfterLandingOnIt [
]

{ #category : #'tests - moonwalk' }
SpotTest >> testMoonWalkDoesNotAffectPlayersThatHaveAlreadyFinished [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 10
		and: MoonWalkEffect new
		at: 5
		throwing: {(SequentialDice withSequence: {10 . 2})}.
	game := Game
		playedBy: {player1. player2}
		on: board
		using: testResource standardDeckOfCards.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	self assert: (game playerHasFinished: player1).
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game positionOf: player2) equals: 5
]

{ #category : #'tests - moonwalk' }
SpotTest >> testMoonWalkReducesThePositionOfAllPlayerWhoDidNotTriggerIt [
	| board game |
	board := testResource
		effectTestingBoardWithSpots: 8
		and: (MoonWalkEffect goingBack: 3)
		at: 7
		throwing: {(SequentialDice withSequence: {1. 2. 3})}.
	game := Game
		playedBy: {player1. player2. player3}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 2.
	self assert: (game positionOf: player2) equals: 3.
	self assert: (game positionOf: player3) equals: 4.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 8.
	self assert: (game lapOf: player1) equals: -1.
	self assert: (game positionOf: player2) equals: 2.
	self assert: (game positionOf: player3) equals: 7
]

{ #category : #'tests - atomicbomb' }
SpotTest >> testPlayerTriggersAtomicBombAndEveryoneThatHasNotFinishedGoesBackToFirstSpotMaintainingLaps [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 5
		and: AtomicBombEffect new
		at: 3
		throwing: {(SequentialDice withSequence: {8. 3. 1})}.
	game := Game
		playedBy: {player1. player2. player3}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 4.
	self assert: (game lapOf: player1) equals: 1.
	self assert: (game positionOf: player2) equals: 4.
	self assert: (game lapOf: player2) equals: 0.
	self assert: (game positionOf: player3) equals: 2.
	self assert: (game lapOf: player3) equals: 0.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 2.
	self assert: (game lapOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 1.
	self assert: (game lapOf: player2) equals: 1.
	self assert: (game positionOf: player3) equals: 1.
	self assert: (game lapOf: player3) equals: 0
]

{ #category : #'tests - speedup' }
SpotTest >> testPlayerTriggersSpeedUpAndGoesForwardsFourSpots [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 9
		and: SpeedUpEffect new
		at: 5
		throwing: {(SequentialDice withSequence: {4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 9
]

{ #category : #'tests - speedup' }
SpotTest >> testPlayerTriggersSpeedUpAtPositionFiveAndGainsALapAfterGoingForwardFourPositions [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 6
		and: SpeedUpEffect new
		at: 5
		throwing: {(SequentialDice withSequence: {4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	self assert: (game lapOf: player1) equals: 0.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game lapOf: player1) equals: 1
]

{ #category : #'tests - wormhole' }
SpotTest >> testPlayerTriggersWormHoleAndGoesBackFourSpots [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 6
		and: WormHoleEffect new
		at: 6
		throwing: {(SequentialDice withSequence: {5})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 2
]

{ #category : #'tests - wormhole' }
SpotTest >> testPlayerTriggersWormHoleAtPositionTwoAndLosesALapAfterGoingBackFourPositions [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 6
		and: WormHoleEffect new
		at: 2
		throwing: {(SequentialDice withSequence: {6. 1})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 1.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 4.
	self assert: (game lapOf: player1) equals: 0
]

{ #category : #tests }
SpotTest >> testRegularSpotTurnsIntoExpectedDescriptiveString [
	self assert: (RegularSpot with: SpeedUpEffect new) asString equals: 'a SpeedUpSpot'
]

{ #category : #'tests - regular' }
SpotTest >> testSpotWithRegularEffectDoesNothing [
	| game board |
	board := testResource effectlessBoardWithSpots: 5
		throwing: {(SequentialDice withSequence: {4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 5
]

{ #category : #'tests - timemachine' }
SpotTest >> testTimeMachineAtFirstMovementOfPlayerReturnsHimToFirstPositionAndZeroNumberOfLaps [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 6
		and: TimeMachineEffect new
		at: 5
		throwing: {(SequentialDice withSequence: {4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 0
]

{ #category : #'tests - timemachine' }
SpotTest >> testTimeMachineReturnsPlayerToPositionAtPreviousRound [
	| game board |
	board := testResource
		effectTestingBoardWithSpots: 6
		and: TimeMachineEffect new
		at: 5
		throwing: {(SequentialDice withSequence: {2 . 8})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 0
]
