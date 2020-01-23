"
Class that represents a game board with spots and a set of dices
"
Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'spots',
		'laps',
		'dices'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #validation }
Board class >> checkDices: dices [
	self
		assert: dices isNotEmpty
		description: 'Tried to create a board with an invalid set of Dices'
]

{ #category : #validation }
Board class >> checkNumberOfLaps: laps [
	self assert: laps > 0 description: 'Invalid number of laps'
]

{ #category : #validation }
Board class >> checkNumberOfSpots: spotsAmmount [
	self assert: spotsAmmount > 0 description: 'Invalid number of spots'
]

{ #category : #'instance creation' }
Board class >> with: spotCollection andLaps: laps throwing: dices [
	self checkNumberOfSpots: spotCollection size.
	self checkNumberOfLaps: laps.
	self checkDices: dices.
	^ self new
		initializeWith: spotCollection
		andLaps: laps
		throwing: dices
]

{ #category : #'instance creation' }
Board class >> with: effectDistribution andSpots: spotsAmount andLaps: laps throwing: dices [
	| spots |
	spots := OrderedCollection new.
	spotsAmount
		timesRepeat: [ spots add: (Spot with: effectDistribution random) ].
	^ Board with: spots andLaps: laps throwing: dices
]

{ #category : #accessing }
Board >> dices [
	^ dices copy
]

{ #category : #accessing }
Board >> effectAt: position [
	self assert: (position > 0 and: position <= self numberOfSpots).
	^ (spots at: position) effect
]

{ #category : #initialization }
Board >> initializeWith: spotsCollection andLaps: numberOfLaps throwing: setOfDices [
	spots := spotsCollection.
	dices := setOfDices.
	laps := numberOfLaps
]

{ #category : #'private - moving' }
Board >> nextStateFor: state afterMoving: rollSum onRoundNumber: roundNumber [
	| newLapNumber netNewPosition grossNewPosition |
	grossNewPosition := state spotNumber + rollSum.
	newLapNumber := state lapNumber
		+ (grossNewPosition // self numberOfSpots).
	netNewPosition := grossNewPosition % self numberOfSpots.
	netNewPosition isZero
		ifTrue: [ netNewPosition := self numberOfSpots.
			newLapNumber := newLapNumber - 1 ].
	^ PlayerState
		on: netNewPosition
		and: newLapNumber
		and: roundNumber
		holding: state cardsInHand
]

{ #category : #'private - moving' }
Board >> nextStateFor: state under: effectsDisplacementSumForPlayer onRoundNumber: roundNumber [
	| totalDisplacement |
	"aca checkear lo de jail"
	totalDisplacement := effectsDisplacementSumForPlayer + self rollSum.
	^ self nextStateFor: state afterMoving: totalDisplacement onRoundNumber: roundNumber
]

{ #category : #accessing }
Board >> numberOfLaps [
	^ laps
]

{ #category : #accessing }
Board >> numberOfSpots [
	^ spots size
]

{ #category : #'private - moving' }
Board >> rollSum [
	^ dices inject: 0 into: [ :sum :dice | sum + dice roll ]
]
