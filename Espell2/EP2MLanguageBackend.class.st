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
			environment class instanceVariableSlotMetaclass
				named: aString asSymbol
				parent: aLayout
				 ]
		ifFalse: [ self halt ].
	newSlot index: aLayout allSlots size + 1.
	aLayout slots add: newSlot.
	^ newSlot
]

{ #category : #accessing }
EP2MLanguageBackend >> environment: anOLObjVLisp [ 
	environment := anOLObjVLisp
]

{ #category : #'accessing slots' }
EP2MLanguageBackend >> slotsFor: aClassOrVariableSizedObject do: aBlockClosure [
	aClassOrVariableSizedObject isBehavior 
		ifTrue: [ aClassOrVariableSizedObject layout slots do: [:slot | aBlockClosure value: slot] ] 
		ifFalse: [ self halt. ]
	
]
