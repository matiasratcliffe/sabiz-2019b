"
This class models cards that can be held and played
"
Class {
	#name : #Card,
	#superclass : #Object,
	#instVars : [
		'effect'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Card class >> with: anEffect [
	^ self new initializeWith: anEffect
]

{ #category : #comparing }
Card >> = aCard [
	^ aCard class = self class and: [self effect class = aCard effect class]
]

{ #category : #effect }
Card >> applyEffectOn: players on: aGame triggeredBy: aPlayer [
	effect applyOn: players on: aGame triggeredBy: aPlayer
]

{ #category : #accessing }
Card >> effect [
	^ effect
]

{ #category : #comparing }
Card >> hash [
	^ self effect className hash
]

{ #category : #initialization }
Card >> initializeWith: anEffect [
	effect := anEffect
]

{ #category : #printing }
Card >> printOn: aStream [
	aStream
		nextPutAll: (effect asString readStream upToAll: 'Effect');
		nextPutAll: 'Card'
]
