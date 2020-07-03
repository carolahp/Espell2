Class {
	#name : #EP2LiteralBinding,
	#superclass : #Object,
	#instVars : [
		'name',
		'objectSpace'
	],
	#category : #'Espell2-Compiler-Bindings'
}

{ #category : #comparing }
EP2LiteralBinding >> = another [ 

	^ self name = another name
]

{ #category : #'from local to remote' }
EP2LiteralBinding >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	self subclassResponsibility 
]

{ #category : #'accessing remote objects' }
EP2LiteralBinding >> classNamed: aString [ 
	^ objectSpace systemDictionary at: aString
]

{ #category : #emit }
EP2LiteralBinding >> emitStore: anIRBuilder [ 
	anIRBuilder storeIntoLiteralVariable: self.
]

{ #category : #value }
EP2LiteralBinding >> emitValue: anIRBuilder [
	anIRBuilder pushLiteralVariable: self.
]

{ #category : #testing }
EP2LiteralBinding >> isVariableBinding [
	^true
]

{ #category : #accessing }
EP2LiteralBinding >> name [

	^ name
]

{ #category : #accessing }
EP2LiteralBinding >> name: aName [

	name := aName
]

{ #category : #accessing }
EP2LiteralBinding >> objectSpace: anEP2ObjectSpace [ 
	objectSpace := anEP2ObjectSpace
]

{ #category : #evaluating }
EP2LiteralBinding >> value [
	self halt.
"	^ (objectSpace classNamed: name) mirror"
]
