"
This effect adds one to every rollSum
"
Class {
	#name : #AccelerationEffect,
	#superclass : #CardPermanentEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
AccelerationEffect >> applyEffectOn: players on: aGame triggeredBy: aPlayer [
	self checkTurnOf: aPlayer in: aGame.
	aGame addEffectOfCard: (Card newWith: self)
]

{ #category : #evaluating }
AccelerationEffect >> value [
	^ 1
]