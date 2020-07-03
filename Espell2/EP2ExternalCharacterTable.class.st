Class {
	#name : #EP2ExternalCharacterTable,
	#superclass : #EP2CharacterTable,
	#instVars : [
		'characters'
	],
	#category : #'Espell2-Image'
}

{ #category : #public }
EP2ExternalCharacterTable >> at: aLocalCharacter [

	^ characters at: aLocalCharacter
]

{ #category : #public }
EP2ExternalCharacterTable >> includesKey: aLocalCharacter [

	^ characters includesKey: aLocalCharacter
]

{ #category : #initialization }
EP2ExternalCharacterTable >> initialize [

	super initialize.
	characters := EPDictionary new.
]

{ #category : #public }
EP2ExternalCharacterTable >> installCharacter: aRemoteCharacter [

	characters at: (objectSpace fromRemoteCharacter: aRemoteCharacter) put: aRemoteCharacter
]

{ #category : #public }
EP2ExternalCharacterTable >> size [

	^ characters size
]

{ #category : #public }
EP2ExternalCharacterTable >> toInternalCharacterTable [

	| internal  remoteTable |
	internal := EP2InternalCharacterTable new objectSpace: objectSpace.
	
	remoteTable := objectSpace newArrayWithAll: (Character characterTable collect: [ :each | each asLiteralInObjectSpace: objectSpace ]).
	internal setCharacterTable: remoteTable.
	objectSpace characterTable: internal.
]
