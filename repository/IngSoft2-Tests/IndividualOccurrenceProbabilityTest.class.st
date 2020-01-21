"
This class contains tests about individual spot distributions
"
Class {
	#name : #IndividualOccurrenceProbabilityTest,
	#superclass : #StandardModelTest,
	#category : #'IngSoft2-Tests'
}

{ #category : #tests }
IndividualOccurrenceProbabilityTest >> testCantCreateDistributionWithNegativeProbabilityValue [
	self
		should: [ IndividualOccurrenceProbability of: NullEffect withProbability: -1 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The probability must be between 0 and 100'
]

{ #category : #tests }
IndividualOccurrenceProbabilityTest >> testCantCreateDistributionWithProbabilityValueOverAHundred [
	self
		should: [ IndividualOccurrenceProbability of: NullEffect withProbability: 101 ]
		raise: AssertionFailure
		whoseDescriptionIncludes: 'The probability must be between 0 and 100'
]
