"
This class contains tests about the game
"
Class {
	#name : #GameTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #'tests - game state' }
GameTest >> testAllPlayersStartAtFirstSpot [
	| game |
	game := Game
		playedBy:	 {player1. player2}
		on: testResource standardBoard
		using: testResource standardDeckOfCards.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game positionOf: player2) equals: 1
]

{ #category : #'tests - game state' }
GameTest >> testAllPlayersStartAtLapZero [
	| game |
	game := Game
		playedBy: {player1. player2}
		on: testResource standardBoard
		using: testResource standardDeckOfCards.
	self assert: (game lapOf: player1) equals: 0.
	self assert: (game lapOf: player2) equals: 0
]

{ #category : #'tests - game state' }
GameTest >> testAllPlayersStartWithTwoCards [
	| game |
	game := testResource standardGame.
	game players
		do:
			[ :player | self assert: (game cardsInHandOf: player) size equals: 2 ]
]

{ #category : #'test - accessing' }
GameTest >> testCantCheckThePositionOfAPlayerThatIsNotInTheGame [
	self
		should: [ testResource standardGame positionOf: (Player named: #PlayerFromAnotherGame) ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Asked for a player that is not in the game'
]

{ #category : #'tests - instance creation' }
GameTest >> testCantCreateGameWithoutPlayers [
	self
		should: [ Game
				playedBy: {}
				on: testResource standardBoard
				using: testResource standardDeckOfCards ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cant create a game with no players'
]

{ #category : #'tests - instance creation' }
GameTest >> testCantHaveDupplicatedPlayers [
	self
		should: [ Game
				playedBy: {player1. player1}
				on: testResource standardBoard
				using: testResource standardDeckOfCards ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The player set contains a duplicate'
]

{ #category : #'test - playing' }
GameTest >> testCantPlayMoreRoundsOnceGameIsOver [
	| game |
	game := testResource standardGame.
	game playAnEntireGameWithoutPlayingCards.
	self
		should: [ game playOneRoundWithoutPlayingCards ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Game is already over'
]

{ #category : #'test - accessing' }
GameTest >> testGameHasGivenDeckOfCards [
	| game deck |
	deck := testResource standardDeckOfCards.
	game := Game
		playedBy: testResource standardSetOfPlayers
		on: testResource standardBoard
		using: deck.
	self assert: game deck equals: deck
]

{ #category : #'test - accessing' }
GameTest >> testGameHasGivenNumberOfPlayers [
	| game |
	game := Game
		playedBy: {player1}
		on: testResource standardBoard
		using: testResource standardDeckOfCards.
	self assert: game numberOfPlayers equals: 1
]

{ #category : #'test - accessing' }
GameTest >> testGameHasGivenPlayer [
	| game |
	game := Game
		playedBy: {player1}
		on: testResource standardBoard
		using: testResource standardDeckOfCards.
	self assert: (game isPlayedBy: player1)
]

{ #category : #'tests - game state' }
GameTest >> testGameShowsCorrectPlayersThatAreStillPlayingAfterSomeoneFinishes [
	| game |
	game := Game
		playedBy: {player1. player2}
		on: (testResource effectlessRegularBoardWithDiceLoadedWithSpotsNumberAndSpots: 10)
		using: testResource standardDeckOfCards.
	self assert: game players equals: game playersStillPlaying.
	game throwDicesFor: player1.
	self assert: game playersStillPlaying equals: { player2 }
]

{ #category : #'test - playing' }
GameTest >> testGoingBackToLastSpotDecreasesTheCorrectNumberOfLapsOfAPlayer [
	| game board |
	board := testResource
		effectlessRegularBoardWithSpots: 10
		throwing: {(SequentialDice withSequence: {3 . -4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game lapOf: player1) equals: -1
]

{ #category : #'test - playing' }
GameTest >> testOngoingGameShowsExpectedPlayerPlacesAfterOneRound [
	| game board |
	board := testResource
		effectlessRegularBoardWithSpots: 10
		throwing: {(SequentialDice withSequence: {3 . 4 . 11})}.
	game := Game
		playedBy: {player1. player2. player3}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self
		assert: game currentRanking
		equals: {player3. player2. player1}
]

{ #category : #'test - playing' }
GameTest >> testPlayerCantPlayUnlessItsHisTurn [
	| game board |
	board := testResource
		effectlessRegularBoardWithSpots: 10
		throwing: {SequentialDice withSequence: {1}}.
	game := Game
		playedBy: {player1. player2}
		on: board 
		using: testResource standardDeckOfCards.
	self assert: game playerWhoseTurnItIsToPlay equals: player1.
	game throwDicesFor: player1.
	self assert: game playerWhoseTurnItIsToPlay equals: player2.
	game throwDicesFor: player2.
	self assert: game playerWhoseTurnItIsToPlay equals: player1.
	game throwDicesFor: player1.
	self assert: game playerWhoseTurnItIsToPlay equals: player2.
	self
		should: [ game throwDicesFor: player1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Trying to move a player out of turn'
]

{ #category : #'test - playing' }
GameTest >> testPlayerCompletesALapAfterGoingOverTheLastSpot [
	| game board |
	board := testResource
		effectlessRegularBoardWithSpots: 10 
		throwing: {(SequentialDice withSequence: {7 . 4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game lapOf: player1) equals: 1
]

{ #category : #'test - playing' }
GameTest >> testPlayerOneWonTheGame [
	| game |
	game := Game
		playedBy: {player1. player2}
		on: (testResource effectlessRegularBoardWithDiceLoadedWithSpotsNumberAndSpots: 10)
		using: testResource standardDeckOfCards.
	game playAnEntireGameWithoutPlayingCards.
	self assert: game winner equals: player1
]

{ #category : #'test - playing' }
GameTest >> testPlayersThatFinishedAreNoLongerInTurnWheel [
	| game board |
	board := testResource
		effectlessRegularBoardWithSpots: 10
		throwing: {(SequentialDice withSequence: {10. 1})}.
	game := Game
		playedBy: {player1. player2}
		on: board
		using: testResource standardDeckOfCards.
	self assert: game playerWhoseTurnItIsToPlay equals: player1.
	game throwDicesFor: player1.
	self assert: game playerWhoseTurnItIsToPlay equals: player2.
	game throwDicesFor: player2.
	self assert: game playerWhoseTurnItIsToPlay equals: player2.
	game throwDicesFor: player2.
	self assert: game playerWhoseTurnItIsToPlay equals: nil.

]

{ #category : #'test - playing' }
GameTest >> testPositionOfPlayerIsCorrectAfterCompletingAndLosingALap [
	| game board |
	board := testResource
		effectlessRegularBoardWithSpots: 10 
		throwing: {(SequentialDice withSequence: {-4 . 4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 7.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 1
]

{ #category : #'test - playing' }
GameTest >> testPositionOfPlayerIsCorrectAfterLosingAndCompletingALap [
	| game board |
	board := testResource
		effectlessRegularBoardWithSpots: 10 
		throwing: {(SequentialDice withSequence: {-4 . 4})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 7.
	game playOneRoundWithoutPlayingCards.
	self assert: (game positionOf: player1) equals: 1
]

{ #category : #'test - playing' }
GameTest >> testReachingLastSpotWithoutRoundingTheBoardDoesNotIncrementLapNumber [
	| game board |
	board := testResource
		effectlessRegularBoardWithSpots: 10 
		throwing: {(SequentialDice withSequence: {9})}.
	game := Game
		playedBy: {player1}
		on: board
		using: testResource standardDeckOfCards.
	game playOneRoundWithoutPlayingCards.
	self assert: (game lapOf: player1) equals: 0
]

{ #category : #'test - playing' }
GameTest >> testRiggedGameEndsAsExpected [
	| game |
	game := Game
		playedBy: {player1. player2. player3}
		on: (testResource effectlessRegularBoardWithDiceLoadedWithSpotsNumberAndSpots: 10)
		using: testResource standardDeckOfCards.
	game playAnEntireGameWithoutPlayingCards.
	self
		assert: game finishRanking
		equals: {player1. player2. player3}
]

{ #category : #'tests - game state' }
GameTest >> testRoundNumberIncreasesEveryRound [
	| game board |
	board :=  testResource
		effectlessRegularBoardWithSpots: 5
		throwing: {SequentialDice withSequence: {1}}.
	game := Game
		playedBy: { player1. player2. player3 } 
		on: board
		using: testResource standardDeckOfCards.
	self assert: game roundNumber equals: 1.
	game playOneRoundWithoutPlayingCards.
	self assert: game roundNumber equals: 2.
	game playOneRoundWithoutPlayingCards.
	self assert: game roundNumber equals: 3.
	game playOneRoundWithoutPlayingCards.
	self assert: game roundNumber equals: 4
]

{ #category : #'tests - game state' }
GameTest >> testSimplisticGameEndsSuccessfully [
	| game |
	game := testResource simplisticTestingGame.
	game playAnEntireGameWithoutPlayingCards.
	self assert: game isOver
]

{ #category : #'test - playing' }
GameTest >> testSimplisticGameYieldsExpectedStateList [
	| game expectedHistory cards |
	cards := { Card with: AccelerationEffect new. Card with: AccelerationEffect new }.
	expectedHistory := {
		PlayerState on: 1 and: 0 and: 0 holding: cards.
		PlayerState on: 1 and: 0 and: 1 holding: cards.
		PlayerState on: 5 and: 0 and: 1 holding: cards.
		PlayerState on: 5 and: 0 and: 2 holding: cards.
		PlayerState on: 9 and: 0 and: 2 holding: cards.
		PlayerState on: 9 and: 0 and: 3 holding: cards.
		PlayerState on: 3 and: 1 and: 3 holding: cards	
	} asOrderedCollection.
	game := testResource simplisticTestingGame.
	game playAnEntireGameWithoutPlayingCards.
	self assert: (game historyOf: player1) equals: expectedHistory.
	self assert: (game historyOf: player2) equals: expectedHistory
]

{ #category : #'tests - game state' }
GameTest >> testStandardGameEndsSuccessfully [
	| game |
	game := testResource standardGame.
	game playAnEntireGameWithoutPlayingCards.
	self assert: game isOver
]
