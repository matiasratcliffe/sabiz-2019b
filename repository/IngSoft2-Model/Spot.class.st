"
This class represents a spot on a board
"
Class {
	#name : #Spot,
	#superclass : #Object,
	#instVars : [
		'effect'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Spot class >> with: anEffect [
	^ self new initializeWith: anEffect
]

{ #category : #accessing }
Spot >> effect [
	^ effect
]

{ #category : #'instance creation' }
Spot >> initializeWith: anEffect [
	effect := anEffect
]

{ #category : #printing }
Spot >> printOn: aStream [
	aStream
		nextPutAll: (effect asString readStream upToAll: 'Effect');
		nextPutAll: 'Spot'
]
