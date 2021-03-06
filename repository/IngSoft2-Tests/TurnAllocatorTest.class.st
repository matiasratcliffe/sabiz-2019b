"
Tests for TurnAllocator class
"
Class {
	#name : #TurnAllocatorTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
TurnAllocatorTest >> testCanOnlyRemoveAPlayerFromTurnAllocatorIfItsThatPlayersTurn [
	| allocator |
	allocator := TurnAllocator for: { player1. player2. player3 }.
	allocator playerHasFinished: player1.
	allocator advanceTurnWheel.
	self
		should: [ allocator playerHasFinished: player2 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cannot remove a player from the Turn Wheel unless its his turn'
]

{ #category : #tests }
TurnAllocatorTest >> testCantCreateTurnAllocatorWithEmptyCollection [
	self
		should: [ TurnAllocator for: {} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Cant create TurnAllocator for an empty group'
]

{ #category : #tests }
TurnAllocatorTest >> testItsThePreviousPlayersTurnUntilAdvancingTheTurnWheel [
	| turns |
	turns := TurnAllocator for: { player1. player2 }.
	self assert: turns playerWhoseTurnItIsToPlay equals: player1.
	self assert: turns playerWhoseTurnItIsToPlay equals: player1.
	turns advanceTurnWheel.
	self assert: turns playerWhoseTurnItIsToPlay equals: player2.
]

{ #category : #tests }
TurnAllocatorTest >> testRemovingAPlayerAutomaticallyAdvancesTurnWheel [
	| allocator |
	allocator := TurnAllocator for: { player1. player2. player3 }.
	allocator advanceTurnWheel.
	allocator playerHasFinished: player2.
	self assert: allocator playerWhoseTurnItIsToPlay equals: player3
]

{ #category : #tests }
TurnAllocatorTest >> testTurnAllocatorRespectsExpectedOrder [
	| turns |
	turns := TurnAllocator for: { player1. player2. player3 }.
	self assert: turns playerWhoseTurnItIsToPlay equals: player1.
	turns advanceTurnWheel.
	self assert: turns playerWhoseTurnItIsToPlay equals: player2.
	turns advanceTurnWheel.
	self assert: turns playerWhoseTurnItIsToPlay equals: player3.
	turns advanceTurnWheel.
	self assert: turns playerWhoseTurnItIsToPlay equals: player1
]

{ #category : #tests }
TurnAllocatorTest >> testTurnAllocatorReturnsNilWhenAskedForTheTurnOfAFinishedGame [
	| allocator |
	allocator := TurnAllocator for: { player1. player2 }.
	allocator playerHasFinished: player1.
	allocator playerHasFinished: player2.
	self assert: allocator playerWhoseTurnItIsToPlay equals: 	nil
]

{ #category : #tests }
TurnAllocatorTest >> testTurnAllocatorYieldsExpectedRoundNumber [
	| turns |
	turns := TurnAllocator for: { player1. player2. player3 }.
	self assert: turns currentRoundNumber equals: 1.
	turns advanceTurnWheel.
	self assert: turns currentRoundNumber equals: 1.
	turns advanceTurnWheel.
	self assert: turns currentRoundNumber equals: 1.
	turns advanceTurnWheel.
	self assert: turns currentRoundNumber equals: 2
]
