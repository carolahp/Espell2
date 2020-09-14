Class {
	#name : #EP2MGlobalVariable,
	#superclass : #EP2MObject,
	#instVars : [
		'role'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #printing }
EP2MGlobalVariable >> printOn: aStream [
	aStream 
		nextPutAll: 'aMGlobal("';
		nextPutAll: self name;
		nextPutAll: '")'
]

{ #category : #accessing }
EP2MGlobalVariable >> role [
	^ role
]

{ #category : #accessing }
EP2MGlobalVariable >> role: aString [ 
	role := aString
]
