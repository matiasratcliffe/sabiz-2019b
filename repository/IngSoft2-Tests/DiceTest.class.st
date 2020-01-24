"
This class contains tests about dices
"
Class {
	#name : #DiceTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #sequentialDiceTests }
DiceTest >> testCantCreateSequentialDiceWithEmptySequence [
	self
		should: [ SequentialDice withSequence: {} ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Tried to create a sequence dice with an empty sequence'
]

{ #category : #randomDiceTests }
DiceTest >> testRandomDiceCreationFailsWhenGivenNumberOfFacesIsLessThanFour [
	self
		should: [ RandomDice withFaces: 2 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'Number of Faces should be greater than three'
]

{ #category : #randomDiceTests }
DiceTest >> testRandomDiceRollsValidNumber [
	| dice faces result |
	faces := 6.
	dice := RandomDice withFaces: faces.
	result := dice roll.
	self assert: (result > 0 and: result <= faces)
]

{ #category : #randomDiceTests }
DiceTest >> testRandomDiceYieldsCorrectMaximumValue [
	| dice |
	dice := RandomDice withFaces: 6.
	self assert: dice maximumValue equals: 6.
]

{ #category : #sequentialDiceTests }
DiceTest >> testSequentialDiceRollsExpectedSequence [
	| dice rolledSequence |
	rolledSequence := OrderedCollection new.
	dice := SequentialDice withSequence: {1 . 2 . 3}.
	4 timesRepeat: [ rolledSequence add: dice roll ].
	self assert: rolledSequence asArray equals: {1 . 2 . 3 . 1}
]

{ #category : #sequentialDiceTests }
DiceTest >> testSequentialDiceYieldsCorrectMaximumValue [
	| dice |
	dice := SequentialDice withSequence: {1. 4. 6. 3}.
	self assert: dice maximumValue equals: 6.
]
