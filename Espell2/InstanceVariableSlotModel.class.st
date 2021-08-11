Class {
	#name : #InstanceVariableSlotModel,
	#superclass : #IndexedSlotModel,
	#category : #'Espell2-Metamodel-Variables'
}

{ #category : #instanciation }
InstanceVariableSlotModel class >> role [ 
	^ 'InstanceVariableSlot'
]

{ #category : #'converting local-to-remote' }
InstanceVariableSlotModel >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	remote ifNotNil: [ ^remote ].
	^ remote := (self language classWithRole: self class role) remote new
		name: self name;
		definingClass: definingClass;
		owningClass: owningClass;
		index: index;
		yourself 
]

{ #category : #'as yet unclassified' }
InstanceVariableSlotModel >> emitStore: methodBuilder [

	methodBuilder storeInstVar: self index
]

{ #category : #emiting }
InstanceVariableSlotModel >> emitValue: methodBuilder [ 
	methodBuilder pushInstVar: self index.

]

{ #category : #testing }
InstanceVariableSlotModel >> isInstanceVariableSlot [
	^ true
]

{ #category : #'read-write' }
InstanceVariableSlotModel >> printOn: aStream [
	aStream nextPutAll: objectName ,' => ', self slotName
]

{ #category : #'read-write' }
InstanceVariableSlotModel >> read: aRemoteObject [
	^ self backend object: aRemoteObject instVarAt: index
]

{ #category : #'read-write' }
InstanceVariableSlotModel >> readWith: anInterpreter inNode: aRBInstanceVariableNode [ 

	^ anInterpreter readInstVarAt: self index named: objectName
]

{ #category : #'read-write' }
InstanceVariableSlotModel >> slotName [ 
	^ 'InstVarSlot'
]

{ #category : #'read-write' }
InstanceVariableSlotModel >> write: aRemoteValue to: aRemoteObject [
	self backend 
		object: aRemoteObject
		instVarAt: index 
		put: aRemoteValue
]
