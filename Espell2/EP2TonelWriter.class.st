Class {
	#name : #EP2TonelWriter,
	#superclass : #TonelWriter,
	#instVars : [
		'metamodel'
	],
	#category : #'Espell2-Tonel'
}

{ #category : #'instance creation' }
EP2TonelWriter class >> fileOut: aVersion on: aStream metamodel: anEP2MLanguage [ 
	(self on: aStream) 
		metamodel: anEP2MLanguage;
		writeVersion: aVersion
	

]

{ #category : #accessing }
EP2TonelWriter >> metamodel [
	^ metamodel
]

{ #category : #accessing }
EP2TonelWriter >> metamodel: anObject [
	metamodel := anObject
]

{ #category : #'private definitions' }
EP2TonelWriter >> typeDefinitionOf: aClassDefinition [
	| definition model excluded required missing |
	
	definition := OrderedDictionary new 
		at: #name put: aClassDefinition className; 
		at: #superclass put: aClassDefinition superclassName;
		yourself.
	model := self metamodel classNamed: (definition at: #name).
	model role ifNotNil: [ 
		definition at: #role put: model role ].
		
	aClassDefinition type = #normal ifFalse: [ 
		definition at: #type put: aClassDefinition type ].
	
	(aClassDefinition variables select: #isInstanceVariable thenCollect: #name)
		ifNotEmpty: [ :vars | definition at: #instVars put: vars asArray ].

	
	"We exclude fields we already added"
	excluded := #(name superclass type category role instVarNames) asSet. 
	
	"We also exclude fields defined by the base class metamodel (EP2MClass)"
	excluded := excluded , #(tagsForMethods objectName remote properties parent layout template methodDict format).
	
	"We get the name of fields specified in the class metamodel defined by the user (subclass of EP2MClass)"
	required := model basicClass allInstVarNames.
	missing := required reject: [:key | excluded includes: key ].
	missing do: [ : key | | value |
		value := model instVarNamed: key.
		value ifNotNil: [ | printedValue | 
			"remove quotes in the name of classes"
			printedValue := (value isKindOf: ClassModel) 
				ifTrue: [ (value asString trimBoth: [ :char | char = $" ]) asSymbol ]
				ifFalse: [ value asString ].
			definition at: key asSymbol put: printedValue ] ].
	definition 
		at: #indexInClassTable put: model indexInClassTable;
		at: #category put: aClassDefinition category.
	
	^ self toSTON: definition
]
