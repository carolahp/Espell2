Class {
	#name : #MethodModel,
	#superclass : #ObjectModel,
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
MethodModel class >> asYetUnclassifiedProtocolName [

	^ 'as yet unclassified' asSymbol
]

{ #category : #calypso }
MethodModel >> argumentNames [
	^ self ast argumentNames
]

{ #category : #exporting }
MethodModel >> asMCDefinition [
	
	^ MCMethodDefinition 
		className: self parent name
		classIsMeta: false
		selector: self name
		category: 'as yet unclassified'
		timeStamp: ''
		source: self sourceCode
]

{ #category : #accessing }
MethodModel >> ast [
	"Answer my AST with semantic analysis. See #parseTree."
	
	^ self propertyNamed: #ast ifAbsentPut: [ self parseTree doSemanticAnalysisIn: self methodClass ]


]

{ #category : #calypso }
MethodModel >> astForStylingInCalypso [
	^ self ast
]

{ #category : #accessing }
MethodModel >> author: aString [ 
	author := aString
]

{ #category : #accessing }
MethodModel >> backend [ 
	^ self parent backend
]

{ #category : #calypso }
MethodModel >> calypsoEnvironmentType [
	^ClyMethod
]

{ #category : #initialization }
MethodModel >> extendWithMonticello: aMCMethodDefinition [
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
MethodModel >> hasSelector: aString specialSelectorIndex: anUndefinedObject [ 
	self halt.
	^ self ast sentMessages includes: selector
]

{ #category : #initialization }
MethodModel >> initialize [ 
	super initialize.
	tags := Set new
]

{ #category : #initialization }
MethodModel >> initializeWithLocal: aCompiledMethod [ 
	^ self 
		sourceCode: aCompiledMethod sourceCode;
		selector: aCompiledMethod selector;
		yourself
]

{ #category : #installing }
MethodModel >> install [
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
MethodModel >> isExtension [
	^ false
]

{ #category : #marking }
MethodModel >> markAsAccessed [
	self propertyNamed: self parent parent objectAccessedPropertyName put: true
]

{ #category : #accessing }
MethodModel >> methodClass [
	^ self parent
]

{ #category : #calypso }
MethodModel >> origin [
	^ self parent
]

{ #category : #accessing }
MethodModel >> package [
	^ self parent package
]

{ #category : #ast }
MethodModel >> parseTree [

	^(RBParser 
		parseMethod: self sourceCode 
		onError: [ :msg :pos | ^ nil ]) methodClass: self methodClass.

]

{ #category : #printing }
MethodModel >> printOn: aStream [
	self parent name
		ifNotNil: [ aStream
				nextPutAll: '"';
				nextPutAll: self parent name;
				nextPutAll: '>>' ].
	aStream print: self selector.
	aStream nextPutAll: '"'
]

{ #category : #calypso }
MethodModel >> protocol [

	| methodTags |
	
	methodTags := self tags.
	^	methodTags
		ifEmpty: [  self class asYetUnclassifiedProtocolName]
		ifNotEmpty: [ methodTags sorted first ]

]

{ #category : #calypso }
MethodModel >> pvtTagWith: aSymbol [ 
	tags add: aSymbol
]

{ #category : #accessing }
MethodModel >> remote: anEP2RemoteCompiledMethod [ 
	remote := anEP2RemoteCompiledMethod 
]

{ #category : #accessing }
MethodModel >> selector [
	^ selector asSymbol
]

{ #category : #accessing }
MethodModel >> selector: aString [ 
	selector := aString
]

{ #category : #accessing }
MethodModel >> sourceCode [

	^sourceCode
]

{ #category : #accessing }
MethodModel >> sourceCode: anObject [

	"ATTENTION: There is no check here if the selector is changed!"
	sourceCode := anObject asString
	
]

{ #category : #calypso }
MethodModel >> tagWith: aSymbol [
	self backend tagMethod: self with: aSymbol.
	self parent addMethodTag: aSymbol.
]

{ #category : #calypso }
MethodModel >> tags [
	"ToDo"
	^ #()
]

{ #category : #accessing }
MethodModel >> time: aDateAndTime [ 
	time := aDateAndTime 
]

{ #category : #'tonel repository' }
MethodModel >> writeIntoTonel [
	| snapshot |
	snapshot := self parent package  asMCSnapshot.
	
]