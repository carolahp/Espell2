Class {
	#name : #GlobalModel,
	#superclass : #ObjectModel,
	#instVars : [
		'role'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #accessing }
GlobalModel >> environment [ 
	self halt
]

{ #category : #printing }
GlobalModel >> printOn: aStream [
	aStream 
		nextPutAll: 'aMGlobal("';
		nextPutAll: self name;
		nextPutAll: '")'
]

{ #category : #accessing }
GlobalModel >> role [
	^ role
]

{ #category : #accessing }
GlobalModel >> role: aString [ 
	role := aString
]
