Class {
	#name : #MExplicitMetaclasses,
	#superclass : #EP2MLanguage,
	#category : #'Espell2-Metamodel'
}

{ #category : #'hooks-api' }
MExplicitMetaclasses class >> classMetaclass [
	" Return the subclass of EP2MClass that defines the metamodel for classes of the language "
	^ MExplicitMetaclassesClass 
]
