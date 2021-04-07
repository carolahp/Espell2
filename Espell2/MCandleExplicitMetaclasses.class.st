Class {
	#name : #MCandleExplicitMetaclasses,
	#superclass : #MExplicitMetaclasses,
	#category : #'Espell2-Metamodel'
}

{ #category : #'hooks-api' }
MCandleExplicitMetaclasses class >> classMetaclass [
	" Return the subclass of EP2MClass that defines the metamodel for classes of the language "
	^ CandleExplicitMetaclassesClass 
]

{ #category : #hooks }
MCandleExplicitMetaclasses >> entryPointCode [
	^ 'System quit'
]

{ #category : #hooks }
MCandleExplicitMetaclasses >> hookInitializeSpecialObjectsArray [
	^ nil
]

{ #category : #hooks }
MCandleExplicitMetaclasses >> hookSetSpecialObjectsArray: anEP2RemoteArray [ 
	^nil
]
