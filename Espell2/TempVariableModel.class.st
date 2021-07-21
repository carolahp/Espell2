Class {
	#name : #TempVariableModel,
	#superclass : #VariableModel,
	#instVars : [
		'escaping',
		'index',
		'name'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'accessing-api' }
TempVariableModel >> emitStore: methodBuilder [

	methodBuilder storeTemp: name. 
]

{ #category : #'accessing-api' }
TempVariableModel >> emitValue: methodBuilder [

	methodBuilder pushTemp: name.
]

{ #category : #'accessing-api' }
TempVariableModel >> escaping [
	^escaping
]

{ #category : #accessing }
TempVariableModel >> index: anInteger [ 
	index := anInteger
]

{ #category : #asd }
TempVariableModel >> initialize [
	super initialize.
	escaping := false.
]

{ #category : #asd }
TempVariableModel >> isCopying [
	^ false
]

{ #category : #'accessing-api' }
TempVariableModel >> isEscaping [
	^escaping = #escapingRead or: [escaping = #escapingWrite]
]

{ #category : #'accessing-api' }
TempVariableModel >> isEscapingRead [
	^escaping = #escapingRead

]

{ #category : #'accessing-api' }
TempVariableModel >> isEscapingWrite [
	^escaping = #escapingWrite

]

{ #category : #'accessing-api' }
TempVariableModel >> isGlobalVariable [ 
	^ false
]

{ #category : #asd }
TempVariableModel >> isTemp [
	^ true
]

{ #category : #'accessing-api' }
TempVariableModel >> isTempVectorTemp [
	^false
]

{ #category : #'accessing-api' }
TempVariableModel >> isUninitialized [

	^ self isWrite not
]

{ #category : #'accessing-api' }
TempVariableModel >> markEscapingRead [
	escaping = #escapingWrite ifFalse: [escaping := #escapingRead]
]

{ #category : #asd }
TempVariableModel >> markEscapingWrite [
	escaping := #escapingWrite.
	self isRepeatedWrite ifFalse:[usage := #write]
]

{ #category : #accessing }
TempVariableModel >> name: aString [
	super name: aString.
	name := aString
]

{ #category : #semantic }
TempVariableModel >> semanticNodeClass [
	^ RBTemporaryNode
]
