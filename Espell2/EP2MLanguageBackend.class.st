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

{ #category : #'class slots' }
EP2MLanguageBackend >> addSlot: aString to: aLayout [
	| newSlot |
	newSlot := aLayout remote isClassMetamodel
		ifTrue: [ 
			(environment class instanceVariableSlotMetaclass
				named: aString asSymbol
				parent: aLayout)
				definingClass: aLayout remote;
				yourself
				 ]
		ifFalse: [ self error: 'Implementation supports only Instance variable slots' ].
	newSlot index: aLayout allSlots size + 1.
	aLayout slots add: newSlot.
	^ newSlot
]

{ #category : #accessing }
EP2MLanguageBackend >> environment: anOLObjVLisp [ 
	environment := anOLObjVLisp
]

{ #category : #'accessing instance variables' }
EP2MLanguageBackend >> object: anOLClass instVarAt: anInteger [ 
	"Classes EP2MObject and EP2MClass add up 5 instance variables before the IV superclass 
	(superclass is the first IV for classes according to VM requirements)"
	^ anOLClass instVarAt: anInteger + 5
]

{ #category : #'accessing slots' }
EP2MLanguageBackend >> slotsFor: aClassOrVariableSizedObject do: aBlockClosure [
	aClassOrVariableSizedObject isBehavior 
		ifTrue: [ aClassOrVariableSizedObject layout slots do: [:slot | aBlockClosure value: slot] ] 
		ifFalse: [ self halt. ]
	
]
