"
This class contains tests about boards
"
Class {
	#name : #BoardTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #'test support' }
BoardTest >> allSpotTypes [
	^ (SpotEffect allSubclasses collect: [ :each | RegularSpot with: each new ])
		asArray
]

{ #category : #'test - accessing' }
BoardTest >> testBoardHasGivenNumberOfLaps [
	| board |
	board := Board with: {RegularSpot with: NullEffect new} andLaps: 2 throwing: {RandomDice withFaces: 4}.
	self assert: board numberOfLaps equals: 2
]

{ #category : #'test - accessing' }
BoardTest >> testBoardHasGivenNumberOfSpots [
	| board |
	board := testResource standardBoardWithSpots: 20.
	self assert: board numberOfSpots equals: 20
]

{ #category : #'test - accessing' }
BoardTest >> testBoardHasGivenSetOfDices [
	| board dice1 dice2 |
	dice1 := RandomDice withFaces: 6.
	dice2 := SequentialDice withSequence: {4}.
	board := testResource effectlessBoardWithSpots: 10 throwing: { dice1. dice2 }.
	self assert: (board dices includesAll: {dice1. dice2})
]

{ #category : #'tests - instance creation' }
BoardTest >> testCantCreateBoardWithoutDices [
	self
		should: [ testResource effectlessBoardWithSpots: 10 throwing: {  } ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Tried to create a board with an invalid set of Dices'
]

{ #category : #'tests - instance creation' }
BoardTest >> testCreatingACustomBoardRequiresCollectionOfSpotsToUse [
	self
		should: [ Board with: {} andLaps: 2 throwing: {RandomDice withFaces: 4}]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Invalid number of spots'
]

{ #category : #'test - accessing' }
BoardTest >> testCustomBoardHasGivenEffectsInTheCorrespondingPosition [
	| board spots |
	spots := self allSpotTypes.
	board := Board with: spots andLaps: 2 throwing: {RandomDice withFaces: 4}.
	spots
		withIndexDo: [ :spot :index | self assert: (board effectAt: index) equals: spot effect ]
]

{ #category : #'test - accessing' }
BoardTest >> testEffectTestingBoardHasGivenEffectAtDesiredPositionAndNoEffectsElsewhere [
	| effect board |
	effect := MoonWalkEffect new.
	board := testResource
		effectTestingBoardWithSpots: testResource standardNumberOfSpots
		and: effect
		at: 1
		throwing: {RandomDice withFaces: 4}.
	1 to: board numberOfSpots do: [ :index | 
		index == 1
			ifTrue: [ self assert: (board effectAt: index) equals: effect ]
			ifFalse: [ self assert: (board effectAt: index) class equals: NullEffect ] ]
]

{ #category : #'tests - instance creation' }
BoardTest >> testProhibitsCreatingBoardWithInvalidNumberOfLaps [
	self
<<<<<<< HEAD
		should: [ Board with: {(RegularSpot with: NullEffect new)} andLaps: 0 throwing: {RandomDice withFaces: 4} ]
		raise: AssertionFailure	
		whoseDescriptionIncludes: 'Invalid number of laps';
		should: [ Board with: {(RegularSpot with: NullEffect new)} andLaps: -1 throwing: {RandomDice withFaces: 4} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Invalid number of laps'
]

{ #category : #'tests - instance creation' }
BoardTest >> testProhibitsCreatingBoardWithInvalidNumberOfSpots [
	self
		should: [ testResource standardBoardWithSpots: 0 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Invalid number of spots';
		should: [ testResource standardBoardWithSpots: -1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Invalid number of spots'
]
