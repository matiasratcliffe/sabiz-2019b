"
This class generates standard elements with a specific set of characteristics that are going to be needed in order to test each aspect of the model
"
Class {
	#name : #StandardModelTestResource,
	#superclass : #TestResource,
	#category : #'IngSoft2-Tests'
}

{ #category : #boardCreation }
StandardModelTestResource >> effectTestingBoardWithSpots: spotsNumber and: effect at: spotNumber throwing: dices [
	| spots |
	spots := OrderedCollection
		new: spotsNumber
		withAll: (RegularSpot with: NullEffect new).
	spots at: spotNumber put: (RegularSpot with: effect).
	^ Board
		with: spots
		andLaps: self standardNumberOfLaps
		throwing: dices
]

{ #category : #boardCreation }
StandardModelTestResource >> effectlessBoardWithDiceLoadedWithSpotsNumberAndSpots: spotsNumber [
	^ Board
		with:
			(OrderedCollection
				new: spotsNumber
				withAll: (RegularSpot with: NullEffect new))
		andLaps: 1
		throwing: {SequentialDice withSequence: {spotsNumber}}
]

{ #category : #boardCreation }
StandardModelTestResource >> effectlessBoardWithSpots: spotsNumber throwing: dices [
	^ Board
		with:
			(OrderedCollection
				new: spotsNumber
				withAll: (RegularSpot with: NullEffect new))
		andLaps: 1
		throwing: dices
]

{ #category : #gameCreation }
StandardModelTestResource >> simplisticTestingGame [
	| board |
	board := self effectlessBoardWithSpots: 10 throwing: { SequentialDice withSequence: { 4 } }.
	^ Game
		playedBy: {Player named: #Player1 . Player named: #Player2}
		on: board
		using: (GimmickDeck withSequence: {Card with: AccelerationEffect new})
]

{ #category : #boardCreation }
StandardModelTestResource >> standardBoard [
	^ self standardBoardWithSpots: self standardNumberOfSpots
]

{ #category : #boardCreation }
StandardModelTestResource >> standardBoardWithSpots: spots [
	^ Board
		with: self standardSpotDistribution
		andSpots: spots
		andLaps: self standardNumberOfLaps
		throwing: self standardSetOfDices
]

{ #category : #standardValues }
StandardModelTestResource >> standardDeckOfCards [
	| cardTypes |
	cardTypes := OrderedCollection new.
	cardTypes
		addAll: (CardInstantEffect subclasses collect: [ :each | each new ]).
	cardTypes
		addAll: (CardPermanentEffect subclasses collect: [ :each | each new ]).
	^ Deck with: cardTypes asArray
]

{ #category : #gameCreation }
StandardModelTestResource >> standardGame [
	^ Game
		playedBy: self standardSetOfPlayers
		on: self standardBoard
		using: self standardDeckOfCards
]

{ #category : #standardValues }
StandardModelTestResource >> standardNumberOfLaps [
	^ 2
]

{ #category : #standardValues }
StandardModelTestResource >> standardNumberOfSpots [
	^ 10
]

{ #category : #standardValues }
StandardModelTestResource >> standardSetOfDices [
	^ {(RandomDice withFaces: 6)}
]

{ #category : #standardValues }
StandardModelTestResource >> standardSetOfPlayers [
	^ {(Player named: #Player1).
	(Player named: #Player2).
	(Player named: #Player3)}
]

{ #category : #standardValues }
StandardModelTestResource >> standardSpotDistribution [
	^ OverallOccurrenceDistribution
		with:
			{(IndividualOccurrenceProbability
				of: (RegularSpot with: AtomicBombEffect new)
				withProbability: 2).
			(IndividualOccurrenceProbability
				of: (RegularSpot with: NullEffect new)
				withProbability: 45).
			(IndividualOccurrenceProbability
				of: (RegularSpot with: MoonWalkEffect new)
				withProbability: 5).
			(IndividualOccurrenceProbability
				of: (RegularSpot with: SpeedUpEffect new)
				withProbability: 15).
			(IndividualOccurrenceProbability
				of: (RegularSpot with: TimeMachineEffect new)
				withProbability: 8).
			(IndividualOccurrenceProbability
				of: (RegularSpot with: WormHoleEffect new)
				withProbability: 15).
			(IndividualOccurrenceProbability
				of: (RegularSpot with: CardGivingEffect new)
				withProbability: 10)}
]
