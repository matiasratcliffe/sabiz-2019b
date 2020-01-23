"
This is a superclass to model spots
"
Class {
	#name : #Spot,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
Spot >> effect [
	self subclassResponsibility
]

{ #category : #movement }
Spot >> getRollMultiplierRolling: rollSum with: Dices [
	self subclassResponsibility
]
