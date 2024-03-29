Class {
	#name : #SlotModel,
	#superclass : #ObjectModel,
	#instVars : [
		'owningClass',
		'definingClass'
	],
	#category : #'Espell2-Metamodel-Variables'
}

{ #category : #layout }
SlotModel class >> defaultLayout [
	^ EP2FixedLayout
]

{ #category : #testing }
SlotModel >> = other [
	"Every subclass that adds state must redefine this method"
	self == other
		ifTrue: [ ^ true ].
	^ (self species == other species) 
			and: [ objectName = other name ]
]

{ #category : #writing }
SlotModel >> accept: anInterpreter assign: aValue inNode: aVariableNode [
	^ anInterpreter write: aValue at: self index named: self name
]

{ #category : #converting }
SlotModel >> asEP2Slot [
	^ self
]

{ #category : #accessing }
SlotModel >> backend [
	^ definingClass backend
]

{ #category : #accessing }
SlotModel >> definingClass: anEP2RemoteClass [ 

	definingClass := anEP2RemoteClass
]

{ #category : #testing }
SlotModel >> destroy [ 
	self halt.
]

{ #category : #'code generation' }
SlotModel >> emitStore: aMethodBuilder [
	"generate bytecode to call the reflective write method of the Slot"
	| tempName |
	tempName := '0slotTempForStackManipulation'.  
	aMethodBuilder
		addTemp: tempName;
		storeTemp: tempName;
		popTop;
		pushReceiver;
		pushLiteralVariable: (AdditionalBinding key: #slot value: self);
		pushTemp: tempName;
		send: #writeSlot:value:
]

{ #category : #'code generation' }
SlotModel >> emitValue: aMethodBuilder [
	aMethodBuilder
		pushLiteralVariable: (AdditionalBinding key: #slot value: self);
		pushReceiver;
		send: #read:
]

{ #category : #accessing }
SlotModel >> environment [ 
	self halt
]

{ #category : #testing }
SlotModel >> isIndexedSlot [
	^ false
]

{ #category : #testing }
SlotModel >> isInstanceVariableSlot [
	^ false
]

{ #category : #testing }
SlotModel >> isSlot [

	^ true
]

{ #category : #testing }
SlotModel >> printOn: aStream [
	self subclassResponsibility 
]

{ #category : #'meta object protocol' }
SlotModel >> read: anEP2RemoteAssociation [ 
	self subclassResponsibility 
]

{ #category : #reading }
SlotModel >> readWith: anEPASTInterpreter inNode: aRBInstanceVariableNode [ 
	self error: 'only for InstanceVariableSlots'
]

{ #category : #testing }
SlotModel >> slotName [ 
	self subclassResponsibility 
]

{ #category : #'meta object protocol' }
SlotModel >> write: aValue to: anObject [
	^self subclassResponsibility
]
