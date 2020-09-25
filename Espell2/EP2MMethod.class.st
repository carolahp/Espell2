Class {
	#name : #EP2MMethod,
	#superclass : #EP2MObject,
	#instVars : [
		'sourceCode',
		'selector',
		'author',
		'time',
		'tags',
		'remote'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #calypso }
EP2MMethod class >> asYetUnclassifiedProtocolName [

	^ 'as yet unclassified' asSymbol
]

{ #category : #calypso }
EP2MMethod >> argumentNames [
	^ self ast argumentNames
]

{ #category : #exporting }
EP2MMethod >> asMCDefinition [
	
	^ MCMethodDefinition 
		className: self parent name
		classIsMeta: false
		selector: self name
		category: 'as yet unclassified'
		timeStamp: ''
		source: self sourceCode
]

{ #category : #accessing }
EP2MMethod >> ast [
	"Answer my AST with semantic analysis. See #parseTree."
	
	^ self propertyNamed: #ast ifAbsentPut: [ self parseTree doSemanticAnalysisIn: self methodClass ]


]

{ #category : #calypso }
EP2MMethod >> astForStylingInCalypso [
	^ self ast
]

{ #category : #accessing }
EP2MMethod >> author: aString [ 
	author := aString
]

{ #category : #accessing }
EP2MMethod >> backend [ 
	^ self parent backend
]

{ #category : #calypso }
EP2MMethod >> calypsoEnvironmentType [
	^ClyMethod
]

{ #category : #initialization }
EP2MMethod >> extendWithMonticello: aMCMethodDefinition [
	| mcDef |
	mcDef := aMCMethodDefinition.
	self
		sourceCode: mcDef source;
		selector: mcDef selector	";
	  Variable or expression expected ->author: (mcDef authorForStamp: mcDef timeStamp);
	 time: (mcDef timeForStamp: mcDef timeStamp)"

	"protocol := self parent ensureProtocolNamed: mcDef category asSymbol.
	self protocol: protocol"
]

{ #category : #calypso }
EP2MMethod >> hasSelector: aString specialSelectorIndex: anUndefinedObject [ 
	self halt.
	^ self ast sentMessages includes: selector
]

{ #category : #initialization }
EP2MMethod >> initialize [ 
	super initialize.
	tags := Set new
]

{ #category : #initialization }
EP2MMethod >> initializeWithLocal: aCompiledMethod [ 
	^ self 
		sourceCode: aCompiledMethod sourceCode;
		selector: aCompiledMethod selector;
		yourself
]

{ #category : #installing }
EP2MMethod >> install [
	| remoteMethod compiledMethod |
	
	remoteMethod := self parent remote backend builder objectSpace
		crossCompiler
		compile: self sourceCode
		forClass: self methodClass
		inEnvironment: self parent remote backend builder.
	remoteMethod test.
	self remote: remoteMethod.
	^ remoteMethod
	"installMethods
	| methods |
	methods := (self methodBuilder methodsFromDefinition: self)
		sorted: [ :a :b | a selector < b selector ].
	methods do:
			[ :method | 
			method test.
			 ].
	self remote methodDictionary test."
]

{ #category : #calypso }
EP2MMethod >> isExtension [
	^ false
]

{ #category : #marking }
EP2MMethod >> markAsAccessed [
	self propertyNamed: self parent parent objectAccessedPropertyName put: true
]

{ #category : #accessing }
EP2MMethod >> methodClass [
	^ self parent
]

{ #category : #calypso }
EP2MMethod >> origin [
	^ self parent
]

{ #category : #accessing }
EP2MMethod >> package [
	^ self parent package
]

{ #category : #ast }
EP2MMethod >> parseTree [

	^(RBParser 
		parseMethod: self sourceCode 
		onError: [ :msg :pos | ^ nil ]) methodClass: self methodClass.

]

{ #category : #printing }
EP2MMethod >> printOn: aStream [
	self parent name
		ifNotNil: [ aStream
				nextPutAll: '"';
				nextPutAll: self parent name;
				nextPutAll: '>>' ].
	aStream print: self selector.
	aStream nextPutAll: '"'
]

{ #category : #calypso }
EP2MMethod >> protocol [

	| methodTags |
	
	methodTags := self tags.
	^	methodTags
		ifEmpty: [  self class asYetUnclassifiedProtocolName]
		ifNotEmpty: [ methodTags sorted first ]

]

{ #category : #calypso }
EP2MMethod >> pvtTagWith: aSymbol [ 
	tags add: aSymbol
]

{ #category : #accessing }
EP2MMethod >> remote: anEP2RemoteCompiledMethod [ 
	remote := anEP2RemoteCompiledMethod 
]

{ #category : #accessing }
EP2MMethod >> selector [
	^ selector asSymbol
]

{ #category : #accessing }
EP2MMethod >> selector: aString [ 
	selector := aString
]

{ #category : #accessing }
EP2MMethod >> sourceCode [

	^sourceCode
]

{ #category : #accessing }
EP2MMethod >> sourceCode: anObject [

	"ATTENTION: There is no check here if the selector is changed!"
	sourceCode := anObject asString
	
]

{ #category : #calypso }
EP2MMethod >> tagWith: aSymbol [
	self backend tagMethod: self with: aSymbol.
	self parent addMethodTag: aSymbol.
]

{ #category : #calypso }
EP2MMethod >> tags [
	"ToDo"
	^ #()
]

{ #category : #accessing }
EP2MMethod >> time: aDateAndTime [ 
	time := aDateAndTime 
]

{ #category : #'tonel repository' }
EP2MMethod >> writeIntoTonel [
	| snapshot |
	snapshot := self parent package  asMCSnapshot.
	
]
