"
This is a superclass for the tests in this model, containing the resources to be repeatedly used in multiple test subclasses
"
Class {
	#name : #StandardModelTest,
	#superclass : #TestCase,
	#instVars : [
		'player1',
		'player2',
		'player3',
		'testResource'
	],
	#category : #'IngSoft2-Tests'
}

{ #category : #running }
StandardModelTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	testResource := StandardModelTestResource new.
	player1 := Player named: #Player1.
	player2 := Player named: #Player2.
	player3 := Player named: #Player3
]

{ #category : #asserting }
StandardModelTest >> should: aBlock raise: anExceptionalEvent whoseDescriptionIncludes: subString [
	^ self
		should: aBlock
		raise: anExceptionalEvent
		whoseDescriptionIncludes: subString
		description: 'The description does not contain the expected substring'
]

{ #category : #testResourceTests }
StandardModelTest >> testTestResourceYieldsValidObjects [
	self assert: testResource standardGame class equals: Game.
	self assert: testResource simplisticTestingGame class equals: Game.
	self assert: testResource standardBoard class equals: Board.
	self assert: (testResource standardBoardWithSpots: 10) class equals: Board.
	self assert: (testResource effectlessRegularBoardWithDiceLoadedWithSpotsNumberAndSpots: 10) class equals: Board.
	self assert: (testResource effectlessRegularBoardWithSpots: 10 throwing: {RandomDice withFaces: 4}) class equals: Board.
	self assert: (testResource spotTestingBoardWithSpots: 10 and: (RegularSpot with: NullEffect new) at: 4 throwing: {RandomDice withFaces: 4}) class equals: Board
]
