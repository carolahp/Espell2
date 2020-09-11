Class {
	#name : #EP2MInstanceVariableSlot,
	#superclass : #EP2MIndexedSlot,
	#category : #'Espell2-Metamodel'
}

{ #category : #'as yet unclassified' }
EP2MInstanceVariableSlot >> emitStore: methodBuilder [

	methodBuilder storeInstVar: self index
]

{ #category : #emiting }
EP2MInstanceVariableSlot >> emitValue: methodBuilder [ 
	methodBuilder pushInstVar: self index.

]

{ #category : #testing }
EP2MInstanceVariableSlot >> isInstanceVariableSlot [
	^ true
]

{ #category : #'read-write' }
EP2MInstanceVariableSlot >> printOn: aStream [
	aStream nextPutAll: objectName ,' => ', self slotName
]

{ #category : #'read-write' }
EP2MInstanceVariableSlot >> read: aRemoteObject [
	^ self backend object: aRemoteObject instVarAt: index
]

{ #category : #'read-write' }
EP2MInstanceVariableSlot >> readWith: anInterpreter inNode: aRBInstanceVariableNode [ 

	^ anInterpreter readInstVarAt: self index named: objectName
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
