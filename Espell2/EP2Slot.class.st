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

{ #category : #accessing }
EP2Slot >> definingClass: anEP2RemoteClass [ 
	definingRemoteClass := anEP2RemoteClass
]

{ #category : #testing }
EP2Slot >> isIndexedSlot [
	^ false
]

{ #category : #testing }
EP2Slot >> isInstanceVariableSlot [
	^ false
]

{ #category : #accessing }
EP2Slot >> name [
	^ name
]

{ #category : #accessing }
EP2Slot >> name: aString [
	name := aString
]

{ #category : #printing }
EP2Slot >> printOn: aStream [
	self subclassResponsibility 
]

{ #category : #'meta-object-protocol' }
EP2Slot >> read: anObject [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
EP2Slot >> slotName [ 
	self subclassResponsibility 
]

{ #category : #'meta-object-protocol' }
EP2Slot >> write: aValue to: anObject [
	^self subclassResponsibility
]
