"
A game
"
Class {
	#name : #Game,
	#superclass : #Object,
	#instVars : [
		'leaderBoard',
		'board',
		'playersStates',
		'playedCards',
		'deck',
		'turnAllocator',
		'triggeredEffects'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #validation }
Game class >> checkDuplicatePlayers: players [
	self
		assert: players asSet size = players size
		description: 'The player set contains a duplicate'
]

{ #category : #validation }
Game class >> checkPlayerQuantity: players [
	self
		assert: players isNotEmpty
		description: 'Cant create a game with no players'
]

{ #category : #'instance creation' }
Game class >> playedBy: players on: aBoard using: aDeck [
	self checkDuplicatePlayers: players.
	self checkPlayerQuantity: players.
	^ self new
		initializeWith: players
		on: aBoard
		using: aDeck
]

{ #category : #'private - cardEffects' }
Game >> addPlayedCard: card to: target by: player [
	| newState newHand |
	playedCards add: (PlayedCard of: card effect to: target).
	newHand := self cardsInHandOf: player.
	newHand remove: card.
	newState := PlayerState
		on: (self positionOf: player)
		and: (self lapOf: player)
		and: turnAllocator currentRoundNumber
		holding: newHand.
	self updateStateFor: player with: newState
]

{ #category : #'private - spotEffects' }
Game >> apply: effect for: player [
	| effectsTriggeredByPlayer |
	effectsTriggeredByPlayer := triggeredEffects at: player.
	effectsTriggeredByPlayer add: effect.
	effect applyOn: self triggeredBy: player
]

{ #category : #'private - cardEffects' }
Game >> bailOut: player [
	| newState |
	self assert: (self isInJail: player) description: 'You can only bail out a jailed player'.
	newState := board
		nextStateFor: (self stateOf: player)
		afterMoving: 1
		onRoundNumber: turnAllocator currentRoundNumber.
	self updateStateFor: player with: newState
]

{ #category : #accessingPlayer }
Game >> cardsInHandOf: player [
	^ (self stateOf: player) cardsInHand
]

{ #category : #accessingGameState }
Game >> currentRanking [
	^ (self playersCurrentStates
		sort: [ :assoc1 :assoc2 | assoc1 value position > assoc2 value position ])
		collect: [ :assoc | assoc key ]
]

{ #category : #'private - spotEffects' }
Game >> dealCardTo: player [
	| newState hand |
	hand := self cardsInHandOf: player.
	hand add: deck nextCard.
	newState := PlayerState
		on: (self positionOf: player)
		and: (self lapOf: player)
		and: (self stateOf: player) roundNumber
		holding: hand.
	self updateStateFor: player with: newState
]

{ #category : #accessingGame }
Game >> deck [
	^ deck
]

{ #category : #'private - spotEffects' }
Game >> displace: player by: anAmount [
	| newState |
	self assert: (self isFree: player) description: 'Cannot change the position of an imprisoned player'.
	newState := board
		nextStateFor: (self stateOf: player)
		afterMoving: anAmount
		onRoundNumber: turnAllocator currentRoundNumber.
	self updateStateFor: player with: newState
]

{ #category : #'private - cardEffects' }
Game >> effectsOn: player [
	| cardsTargetingPlayer |
	cardsTargetingPlayer := (playedCards
		select: [ :each | each target includes: player ])
		collect: [ :each | each effect value ].
	cardsTargetingPlayer isNotEmpty
		ifTrue: [ ^ cardsTargetingPlayer sum ].
	^ 0
]

{ #category : #accessingGameState }
Game >> finishRanking [
	^ leaderBoard finishRanking
]

{ #category : #accessingPlayer }
Game >> historyOf: player [
	^ (playersStates at: player) copy
]

{ #category : #initialization }
Game >> initializeWith: gamePlayers on: aBoard using: aDeck [
	leaderBoard := LeaderBoard new.
	board := aBoard copy.
	deck := aDeck.
	turnAllocator := TurnAllocator for: gamePlayers.
	playedCards := OrderedCollection new.
	playersStates := (gamePlayers
		collect: [ :each | 
			Association
				key: each
				value:
					{(PlayerState
						on: 1
						and: 0
						holding: {deck nextCard. deck nextCard})
				} asOrderedCollection ]) asOrderedDictionary.
	triggeredEffects := (gamePlayers
		collect: [ :each | 
			Association
				key: each
				value: OrderedCollection new
			]) asOrderedDictionary
]

{ #category : #accessingPlayer }
Game >> isFree: player [
	^ (self isInJail: player) not
]

{ #category : #accessingPlayer }
Game >> isInJail: player [
	^ board isThereAJailAt: (self positionOf: player)
]

{ #category : #accessingGameState }
Game >> isNotOver [
	^ (leaderBoard includesAll: self players) not
]

{ #category : #accessingGameState }
Game >> isOver [
	^ self isNotOver not
]

{ #category : #accessingGame }
Game >> isPlayedBy: player [
	^ self players includes: player
]

{ #category : #accessingPlayer }
Game >> lapOf: player [
	^ (self stateOf: player) lapNumber
]

{ #category : #'private - moving' }
Game >> makeMoveFor: player [
	| newState |
	newState := board
		nextStateFor: (self stateOf: player)
		under: (self effectsOn: player)
		onRoundNumber: turnAllocator currentRoundNumber.
	self updateStateFor: player with: newState.
	self player: player triggersEffectAt: newState spotNumber. 
	((self playerHasFinished: player)
		and: (leaderBoard doesNotInclude: player))
		ifTrue: [ leaderBoard add: player ]
]

{ #category : #'private - spotEffects' }
Game >> moveEveryoneToTheFirstSpot [
	self playersStillPlaying
		do: [ :each | 
			(self isInJail: each)
				ifFalse: [ self
						updateStateFor: each
						with:
							(PlayerState
								on: 1
								and: (self lapOf: each)
								and: turnAllocator currentRoundNumber
								holding: (self cardsInHandOf: each)) ] ]
]

{ #category : #accessingGame }
Game >> numberOfPlayers [
	^ self players size
]

{ #category : #playing }
Game >> play: card for: player on: target [
	self
		assert: (self playerHasNotFinished: player)
		description: 'Trying to play a card for a player that has already finished'.
	(self stateOf: player) checkAvailabilityOf: card.
	card applyEffectOn: target on: self triggeredBy: player
]

{ #category : #'private - spotEffects' }
Game >> player: player triggersEffectAt: spotNumber [
	| effect |
	effect := board effectAt: spotNumber.
	self apply: effect for: player
]

{ #category : #'private - spotEffects' }
Game >> player: player triggersMoonWalkEffectMoving: anAmount [
	self playersStillPlaying
		do: [ :each | 
			| newState |
			(each = player or: (self isInJail: each))
				ifFalse: [ newState := board
						nextStateFor: (self stateOf: each)
						afterMoving: anAmount
						onRoundNumber: turnAllocator currentRoundNumber.
					self updateStateFor: each with: newState ] ]
]

{ #category : #accessingGameState }
Game >> playerHasFinished: player [
	^ (self playerHasNotFinished: player) not
]

{ #category : #accessingGameState }
Game >> playerHasNotFinished: player [
	^ (self lapOf: player) < board numberOfLaps
]

{ #category : #accessingGameState }
Game >> playerWhoseTurnItIsToPlay [
	^ turnAllocator playerWhoseTurnItIsToPlay
]

{ #category : #accessingGame }
Game >> players [
	^ playersStates keys copy
]

{ #category : #accessingGameState }
Game >> playersCurrentStates [
	^ (self players
		collect: [ :player | Association key: player value: (self stateOf: player) ])
		asArray
]

{ #category : #accessingGameState }
Game >> playersStillPlaying [
	^ self players select: [ :each | self playerHasNotFinished: each ]
]

{ #category : #accessingPlayer }
Game >> positionOf: player [
	^ (self stateOf: player) spotNumber
]

{ #category : #'private - cardEffects' }
Game >> removePlayedCard: playedCard [
	playedCards
		remove: playedCard
		ifAbsent: [ AssertionFailure
				signal:
					'Tried to remove a non existent played card (check that both the effect and the target are in order)' ]
]

{ #category : #'private - spotEffects' }
Game >> repeatLastEffectTriggeredBy: player [
	| effectsTriggeredByPlayer effect |
	effectsTriggeredByPlayer := triggeredEffects at: player.
	self
		assert: effectsTriggeredByPlayer isNotEmpty
		description: 'Cant play repeat card on a player that hasnt triggered an effect yet'.
	"Steping on a null effect still counts as triggering an effect"
	effect := effectsTriggeredByPlayer last.
	self apply: effect for: player
]

{ #category : #'private - cardEffects' }
Game >> replayLastCardOn: target for: player [
	| hand card |
	self assert: playedCards isNotEmpty description: 'Cannot play redo card as there are no active played cards on the pile'.
	card := Card with: playedCards last effect.
	hand := self cardsInHandOf: player.
	hand add: card.
	self updateStateFor: player
		with:
			(PlayerState
				on: (self positionOf: player)
				and: (self lapOf: player)
				and: turnAllocator currentRoundNumber
				holding: hand).
	self play: card for: player on: target
]

{ #category : #'private - spotEffects' }
Game >> rewindPositionFor: player [
	| targetState round |
	self assert: (self isFree: player) description: 'Cannot rewind the position of an imprisoned player'.
	round := (self stateOf: player) roundNumber.
	targetState := (self historyOf: player)
		select: [ :each | each roundNumber = (round - 1) ].
	targetState isNotEmpty
		ifTrue: [ targetState := targetState first ]
		ifFalse: [ ^ self ].
	self
		updateStateFor: player
		with:
			(PlayerState
				on: targetState spotNumber
				and: targetState lapNumber
				and: targetState roundNumber
				holding: targetState cardsInHand)
]

{ #category : #accessingGameState }
Game >> roundNumber [
	^ turnAllocator currentRoundNumber
]

{ #category : #accessingPlayer }
Game >> stateOf: player [
	^ (playersStates
		at: player
		ifAbsent: [ AssertionFailure
				signal: 'Asked for a player that is not in the game' ]) last copy
]

{ #category : #playing }
Game >> throwDicesFor: player [
	self
		assert: (self playerHasNotFinished: player)
		description: 'Trying to move a player that has already finished'.
	self
		assert: turnAllocator playerWhoseTurnItIsToPlay = player
		description: 'Trying to move a player out of turn'.
	self
		updateStateFor: player
		with:
			(PlayerState
				on: (self positionOf: player)
				and: (self lapOf: player)
				and: turnAllocator currentRoundNumber
				holding: (self cardsInHandOf: player)).
	self makeMoveFor: player.
	(self playerHasFinished: player)
		ifTrue: [ turnAllocator playerHasFinished: player ]
		ifFalse: [ turnAllocator advanceTurnWheel ]
]

{ #category : #'private - updating' }
Game >> updateStateFor: player with: aState [
	| playerStates |
	aState = (self stateOf: player) ifTrue: [ ^ self ].
	playerStates := playersStates at: player.
	playerStates add: aState
]

{ #category : #accessingGameState }
Game >> winner [
	^ leaderBoard winner
]
