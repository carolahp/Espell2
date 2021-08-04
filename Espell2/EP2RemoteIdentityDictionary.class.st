Class {
	#name : #EP2RemoteIdentityDictionary,
	#superclass : #EP2RemoteDictionary,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteIdentityDictionary class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemoteIdentityDictionary class >> newWithBackend: anEP2Backend size: nElements [
	| class dict array tally initialSize |
	class := anEP2Backend identityDictionaryClass
		ifNil: [ ^ super newWithBackend: anEP2Backend size: nElements ].
		
	initialSize := (nElements + 1) * 4 // 3.
	dict := (anEP2Backend basicNewOn: class) asRemoteSystemDictionary.
	array := EP2RemoteArray
		newWithSize: initialSize
		withBackend: anEP2Backend.
	tally := anEP2Backend fromLocalInteger: 0.
	dict array: array.
	dict tally: tally.
	^ dict
]

{ #category : #constants }
EP2RemoteIdentityDictionary class >> role [
	^'IdentityDictionary'
]

{ #category : #'accessing-specialInstVars' }
EP2RemoteIdentityDictionary >> scanFor: aRemoteObject [
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."

	| finish start element object |
	object := aRemoteObject
		asRemoteObjectInObjectSpace: self backend objectSpace.
	finish := self array size.
	start := object remoteIdentityHash \\ finish + 1.

	"Search from (hash mod size) to the end."
	start to: finish do: [ :index | 
		element := (self array at: index) asRemoteAssociation.
		(element isNilObject or: [ element key = object ])
			ifTrue: [ ^ index ] ].

	"Search from 1 to where we started."
	1 to: start - 1 do: [ :index | 
		element := (self array at: index) asRemoteAssociation.
		(element isNilObject or: [ element key = object ])
			ifTrue: [ ^ index ] ].
	^ 0	"No match AND no empty slot"
]
