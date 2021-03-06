"
This class models a card permanent effects that can be applied to one or more players, and can be accumulated
"
Class {
	#name : #CardPermanentEffect,
	#superclass : #CardEffect,
	#category : #'IngSoft2-Model'
}

{ #category : #effect }
CardPermanentEffect >> applyOn: target on: aGame triggeredBy: aPlayer [
	self checkTurnOf: aPlayer in: aGame
]

{ #category : #validation }
CardPermanentEffect >> checkTurnOf: aPlayer in: aGame [
	self
		assert: aGame playerWhoseTurnItIsToPlay = aPlayer
		description: 'Cant play a permanent card out of turn'
]

{ #category : #accesing }
CardPermanentEffect >> value [
	self subclassResponsibility
]
