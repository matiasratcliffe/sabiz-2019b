"
This class the probability of a specific effect
"
Class {
	#name : #IndividualOccurrenceProbability,
	#superclass : #Object,
	#instVars : [
		'probability',
		'element'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
IndividualOccurrenceProbability class >> checkValidityOf: probability [
	self
		assert: (probability >= 0 and: probability <= 100)
		description: 'The probability must be between 0 and 100'
]

{ #category : #'instance creation' }
IndividualOccurrenceProbability class >> of: element withProbability: probability [
	self checkValidityOf: probability.
	^ self new initializeWith: element andProbability: probability
]

{ #category : #accessing }
IndividualOccurrenceProbability >> element [
	^ element copy
]

{ #category : #initialization }
IndividualOccurrenceProbability >> initializeWith: anElement andProbability: aProbability [
	element := anElement.
	probability := aProbability
]

{ #category : #accessing }
IndividualOccurrenceProbability >> probability [
	^ probability copy
]
