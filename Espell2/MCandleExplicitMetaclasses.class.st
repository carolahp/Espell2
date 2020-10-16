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
MCandleExplicitMetaclasses >> entryPointCode [
	^ 'System start'
]

{ #category : #hooks }
MCandleExplicitMetaclasses >> hookInitializeSpecialObjectsArray [
	^ nil
]

{ #category : #hooks }
MCandleExplicitMetaclasses >> hookSetSpecialObjectsArray: anEP2RemoteArray [ 
	^nil
]
