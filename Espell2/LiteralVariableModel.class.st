Class {
	#name : #LiteralVariableModel,
	#superclass : #ObjectModel,
	#instVars : [
		'initializationCode',
		'pbInstruction'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #hooks }
LiteralVariableModel >> accept: anEPASTInterpreter assign: anEP2Mirror inNode: aRBGlobalNode [ 
	self subclassResponsibility 
]

{ #category : #'accessing-api' }
LiteralVariableModel >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	self subclassResponsibility 
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
LiteralVariableModel >> isGlobalVariable [ 
	self subclassResponsibility 
]

{ #category : #testing }
LiteralVariableModel >> isVariableBinding [
	^true
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