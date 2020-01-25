"
Frees a player from jail
"
Class {
	#name : #FreedomEffect,
	#superclass : #CardInstantEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
FreedomEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	self assert: target size = 1 description: 'The freedom card can only be played on a single player'.
	self assert: (aGame isInJail: target first) description: 'The freedom card can only be played on a jailed player'.
	aGame displace: aPlayer by: 1
]
