Class {
	#name : #EP2MInstanceVariableSlot,
	#superclass : #EP2MIndexedSlot,
	#category : #'Espell2-Metamodel'
}

{ #category : #testing }
EP2MInstanceVariableSlot >> isInstanceVariableSlot [
	^ true
]

{ #category : #'read-write' }
EP2MInstanceVariableSlot >> printOn: aStream [
	aStream nextPutAll: name ,' => ', self slotName
]

{ #category : #'read-write' }
EP2MInstanceVariableSlot >> read: aRemoteObject [
	^ (self backend object: aRemoteObject instVarAt: index) asRemoteObject
]

{ #category : #'read-write' }
EP2MInstanceVariableSlot >> slotName [ 
	^ 'InstVarSlot'
]

{ #category : #'read-write' }
EP2MInstanceVariableSlot >> write: aRemoteValue to: aRemoteObject [
	self backend 
		object: aRemoteObject
		instVarAt: index 
		put: aRemoteValue
]
