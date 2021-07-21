Class {
	#name : #EP2ClassTableHandle,
	#superclass : #EP2InternalObjectHandle,
	#instVars : [
		'classIndex'
	],
	#category : #'Espell2-Handles'
}

{ #category : #accessing }
EP2ClassTableHandle >> address [

	^ backend classAtIndex: classIndex
]

{ #category : #converting }
EP2ClassTableHandle >> asClassIndexHandle [
	^ self
]

{ #category : #'accessing-mirror' }
EP2ClassTableHandle >> basicClassHandle [
	
	^ backend handleOnAddress: (backend classOf: self)
]

{ #category : #accessing }
EP2ClassTableHandle >> classIndex [
	^ classIndex 

]

{ #category : #accessing }
EP2ClassTableHandle >> classIndex: anInteger [ 
	classIndex := anInteger 

]

{ #category : #testing }
EP2ClassTableHandle >> isClassTableHandler [
	^ true
]

{ #category : #printing }
EP2ClassTableHandle >> printOn: aStream [
	aStream 
		nextPutAll: 'classTableHandle[';
		nextPutAll: self address asString;
		nextPutAll: ']'
]
