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

{ #category : #'code generation' }
InstanceVariableSlotModel >> emitStore: methodBuilder [

	methodBuilder storeInstVar: self index
]

{ #category : #'code generation' }
InstanceVariableSlotModel >> emitValue: methodBuilder [ 
	methodBuilder pushInstVar: self index.

]

{ #category : #testing }
InstanceVariableSlotModel >> isInstanceVariableSlot [
	^ true
]

{ #category : #'meta object protocol' }
InstanceVariableSlotModel >> read: aRemoteObject [
	^ self backend object: aRemoteObject instVarAt: index
]

{ #category : #'ast evaluation' }
InstanceVariableSlotModel >> readWith: anInterpreter inNode: aRBInstanceVariableNode [ 

	^ anInterpreter readInstVarAt: self index named: objectName
]

{ #category : #'read-write' }
InstanceVariableSlotModel >> slotName [ 
	^ 'InstVarSlot'
]

{ #category : #'meta object protocol' }
InstanceVariableSlotModel >> write: aRemoteValue to: aRemoteObject [
	self backend 
		object: aRemoteObject
		instVarAt: index 
		put: aRemoteValue
]
