"
This class represents an instant effect produced by playing a card
"
Class {
	#name : #RepeatEffect,
	#superclass : #CardInstantEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
RepeatEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	self assert: target size = 1 description: 'The repeat card can only be played on a single player'.
	self assert: (aGame playerHasNotFinished: target first) description: 'The repeat card cant be played on a player that has already finished'.
	aGame repeatLastEffectTriggeredBy: target first
]
