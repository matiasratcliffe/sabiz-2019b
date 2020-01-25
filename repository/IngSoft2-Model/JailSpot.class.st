"
This class models a jail spot
"
Class {
	#name : #JailSpot,
	#superclass : #Spot,
	#category : #'IngSoft2-Model'
}

{ #category : #printing }
JailSpot >> effect [
	^ NullEffect new
]

{ #category : #movement }
JailSpot >> getRollMultiplierRolling: rollSum with: dices [
	| maximumValue |
	maximumValue := (dices collect: [ :each | each maximumValue ]) sum.
	rollSum = maximumValue
		ifTrue: [ ^ 1 ].
	^ 0
]
