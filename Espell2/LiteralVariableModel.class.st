Class {
	#name : #LiteralVariableModel,
	#superclass : #VariableModel,
	#instVars : [
		'pbInstruction'
	],
	#category : #'Espell2-Metamodel-Variables'
}

{ #category : #hooks }
LiteralVariableModel >> accept: anEPASTInterpreter assign: anEP2Mirror inNode: aRBGlobalNode [ 
	self subclassResponsibility 
]

{ #category : #'accessing-api' }
LiteralVariableModel >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	self subclassResponsibility 
]

{ #category : #testing }
LiteralVariableModel >> destroy [ 
	super destroy.
	pbInstruction ifNotNil: [
		pbInstruction destroy.
		pbInstruction := nil.
	]
]

{ #category : #'read - write' }
LiteralVariableModel >> emitStore: anIRBuilder [ 
	anIRBuilder storeIntoLiteralVariable: self.
]

{ #category : #'read - write' }
LiteralVariableModel >> emitValue: anIRBuilder [
	anIRBuilder pushLiteralVariable: self.
]

{ #category : #testing }
LiteralVariableModel >> isGlobalClassNameBinding [
	^ false
]

{ #category : #'as yet unclassified' }
LiteralVariableModel >> isUninitialized [
	self shouldBeImplemented.
]

{ #category : #testing }
LiteralVariableModel >> isVariableBinding [
	^true
]

{ #category : #testing }
LiteralVariableModel >> isWritable [
	"Literal variables are writable, if they aren't global bindings for class names, like
 #Object -> Object "

	^ (self isGlobalVariable and: [ self isGlobalClassNameBinding ]) not
]

{ #category : #'accessing-api' }
LiteralVariableModel >> key [ 
	^ self name asSymbol
]

{ #category : #accessing }
LiteralVariableModel >> remote: anEP2Mirror [ 
	remote := anEP2Mirror 
]

{ #category : #'accessing-api' }
LiteralVariableModel >> value [ 
	^ remote
]
