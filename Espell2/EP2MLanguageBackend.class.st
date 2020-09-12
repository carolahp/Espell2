Class {
	#name : #EP2MLanguageBackend,
	#superclass : #EP2MObject,
	#instVars : [
		'environment'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'instance creation' }
EP2MLanguageBackend class >> for: anOLObjVLisp [ 
	^ self new 
		environment: anOLObjVLisp;
		yourself.
]

{ #category : #calypso }
EP2MLanguageBackend >> addMethodTag: aSymbol to: anEP2MClass [ 
	anEP2MClass pvtAddMethodTag: aSymbol
]

{ #category : #slots }
EP2MLanguageBackend >> addSlot: aString index: anInteger to: anEP2MClass [
	| newSlot |
	newSlot := anEP2MClass isClassMetamodel
		ifTrue: [ 
			(environment class instanceVariableSlotMetaclass
				named: aString asSymbol
				parent: anEP2MClass)
				definingClass: anEP2MClass;
				yourself
				 ]
		ifFalse: [ self error: 'Implementation supports only Instance variable slots' ].
	newSlot index: anInteger.
	anEP2MClass layout slots add: newSlot.
	^ newSlot
]

{ #category : #'class slots' }
EP2MLanguageBackend >> addSlot: aString to: aLayout [
	self addSlot: aString index: aLayout allSlots size + 1 to: aLayout
]

{ #category : #accessing }
EP2MLanguageBackend >> environment: anOLObjVLisp [ 
	environment := anOLObjVLisp
]

{ #category : #'accessing instance variables' }
EP2MLanguageBackend >> object: anEP2MClass instVarAt: anInteger [ 
	| key dict |
	
	self deprecated: 'usage of slots in the metamodel is not supported'.
	dict := anEP2MClass instVarsDict. 
	key := dict keys at: anInteger ifAbsent: [ ^ KeyNotFound signal: 'Instance variable at ', anInteger asString, ' does not exist' ].
	^ dict at: key
]

{ #category : #slots }
EP2MLanguageBackend >> object: anEP2MClass instVarAt: anInteger put: anObject [ 
	| key dict |
	
	self deprecated: 'usage of slots in the metamodel is not supported'.
	dict := anEP2MClass instVarsDict. 
	key := dict keys at: anInteger ifAbsent: [dict size + 1].
	dict at: key put: anObject
]

{ #category : #'accessing slots' }
EP2MLanguageBackend >> slotsFor: aClassOrVariableSizedObject do: aBlockClosure [
	
	aClassOrVariableSizedObject isBehavior
		ifTrue: [ (aClassOrVariableSizedObject layout instVarNamed: #slots)
				do: [ :slot | aBlockClosure value: slot ] ]
		ifFalse: [ self
				error:
					'For the moment slots are implemented only to store instance variables' ]
]

{ #category : #calypso }
EP2MLanguageBackend >> tagMethod: anEP2MMethod with: aSymbol [ 
	anEP2MMethod pvtTagWith: aSymbol
]
