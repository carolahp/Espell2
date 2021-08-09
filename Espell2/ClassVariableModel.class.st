Class {
	#name : #ClassVariableModel,
	#superclass : #ObjectModel,
	#instVars : [
		'pbInstruction'
	],
	#category : #'Espell2-Metamodel-Variables'
}

{ #category : #hooks }
ClassVariableModel >> accept: anEPASTInterpreter assign: anEP2Remote inNode: aRBGlobalNode [ 
	self value: anEP2Remote 
]

{ #category : #'accessing-api' }
ClassVariableModel >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [
	^ (self language classWithRole: #Association) ensureRemote new
		key: self name;
		value: self value;
		yourself
]

{ #category : #compile }
ClassVariableModel >> emitValue: anIRBuilder [
	anIRBuilder pushLiteralVariable: self.
]

{ #category : #'initial value' }
ClassVariableModel >> initialValue [ 
	^ pbInstruction evaluate
]

{ #category : #initialization }
ClassVariableModel >> initializationCode: aBlockOraString [
	| languageModel |
	languageModel := self environment.
	
	pbInstruction := aBlockOraString
		asPBInstructionFor: languageModel
]

{ #category : #testing }
ClassVariableModel >> isGlobalVariable [
	^ false
]

{ #category : #testing }
ClassVariableModel >> isWritable [
	^ true
]

{ #category : #accessing }
ClassVariableModel >> key [ 
	^ self name asSymbol
]

{ #category : #'accessing-api' }
ClassVariableModel >> value [ 
	^ remote ifNil: [ remote := self initialValue ]
]

{ #category : #value }
ClassVariableModel >> value: anEP2Remote [ 
	self assert: anEP2Remote isEP2Remote.
	self remote: anEP2Remote
]
