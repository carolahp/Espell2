Class {
	#name : #EP2MGlobalVariable,
	#superclass : #EP2MObject,
	#category : #'Espell2-Metamodel'
}

{ #category : #printing }
EP2MGlobalVariable >> printOn: aStream [
	aStream 
		nextPutAll: 'aMGlobal("';
		nextPutAll: self name;
		nextPutAll: '")'
]
