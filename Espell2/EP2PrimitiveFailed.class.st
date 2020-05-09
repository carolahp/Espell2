Class {
	#name : #EP2PrimitiveFailed,
	#superclass : #EP2PrimitiveResult,
	#instVars : [
		'code'
	],
	#category : #'Espell2-Primitives'
}

{ #category : #accessing }
EP2PrimitiveFailed >> code [
	^ code
]

{ #category : #accessing }
EP2PrimitiveFailed >> code: anObject [
	code := anObject
]

{ #category : #testing }
EP2PrimitiveFailed >> hasFailed [
	
	^ true
]
