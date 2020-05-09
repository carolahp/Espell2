Class {
	#name : #EP2ClassTableHandle,
	#superclass : #EP2InternalObjectHandle,
	#instVars : [
		'classIndex'
	],
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #accessing }
EP2ClassTableHandle >> address [

	^ backend classAtIndex: classIndex
]

{ #category : #converting }
EP2ClassTableHandle >> asClassIndexHandle [
	^ self
]

{ #category : #'as yet unclassified' }
EP2ClassTableHandle >> backend: anEP2Backend [ 
	backend := anEP2Backend 

]

{ #category : #'accessing-mirror' }
EP2ClassTableHandle >> basicClassHandle [
	
	^ backend handleOnAddress: (backend classOf: self)
]

{ #category : #accessing }
EP2ClassTableHandle >> classIndex: anInteger [ 
	classIndex := anInteger 

]
