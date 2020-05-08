Class {
	#name : #EP2Slot,
	#superclass : #Object,
	#instVars : [
		'name',
		'owningRemoteClass',
		'definingRemoteClass'
	],
	#category : #'Espell2-Kernel-Slots'
}

{ #category : #accessing }
EP2Slot >> backend [ 
	^ definingRemoteClass backend
]

{ #category : #testing }
EP2Slot >> isIndexedSlot [
	^ false
]

{ #category : #testing }
EP2Slot >> isInstanceVariableSlot [
	^ false
]

{ #category : #'meta-object-protocol' }
EP2Slot >> read: anObject [
	^ self subclassResponsibility
]

{ #category : #'meta-object-protocol' }
EP2Slot >> write: aValue to: anObject [
	^self subclassResponsibility
]
