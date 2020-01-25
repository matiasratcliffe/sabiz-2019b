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
		spotTestingBoardWithSpots: 10
		and: (RegularSpot with: AtomicBombEffect new)
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
		spotTestingBoardWithSpots: 5
		and: (RegularSpot with: CardGivingEffect new)
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
	| game board |
	board := testResource
		spotTestingBoardWithSpots: 5
		and: JailSpot new
		at: 3
		throwing: {(SequentialDice withSequence: {2. 3. 4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 0.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game lapOf: player1) equals: 0.
	"This does not count as it is not the maximum value of the dice"
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game lapOf: player1) equals: 0.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 2.
	self assert: (game lapOf: player1) equals: 1.
]

{ #category : #'tests - jailspot' }
SpotTest >> testJailSpotProducesNoEffectAfterLandingOnIt [
	| game board |
	board := testResource
		spotTestingBoardWithSpots: 5
		and: JailSpot new
		at: 3
		throwing: {(SequentialDice withSequence: {2})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game lapOf: player1) equals: 0
]

{ #category : #'tests - moonwalk' }
SpotTest >> testMoonWalkDoesNotAffectPlayersThatHaveAlreadyFinished [
	| game board |
	board := testResource
		spotTestingBoardWithSpots: 10
		and: (RegularSpot with: MoonWalkEffect new)
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
		spotTestingBoardWithSpots: 8
		and: (RegularSpot with: (MoonWalkEffect goingBack: 3))
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
		spotTestingBoardWithSpots: 5
		and: (RegularSpot with: AtomicBombEffect new)
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
		spotTestingBoardWithSpots: 9
		and: (RegularSpot with: SpeedUpEffect new)
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
		spotTestingBoardWithSpots: 6
		and: (RegularSpot with: SpeedUpEffect new)
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
		spotTestingBoardWithSpots: 6
		and: (RegularSpot with: WormHoleEffect new)
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
		spotTestingBoardWithSpots: 6
		and: (RegularSpot with: WormHoleEffect new)
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
	board := testResource effectlessRegularBoardWithSpots: 5
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
		spotTestingBoardWithSpots: 6
		and: (RegularSpot with: TimeMachineEffect new)
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
		spotTestingBoardWithSpots: 6
		and: (RegularSpot with: TimeMachineEffect new)
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
