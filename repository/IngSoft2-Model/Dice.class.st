"
A Dice superclass
"
Class {
	#name : #Dice,
	#superclass : #Object,
	#category : #'IngSoft2-Model'
}

{ #category : #accessing }
Dice >> maximumValue [
	self subclassResponsibility
]

{ #category : #roll }
Dice >> roll [
	self subclassResponsibility
]
