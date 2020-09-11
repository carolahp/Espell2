Class {
	#name : #MCandleExplicitMetaclasses,
	#superclass : #MExplicitMetaclasses,
	#category : #'Espell2-Metamodel'
}

{ #category : #'hooks-api' }
MCandleExplicitMetaclasses class >> classMetaclass [
	" Return the subclass of EP2MClass that defines the metamodel for classes of the language "
	^ MCandleExplicitMetaclassesClass 
]

{ #category : #hooks }
MCandleExplicitMetaclasses >> hookEntryPoint [
	| code |
	code := 'System start'.
	^ self newInstruction 
		code: code
]
