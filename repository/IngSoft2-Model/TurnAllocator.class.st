"
This class represents the turn handler of the game. It can give the game the information about which player has to play next
"
Class {
	#name : #TurnAllocator,
	#superclass : #Object,
	#instVars : [
		'turnWheel',
		'currentTurn',
		'currentRound',
		'currentIndex'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
TurnAllocator class >> for: participants [
	self
		assert: participants isNotEmpty
		description: 'Cant create TurnAllocator for an empty group'.
	^ self new initializeFor: participants
]

{ #category : #advancing }
TurnAllocator >> advanceTurnWheel [
	currentIndex = (turnWheel size - 1)
		ifTrue: [ currentRound := currentRound + 1 ].
	turnWheel isNotEmpty
		ifTrue: [ currentIndex := (currentIndex + 1) % turnWheel size ]
]

{ #category : #'private - validation' }
TurnAllocator >> checkPresenceOf: player [
	self
		assert: (turnWheel includes: player)
		description: 'Tried to remove a player that is not in the Turn Wheel'
]

{ #category : #accessing }
TurnAllocator >> currentRoundNumber [
	^ currentRound
]

{ #category : #initialization }
TurnAllocator >> initializeFor: participants [
	turnWheel := participants asOrderedCollection copy.
	currentIndex := 0.
	currentRound := 1
]

{ #category : #alteringWheel }
TurnAllocator >> playerHasFinished: player [
	"This also performs the turnWheel advance indirectly"

	| index |
	self checkPresenceOf: player.
	index := (turnWheel indexOf: player) - 1.
	self
		assert: index = currentIndex
		description: 'Cannot remove a player from the Turn Wheel unless its his turn'.
	turnWheel remove: player.
	currentIndex = turnWheel size
		ifTrue: [ currentIndex := 0.
			currentRound := currentRound + 1 ]
]

{ #category : #accessing }
TurnAllocator >> playerWhoseTurnItIsToPlay [
	turnWheel isEmpty ifTrue: [ ^ nil ].
	^ turnWheel at: currentIndex + 1
]
