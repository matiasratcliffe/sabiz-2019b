"
This class contains information about the current state of a player, consisting of its position, the current round number, and the cards in hand at the moment
"
Class {
	#name : #PlayerState,
	#superclass : #Object,
	#instVars : [
		'position',
		'roundNumber',
		'cards'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
PlayerState class >> on: spotNumber and: lapNumber and: roundNumber holding: cards [
	^ self new
		on: (Position on: spotNumber and: lapNumber)
		and: roundNumber
		holding: cards asOrderedCollection
]

{ #category : #'instance creation' }
PlayerState class >> on: spotNumber and: lapNumber holding: cards [
	"Used to create the first state"
	^ self on: spotNumber and: lapNumber and: 0 holding: cards
]

{ #category : #comparing }
PlayerState >> = aPlayerState [
	^ aPlayerState class = self class and: [
			(self spotNumber = aPlayerState spotNumber and: 
			self lapNumber = aPlayerState lapNumber) and:
			(self roundNumber = aPlayerState roundNumber and:
			self cardsInHand = aPlayerState cardsInHand)
		]
]

{ #category : #accessing }
PlayerState >> cardsInHand [
	^ cards copy
]

{ #category : #validation }
PlayerState >> checkAvailabilityOf: aCard [
	self
		assert: (cards includes: aCard)
		description: 'That card is not in the hand of the player'
]

{ #category : #comparing }
PlayerState >> hash [
	^ (self spotNumber asString , self lapNumber asString
		, self roundNumber asString , self cardsInHand asString) hash
]

{ #category : #accessing }
PlayerState >> lapNumber [
	^ position lapNumber
]

{ #category : #initialization }
PlayerState >> on: currentPosition and: currentRoundNumber holding: heldCards [
	position := currentPosition.
	roundNumber := currentRoundNumber.
	cards := heldCards
]

{ #category : #accessing }
PlayerState >> position [
	^ position
]

{ #category : #printing }
PlayerState >> printOn: aStream [
	aStream nextPut: $(.
	self spotNumber printOn: aStream.
	aStream nextPutAll: ', '.
	self lapNumber printOn: aStream.
	aStream nextPutAll: ', '.
	self roundNumber printOn: aStream.
	aStream nextPutAll: ')('.
	self cardsInHand do: [ :each | 
		each printOn: aStream
	].
	aStream nextPut: $)
]

{ #category : #accessing }
PlayerState >> roundNumber [
	^ roundNumber
]

{ #category : #accessing }
PlayerState >> spotNumber [
	^ position spotNumber
]
