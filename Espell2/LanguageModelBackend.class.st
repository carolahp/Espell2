Class {
	#name : #LanguageModelBackend,
	#superclass : #ObjectModel,
	#instVars : [
		'environment'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'instance creation' }
LanguageModelBackend class >> for: anOLObjVLisp [ 
	^ self new 
		environment: anOLObjVLisp;
		yourself.
]

{ #category : #calypso }
LanguageModelBackend >> addMethodTag: aSymbol to: anEP2MClass [ 
	anEP2MClass pvtAddMethodTag: aSymbol
]

{ #category : #slots }
LanguageModelBackend >> addSlot: aString index: anInteger to: aClassModel [
	| newSlot |
	newSlot := aClassModel isClassModel
		ifTrue: [ 
			(aClassModel class instanceVariableSlotModel
				named: aString asSymbol
				parent: aClassModel)
				definingClass: aClassModel;
				yourself
				 ]
		ifFalse: [ self error: 'Implementation supports only Instance variable slots' ].
	newSlot index: anInteger.
	aClassModel layout pvtAddSlot: newSlot.
	^ newSlot
]

{ #category : #'class slots' }
LanguageModelBackend >> addSlot: aString to: aLayout [
	self addSlot: aString index: aLayout allSlots size + 1 to: aLayout
]

{ #category : #destroy }
LanguageModelBackend >> destroy [
	super destroy.
	environment := nil
]

{ #category : #accessing }
LanguageModelBackend >> environment: aLanguageModel [
	environment := aLanguageModel
]

{ #category : #'accessing instance variables' }
LanguageModelBackend >> object: anEP2MClass instVarAt: anInteger [ 
	| key dict |
	
	self deprecated: 'usage of slots in the metamodel is not supported'.
	dict := anEP2MClass instVarsDict. 
	key := dict keys at: anInteger ifAbsent: [ ^ KeyNotFound signal: 'Instance variable at ', anInteger asString, ' does not exist' ].
	^ dict at: key
]

{ #category : #slots }
LanguageModelBackend >> object: anEP2MClass instVarAt: anInteger put: anObject [ 
	| key dict |
	
	self deprecated: 'usage of slots in the metamodel is not supported'.
	dict := anEP2MClass instVarsDict. 
	key := dict keys at: anInteger ifAbsent: [dict size + 1].
	dict at: key put: anObject
]

{ #category : #'accessing slots' }
LanguageModelBackend >> slotsFor: aClassOrVariableSizedObject do: aBlockClosure [
	
	aClassOrVariableSizedObject isBehavior
		ifTrue: [ (aClassOrVariableSizedObject layout pvtSlots)
				do: [ :slot | aBlockClosure value: slot ] ]
		ifFalse: [ self
			
				error:
					'For the moment slots are implemented only to store instance variables' ]
]

{ #category : #calypso }
LanguageModelBackend >> tagMethod: anEP2MMethod with: aSymbol [ 
	anEP2MMethod pvtTagWith: aSymbol
]
