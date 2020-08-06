Class {
	#name : #EP2MSlot,
	#superclass : #EP2MObject,
	#instVars : [
		'owningClass',
		'definingClass'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #testing }
EP2MSlot >> isIndexedSlot [
	^ false
]

{ #category : #testing }
EP2MSlot >> isInstanceVariableSlot [
	^ false
]

{ #category : #testing }
EP2MSlot >> isSlot [

	^ true
]
