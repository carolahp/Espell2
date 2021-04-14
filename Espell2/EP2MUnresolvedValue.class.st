Class {
	#name : #EP2MUnresolvedValue,
	#superclass : #Object,
	#instVars : [
		'default'
	],
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2MUnresolvedValue >> default [
	^ default
]

{ #category : #accessing }
EP2MUnresolvedValue >> default: anObject [
	default := anObject
]

{ #category : #evaluating }
EP2MUnresolvedValue >> value [

	^ self default
]
