Class {
	#name : #LiteralVariableModel1,
	#superclass : #ObjectModel,
	#instVars : [
		'pbInstruction',
		'value'
	],
	#category : #'Espell2-Metamodel-Variables'
}

{ #category : #instanciation }
LiteralVariableModel1 class >> role [ 
	^ #Association
]

{ #category : #hooks }
LiteralVariableModel1 >> accept: anEPASTInterpreter assign: anEP2Remote inNode: aRBGlobalNode [ 
	self value: anEP2Remote 
]

{ #category : #'accessing-api' }
LiteralVariableModel1 >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [
	remote ifNotNil: [ ^ remote ].
	^ remote := (self language classWithRole: self class role) ensureRemote new
		key: self name;
		value: self value;
		yourself
]

{ #category : #compilation }
LiteralVariableModel1 >> emitStore: anIRBuilder [ 
	anIRBuilder storeIntoLiteralVariable: self
]

{ #category : #compile }
LiteralVariableModel1 >> emitValue: anIRBuilder [
	anIRBuilder pushLiteralVariable: self.
]

{ #category : #'initial value' }
LiteralVariableModel1 >> initialValue [ 
	^ pbInstruction evaluate
]

{ #category : #initialization }
LiteralVariableModel1 >> initializationCode: aBlockOraString [
	| languageModel |
	languageModel := self environment.
	
	pbInstruction := aBlockOraString
		asPBInstructionFor: languageModel
]

{ #category : #testing }
LiteralVariableModel1 >> isGlobalVariable [
	self subclassResponsibility 
]

{ #category : #accessing }
LiteralVariableModel1 >> key [ 
	^ self name asSymbol
]

{ #category : #'accessing-api' }
LiteralVariableModel1 >> value [ 
	value ifNil: [ 
		value := self initialValue ].
	^ value
]

{ #category : #value }
LiteralVariableModel1 >> value: anObject [
	value := anObject 
]
