Class {
	#name : #EP2TonelParser,
	#superclass : #TonelParser,
	#instVars : [
		'metamodel'
	],
	#category : #'Espell2-Tonel'
}

{ #category : #instantiation }
EP2TonelParser class >> parseStream: aStream metamodel: anEP2MLanguage [
	^ (self on: aStream)
		metamodel: anEP2MLanguage;
		start
]

{ #category : #accessing }
EP2TonelParser >> metamodel [
	^ metamodel
]

{ #category : #accessing }
EP2TonelParser >> metamodel: anOLObjVLisp [ 
	metamodel := anOLObjVLisp
]

{ #category : #'private factory' }
EP2TonelParser >> newClassDefinitionFrom: anArray [
	| metadata class |

	metadata := anArray sixth.
	class := EP2MCClassDefinition
		name: (metadata at: #name)
		superclassName: (metadata at: #superclass)
		category: (metadata at: #category)
		instVarNames: (metadata at: #instVars ifAbsent: [ #() ])
		classVarNames: (metadata at: 'classVars' ifAbsent: [ #() ])
		poolDictionaryNames: (metadata at: 'pools' ifAbsent: [ #() ])
		classInstVarNames: (metadata at: 'classInstVars' ifAbsent: [ #() ])
		type: (metadata at: #type ifAbsent: [ #normal ]) asSymbol
		comment: (anArray second ifNil: [ '' ])
		commentStamp: nil.
	
	class role: (metadata at: #role ifAbsent: [ nil ]).
	
	(metadata keys
		reject: [ :key | (#(name superclass traits classTraits category instVars classVars pools classInstVars type) indexOf: key) > 0 ])
		do: [ : key | class extraInstVarNamed: key put: (metadata at: key ifAbsent: ['']) ].
	^ class
]
