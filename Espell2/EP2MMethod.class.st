Class {
	#name : #EP2MMethod,
	#superclass : #EP2MObject,
	#instVars : [
		'sourceCode',
		'selector',
		'author',
		'time'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'instance creation' }
EP2MMethod class >> newFrom: aCompiledMethod [
	self halt.
	^ self new 
		sourceCode: aCompiledMethod sourceCode
]

{ #category : #accessing }
EP2MMethod >> ast [
	"Answer my AST with semantic analysis. See #parseTree."
	
	^ self propertyNamed: #ast ifAbsentPut: [ self parseTree doSemanticAnalysisIn: self methodClass ]


]

{ #category : #accessing }
EP2MMethod >> author: aString [ 
	author := aString
]

{ #category : #initialization }
EP2MMethod >> initializeWithLocal: aCompiledMethod [ 
	^ self 
		sourceCode: aCompiledMethod sourceCode;
		selector: aCompiledMethod selector;
		yourself
]

{ #category : #initialization }
EP2MMethod >> initializeWithMonticello: aMCMethodDefinition [ 
	| mcDef |
	mcDef := aMCMethodDefinition.
	self sourceCode: mcDef source;
	 selector: mcDef selector";
	 author: (mcDef authorForStamp: mcDef timeStamp);
	 time: (mcDef timeForStamp: mcDef timeStamp)"
	
	"protocol := self parent ensureProtocolNamed: mcDef category asSymbol.
	self protocol: protocol"
]

{ #category : #marking }
EP2MMethod >> markAsAccessed [
	self propertyNamed: self parent parent objectAccessedPropertyName put: true
]

{ #category : #accessing }
EP2MMethod >> methodClass [
	^ self parent
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

{ #category : #accessing }
EP2MMethod >> selector [
	^ selector
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

{ #category : #accessing }
EP2MMethod >> time: aDateAndTime [ 
	time := aDateAndTime 
]
