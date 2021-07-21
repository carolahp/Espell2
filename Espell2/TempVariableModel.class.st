Class {
	#name : #TempVariableModel,
	#superclass : #LiteralVariableModel,
	#instVars : [
		'escaping',
		'index',
		'scope',
		'usage',
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
TempVariableModel >> isRepeatedWrite [
	^usage = #repeatedWrite

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
TempVariableModel >> isUnused [
	"when the var is never read or written, it is not used.
	Note: we have a special #arg use which means arguments are never unused"
	^ usage isNil
]

{ #category : #'accessing-api' }
TempVariableModel >> isWrite [
	^ usage = #write or: [ self isRepeatedWrite ]
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

{ #category : #'accessing-api' }
TempVariableModel >> markRepeatedWrite [
	"blocks in a loop have to know if write usage happens outside (just #write) or
	in the loop -> #repeatedWrite"
	usage := #repeatedWrite.
]

{ #category : #'accessing-api' }
TempVariableModel >> markWrite [

	"if an escaping var is wrote to later, it needs to be remote"
	self isEscaping 
		ifTrue: [self markEscapingWrite].
	usage := #write.
]

{ #category : #accessing }
TempVariableModel >> name: aString [
	super name: aString.
	name := aString
]

{ #category : #accessing }
TempVariableModel >> scope [
	^ scope
]

{ #category : #accessing }
TempVariableModel >> scope: anObject [
	scope := anObject
]

{ #category : #semantic }
TempVariableModel >> semanticNodeClass [
	^ RBTemporaryNode
]

{ #category : #'accessing-api' }
TempVariableModel >> usage [ 
	^ usage
]
