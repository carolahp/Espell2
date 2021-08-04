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
	| metadata class required excluded missing missing2 |
	
	metadata := anArray sixth.

	"Adding fixed fields for classes"
	class := EP2MCClassDefinition 	
		name: (metadata at: #name)
		superclassName: (metadata at: #superclass)
		category: (metadata at: #category)
		instVarNames: (metadata at: #instVars ifAbsent: [#()])
		comment: ''.
	class	
		type: (metadata at: #type ifAbsent: [ #normal ]);
		role: (metadata at: #role ifAbsent: [ nil ]).
	
	"To continue with the addition we exclude fields we already added"
	excluded := #(name superclass type category role) asSet. 
	
	"We also exclude fields defined by the base class metamodel (EP2MClass)"
"	excluded := excluded , #(tagsForMethods objectName remote properties parent layout template superclass methodDict format).
"
	"We get the name of fields specified in the class metamodel defined by the user (subclass of EP2MClass)"
	required := metamodel class classModel allClassModelInstVarNames.
	missing := required reject: [:key | excluded includes: key ].

	"We get extra fields found in the .class.st file"
	missing2 := metadata keys reject: [ :key | (excluded includes: key) and: (missing includes: key) ].
	
	"We force the addition of these fields"
	(missing, missing2) do: [ : key | class extraInstVarNamed: key put: (metadata at: key ifAbsent: [nil]) ].
	
	^ class
]
