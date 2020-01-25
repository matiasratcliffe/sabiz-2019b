"
This class contains tests about cards and playerEffects in general
"
Class {
	#name : #CardTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #resources }
CardTest >> newCardTestingGameFor: cardEffect [
	^ self newCardTestingGameWith: (Deck with: {cardEffect})
]

{ #category : #resources }
CardTest >> newCardTestingGameWith: deck [
	| board |
	board := testResource
		effectlessRegularBoardWithSpots: 10
		throwing: {(SequentialDice withSequence: {1})}.
	^ self
		newCardTestingGameWith: deck
		on: board
]

{ #category : #resources }
CardTest >> newCardTestingGameWith: deck on: board [
	^ Game
		playedBy: {player1. player2}
		on: board
		using: deck
]

{ #category : #'tests - instant' }
CardTest >> testARepeatCardCantBePlayedOnAPlayerThatFinished [
	| game card |
	game := Game
		playedBy: {player1. player2}
		on: (testResource effectlessRegularBoardWithDiceLoadedWithSpotsNumberAndSpots: 10)
		using: (Deck with: {RepeatEffect new}).
	game throwDicesFor: player1.
	card := (game cardsInHandOf: player2) first.
	self
		should: [game play: card for: player2 on: {player1}]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The repeat card cant be played on a player that has already finished'
]

{ #category : #'tests - permanent' }
CardTest >> testASpeedCardCantBePlayedOnAPlayerThatFinished [
	| game card |
	game := Game
		playedBy: {player1. player2}
		on: (testResource effectlessRegularBoardWithDiceLoadedWithSpotsNumberAndSpots: 10)
		using: (Deck with: {SpeedEffect new}).
	game throwDicesFor: player1.
	card := (game cardsInHandOf: player2) first.
	self
		should: [game play: card for: player2 on: {player1}]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The speed card cant be played on a player that has already finished'
]

{ #category : #'tests - permanent' }
CardTest >> testAccelerationEffectIncreasesByOneRollResults [
	| game cardToPlay |
	game := self newCardTestingGameFor: AccelerationEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: game players.
	game throwDicesFor: player1.
	game play: cardToPlay for: player2 on: game players.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 4
]

{ #category : #'tests - permanent' }
CardTest >> testAccelerationMustBeTargetedToAllPlayers [
	| game cardToPlay |
	game := self newCardTestingGameFor: AccelerationEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: { player1. player2 }.
	game throwDicesFor: player1.
	self
		should: [game play: cardToPlay for: player2 on: { player1 }]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Tried to play acceleration card on a specific set of players instead of all of them'
]

{ #category : #'tests - permanent' }
CardTest >> testAnOverloadCardCantBePlayedOnAPlayerThatFinished [
	| game card |
	game := Game
		playedBy: {player1. player2}
		on: (testResource effectlessRegularBoardWithDiceLoadedWithSpotsNumberAndSpots: 10)
		using: (Deck with: {OverloadEffect new}).
	game throwDicesFor: player1.
	card := (game cardsInHandOf: player2) first.
	self
		should: [game play: card for: player2 on: {player1}]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The overload card cant be played on a player that has already finished'
]

{ #category : #'tests - instant' }
CardTest >> testCanOnlyPlayFreedomCardIfTargetPlayerIsInJail [
	| game board cardToPlay deck |
	board := testResource
		spotTestingBoardWithSpots: 5
		and: JailSpot new
		at: 3
		throwing: {(SequentialDice withSequence: {2})}.
	deck := Deck with: {FreedomEffect new}.
	game := Game
		playedBy: {player1}
		on: board
		using: deck.
	cardToPlay := Card with: FreedomEffect new.
	self
		should: [ game play: cardToPlay for: player1 on: {player1}]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The freedom card can only be played on a jailed player'.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game lapOf: player1) equals: 0.
	game play: cardToPlay for: player1 on: {player1}.
	self assert: (game positionOf: player1) equals: 4.
	self assert: (game lapOf: player1) equals: 0
]

{ #category : #'tests - instant' }
CardTest >> testCancellationCardAffectingAllPlayersRemovesOnlyOneGlobalEffect [
	| game deck |
	deck := GimmickDeck withSequence: {AccelerationEffect new. CancelationEffect new}.
	game := self newCardTestingGameWith: deck.
	game play: (Card with: AccelerationEffect new) for: player1 on: game players.
	game throwDicesFor: player1.
	game play: (Card with: AccelerationEffect new) for: player2 on: game players.
	game throwDicesFor: player2.
	game play: (Card with: CancelationEffect new) for: player2
		  on: (PlayedCard of: AccelerationEffect new to: game players).
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 5.
	self assert: (game positionOf: player2) equals: 4
]

{ #category : #'tests - instant' }
CardTest >> testCancellationCardAffectingOnePlayersRemovesOnlyOneOfHisLocalEffects [
	| game deck |
	deck := GimmickDeck withSequence: {SpeedEffect new. CancelationEffect new}.
	game := self	 newCardTestingGameWith: deck.
	game play: (Card with: SpeedEffect new) for: player1 on: {player1}.
	game throwDicesFor: player1.
	game play: (Card with: SpeedEffect new) for: player2 on: {player1}.
	game throwDicesFor: player2.
	game play: (Card with: CancelationEffect new) for: player2 on: (PlayedCard of: SpeedEffect new to: {player1}).
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 5.
	self assert: (game positionOf: player2) equals: 2.
]

{ #category : #'tests - permanent' }
CardTest >> testCantPlayAPermanentCardIfItsNotTheTurnOfThePlayer [
	| game cardToPlay |
	game := self newCardTestingGameFor: AccelerationEffect new.
	cardToPlay := (game cardsInHandOf: player2) first.
	self
		should: [ game play: cardToPlay for: player2 on: { player1. player2 } ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cant play a permanent card out of turn'
]

{ #category : #tests }
CardTest >> testCardTurnsIntoExpectedDescriptiveString [
	self assert: (Card with: AccelerationEffect new) asString equals: 'an AccelerationCard'
]

{ #category : #'tests - instant' }
CardTest >> testFreedomCardGetsTargetPlayerOutOfJailByPuttingHimIntoTheNextSpotWithoutTriggeringAnyEffects [
	| board game |
	board := Board
		with:
			{JailSpot new.
			(RegularSpot with: SpeedUpEffect new)}
		andLaps: 1
		throwing: testResource standardSetOfDices.
	game := Game
		playedBy: {player1}
		on: board
		using: (Deck with: {FreedomEffect new}).
	game play: (Card with: FreedomEffect new) for: player1 on: {player1}.
	self assert: (game positionOf: player1) equals: 2.
	self assert: (game lapOf: player1) equals: 0
]

{ #category : #'tests - instant' }
CardTest >> testInstantCardCanBePlayedEvenIfItIsNotTheTurnOfThePlayer [
	| game cardToPlay |
	game := self newCardTestingGameFor: RepeatEffect new.
	game throwDicesFor: player1.
	self assert: game playerWhoseTurnItIsToPlay equals: player2.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: {player1}.
	
]

{ #category : #'tests - permanent' }
CardTest >> testOverloadEffectDecreasesByTwoTheRollResultOfOnlyOnePlayer [
	| game cardToPlay |
	game := self newCardTestingGameFor: OverloadEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: {player2}.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 2.
	self assert: (game positionOf: player2) equals: 10.
	self assert: (game lapOf: player2) equals: -1
]

{ #category : #'tests - permanent' }
CardTest >> testOverloadEffectDecreasesByTwoTheRollResultOfOnlyOnePlayerAndIsAcumulative [
	| game cardToPlay |
	game := self newCardTestingGameFor: OverloadEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: {player1}.
	game throwDicesFor: player1.
	cardToPlay := (game cardsInHandOf: player2) first.
	game play: cardToPlay for: player2 on: {player1}.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 7.
	self assert: (game lapOf: player1) equals: -1.
	self assert: (game positionOf: player2) equals: 2
]

{ #category : #'tests - instant' }
CardTest >> testRedoCardActsAsAPermanentIfLastPlayedCardIsPermanent [
	| game deck |
	deck := GimmickDeck withSequence: {AccelerationEffect new. RedoEffect new}.
	game := self newCardTestingGameWith: deck.
	game play: (Card with: AccelerationEffect new) for: player1 on: game players.
	game throwDicesFor: player1.
	game play: (Card with: RedoEffect new) for: player2 on: game players.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 4
]

{ #category : #'tests - instant' }
CardTest >> testRedoCardActsAsAnInstantIfLastPlayedCardIsInstant [
	| game deck |
	deck := GimmickDeck withSequence: {SpeedEffect new. RedoEffect new}.
	game := self newCardTestingGameWith: deck.
	game play: (Card with: SpeedEffect new) for: player1 on: {player1}.
	game throwDicesFor: player1.
	game play: (Card with: RedoEffect new) for: player2 on: {player2}.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 3
]

{ #category : #'tests - instant' }
CardTest >> testRedoCardActsAsThePreviousOneOfThePreviousOneCardIsThePreviousOneIsAnotherRedo [
	| game deck |
	deck := GimmickDeck withSequence: {AccelerationEffect new. RedoEffect new}.
	game := self newCardTestingGameWith: deck.
	game play: (Card with: AccelerationEffect new) for: player1 on: game players.
	game play: (Card with: RedoEffect new) for: player1 on: game players.
	game throwDicesFor: player1.
	game play: (Card with: RedoEffect new) for: player2 on: game players.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 4.
	self assert: (game positionOf: player2) equals: 5
]

{ #category : #'tests - instant' }
CardTest >> testRedoCardCannotBePlayedIfAnotherCardsWereNeverPlayed [
	| game deck |
	deck := GimmickDeck withSequence: {Card with: AccelerationEffect new. RedoEffect new}.
	game := self newCardTestingGameWith: deck.
	self 
		should: [ game
				play: (Card with: RedoEffect new)
				for: player1
				on: game players ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cannot play redo card as there are no active played cards on the pile'
]

{ #category : #'tests - instant' }
CardTest >> testRepeatCardCannotBePlayedIfDicesNeverRolled [
	| game cardToPlay |
	game := self newCardTestingGameFor: RepeatEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	self
		should: [ game play: cardToPlay for: player1 on: {player2} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cant play repeat card on a player that hasnt triggered an effect yet'
]

{ #category : #'tests - instant' }
CardTest >> testRepeatCardRepeatesTheEffectOfTheSpotReachedAfterRollingDices [
	| game cardToPlay board deck |
	deck := Deck with: {RepeatEffect new}.
	board := testResource
		spotTestingBoardWithSpots: 5
		and: (RegularSpot with: SpeedUpEffect new)
		at: 2
		throwing: {(SequentialDice withSequence: {1})}.
	game := self newCardTestingGameWith: deck on: board.
	cardToPlay := (game cardsInHandOf: player1) first.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 1.
	self assert: (game lapOf: player1) equals: 1.
	game play: cardToPlay for: player1 on: {player1}.
	self assert: (game positionOf: player1) equals: 5.
	self assert: (game lapOf: player1) equals: 1
]

{ #category : #'tests - permanent' }
CardTest >> testSpeedEffectIncreasesByOneTheRollResulOfOnlyOnePlayerAndIsAcumulative [
	| game cardToPlay |
	game := self newCardTestingGameFor: SpeedEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: {player1}.
	game throwDicesFor: player1.
	cardToPlay := (game cardsInHandOf: player2) first.
	game play: cardToPlay for: player2 on: {player1}.
	game throwDicesFor: player2.
	game throwDicesFor: player1.
	self assert: (game positionOf: player1) equals: 6.
	self assert: (game positionOf: player2) equals: 2
]

{ #category : #'tests - permanent' }
CardTest >> testSpeedEffectIncreasesByOneTheRollResultOfOnlyOnePlayer [
	| game cardToPlay |
	game := self newCardTestingGameFor: SpeedEffect new.
	cardToPlay := (game cardsInHandOf: player1) first.
	game play: cardToPlay for: player1 on: {player1}.
	game throwDicesFor: player1.
	game throwDicesFor: player2.
	self assert: (game positionOf: player1) equals: 3.
	self assert: (game positionOf: player2) equals: 2
]

{ #category : #tests }
CardTest >> testTwoIdenticalCardsYieldSameHash [
	| card1 card2 |
	card1 := Card with: AccelerationEffect new.
	card2 := Card with: AccelerationEffect new.
	self assert: card1 equals: card2.
	self assert: card1 hash equals: card2 hash
]

{ #category : #tests }
CardTest >> testTwoIdenticalPlayedCardsYieldSameHash [
	| card1 card2 |
	card1 := PlayedCard of: AccelerationEffect new to: testResource standardSetOfPlayers.
	card2 := PlayedCard of: AccelerationEffect new to: testResource standardSetOfPlayers.
	self assert: card1 equals: card2.
	self assert: card1 hash equals: card2 hash
]
