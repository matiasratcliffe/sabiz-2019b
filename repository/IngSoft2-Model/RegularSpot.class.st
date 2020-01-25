"
This class models a spot on a borad, and can have an effect
"
Class {
	#name : #RegularSpot,
	#superclass : #Spot,
	#instVars : [
		'effect'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
RegularSpot class >> with: anEffect [
	^ self new initializeWith: anEffect
]

{ #category : #accessing }
RegularSpot >> effect [
	^ effect
]

{ #category : #movement }
RegularSpot >> getRollMultiplierRolling: rollSum with: Dices [
	^ 1
]

{ #category : #'instance creation' }
RegularSpot >> initializeWith: anEffect [
	effect := anEffect
]

{ #category : #printing }
RegularSpot >> printOn: aStream [
	aStream
		nextPutAll: (effect asString readStream upToAll: 'Effect');
		nextPutAll: 'Spot'
]
