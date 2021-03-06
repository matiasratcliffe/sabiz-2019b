"
This class contains tests about player state
"
Class {
	#name : #PositionTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
PositionTest >> testCantCreateAPositionWithAnInvalidSpotNumber [
	self
		should: [ Position on: 0 and: 1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The spot number must be a positive integer'.
	self
		should: [ Position on: -1 and: 1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The spot number must be a positive integer'
]

{ #category : #tests }
PositionTest >> testPositionHasGivenLapNumber [
	| position |
	position := Position on: 5 and: 2.
	self assert: position lapNumber equals: 2
]

{ #category : #tests }
PositionTest >> testPositionHasGivenSpotNumber [
	| position |
	position := Position on: 5 and: 2.
	self assert: position spotNumber equals: 5
]

{ #category : #tests }
PositionTest >> testPositionTurnsIntoExpectedDescriptiveString [
	self assert: (Position on: 1 and: 1) asString equals: '(1, 1)'
]
