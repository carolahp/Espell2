Class {
	#name : #EP2MSlot,
	#superclass : #EP2MObject,
	#instVars : [
		'owningClass',
		'definingClass'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #writing }
EP2MSlot >> accept: anInterpreter assign: aValue inNode: aVariableNode [
	^ anInterpreter write: aValue at: self index named: self name
]

{ #category : #converting }
EP2MSlot >> asEP2Slot [
	^ self
]

{ #category : #accessing }
EP2MSlot >> backend [
	^ definingClass backend
]

{ #category : #accessing }
EP2MSlot >> definingClass: anEP2RemoteClass [ 

	definingClass := anEP2RemoteClass
]

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

{ #category : #testing }
EP2MSlot >> printOn: aStream [
	self subclassResponsibility 
]

{ #category : #'read-write' }
EP2MSlot >> read: anEP2RemoteAssociation [ 
	self subclassResponsibility 
]

{ #category : #reading }
EP2MSlot >> readWith: anEPASTInterpreter inNode: aRBInstanceVariableNode [ 
	self error: 'only for InstanceVariableSlots'
]

{ #category : #testing }
EP2MSlot >> slotName [ 
	self subclassResponsibility 
]

{ #category : #testing }
EP2MSlot >> write: aValue to: anObject [
	^self subclassResponsibility
]
