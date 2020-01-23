"
This class models a jail spot
"
Class {
	#name : #JailSpot,
	#superclass : #Spot,
	#category : #'IngSoft2-Model'
}

{ #category : #printing }
JailSpot >> effect [
	^ NullEffect new
]

{ #category : #printing }
JailSpot >> printOn: aStream [
	self className printOn: aStream
]
