Class {
	#name : #EP2CharacterTable,
	#superclass : #Object,
	#instVars : [
		'objectSpace'
	],
	#category : #'Espell2-Image'
}

{ #category : #public }
EP2CharacterTable >> initializeTable [

	Character characterTable do: [ :character | self installCharacter: character ]
]

{ #category : #accessing }
EP2CharacterTable >> objectSpace: anObjectSpace [

	objectSpace := anObjectSpace
]
