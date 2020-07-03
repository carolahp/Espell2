Class {
	#name : #EP2InternalCharacterTable,
	#superclass : #EP2CharacterTable,
	#category : #'Espell2-Image'
}

{ #category : #public }
EP2InternalCharacterTable >> at: aLocalCharacter [

	| table |
	self halt.
	table := objectSpace basicCharacterTable.
	^ table at: aLocalCharacter asciiValue + 1.
]

{ #category : #public }
EP2InternalCharacterTable >> includesKey: aLocalCharacter [

	| table |
	table := objectSpace basicCharacterTable.
	^ table size > aLocalCharacter asciiValue and: [(table at: aLocalCharacter asciiValue + 1) isNilObject not].
]

{ #category : #public }
EP2InternalCharacterTable >> installCharacter: aRemoteCharacter [

	self error: 'The internal character table has already all characters installed'
]

{ #category : #public }
EP2InternalCharacterTable >> realCharacterTable [

	| characterClassMirror |
	characterClassMirror := objectSpace classNamed: objectSpace worldConfiguration characterClassName.
	^ characterClassMirror classPool at: #CharacterTable
]

{ #category : #public }
EP2InternalCharacterTable >> setCharacterTable: anArrayOfCharacters [

	| characterClassMirror |
	objectSpace basicCharacterTable: anArrayOfCharacters.
	characterClassMirror := objectSpace classNamed: objectSpace worldConfiguration characterClassName.
	^ characterClassMirror classPool at: #CharacterTable put: anArrayOfCharacters
]

{ #category : #converting }
EP2InternalCharacterTable >> toInternalCharacterTable [
	
	^ self
]
