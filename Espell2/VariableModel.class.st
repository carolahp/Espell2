Class {
	#name : #VariableModel,
	#superclass : #ObjectModel,
	#instVars : [
		'scope',
		'usage'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'code generation' }
VariableModel >> emitStore: methodBuilder [
	self subclassResponsibility 
]

{ #category : #'code generation' }
VariableModel >> emitValue: methodBuilder [
	self subclassResponsibility 
]

{ #category : #testing }
VariableModel >> isGlobalVariable [ 
	self subclassResponsibility 
]

{ #category : #asd }
VariableModel >> isRead [
	^usage = #read

]

{ #category : #asd }
VariableModel >> isRepeatedWrite [
	^usage = #repeatedWrite

]

{ #category : #testing }
VariableModel >> isSpecialVariable [
	^false
]

{ #category : #'accessing-api' }
VariableModel >> isUnused [
	"when the var is never read or written, it is not used.
	Note: we have a special #arg use which means arguments are never unused"
	^ usage isNil
]

{ #category : #asd }
VariableModel >> isWritable [
	^ true
]

{ #category : #'accessing-api' }
VariableModel >> isWrite [
	^ usage = #write or: [ self isRepeatedWrite ]
]

{ #category : #mark }
VariableModel >> markRead [
	"reading does not change a #write, nor an #arg"
	usage ifNil: [usage := #read]
]

{ #category : #'accessing-api' }
VariableModel >> markRepeatedWrite [
	"blocks in a loop have to know if write usage happens outside (just #write) or
	in the loop -> #repeatedWrite"
	usage := #repeatedWrite.
]

{ #category : #'accessing-api' }
VariableModel >> markWrite [

	"if an escaping var is wrote to later, it needs to be remote"
	self isEscaping 
		ifTrue: [self markEscapingWrite].
	usage := #write.
]

{ #category : #'as yet unclassified' }
VariableModel >> originalVar [
	^self
]

{ #category : #accessing }
VariableModel >> scope [
	^ scope
]

{ #category : #accessing }
VariableModel >> scope: anOCMethodScope [ 
	scope := anOCMethodScope
]

{ #category : #'accessing-api' }
VariableModel >> usage [ 
	^ usage
]
