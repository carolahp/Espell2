Class {
	#name : #EP2TonelParser,
	#superclass : #TonelParser,
	#category : #Espell2
}

{ #category : #'private factory' }
EP2TonelParser >> newClassDefinitionFrom: anArray [
	| metadata class |
	metadata := anArray sixth.
	class := EP2MCClassDefinition
		name: (metadata at: #name)
		superclassName: (metadata at: #superclass)
		traitComposition: (metadata at: #traits ifAbsent: [ '{}' ])
		classTraitComposition: (metadata at: #classTraits ifAbsent: [ '{}' ])
		category: (metadata at: #category)
		instVarNames: (metadata at: #instVars ifAbsent: [ #() ])
		classVarNames: (metadata at: 'classVars' ifAbsent: [ #() ])
		poolDictionaryNames: (metadata at: 'pools' ifAbsent: [ #() ])
		classInstVarNames: (metadata at: 'classInstVars' ifAbsent: [ #() ])
		type: (metadata at: #type ifAbsent: [ #normal ]) asSymbol
		comment: (anArray second ifNil: [ '' ])
		commentStamp: nil.
	
	(metadata keys
		reject: [ :key | (#(name superclass traits classTraits category instVars classVars pools classInstVars type) indexOf: key) > 0 ])
		do: [ : key | class instVarNamed: key put: (metadata at: key ifAbsent: ['']) ].
	^ class
]
