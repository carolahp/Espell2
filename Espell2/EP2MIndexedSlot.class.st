Class {
	#name : #EP2MIndexedSlot,
	#superclass : #EP2MSlot,
	#instVars : [
		'index'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #accessing }
EP2MIndexedSlot >> index [
	^ index
]

{ #category : #accessing }
EP2MIndexedSlot >> index: anInteger [ 
	index := anInteger
]

{ #category : #testing }
EP2MIndexedSlot >> isIndexedSlot [
	^ false
]
