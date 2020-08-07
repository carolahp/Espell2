Class {
	#name : #EP2MMethod,
	#superclass : #EP2MObject,
	#instVars : [
		'sourceCode',
		'selector'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'instance creation' }
EP2MMethod class >> newFrom: aCompiledMethod [
	self halt.
	^ self new 
		sourceCode: aCompiledMethod sourceCode
]

{ #category : #'instance creation' }
EP2MMethod class >> newFromLocal: aCompiledMethod [ 
	^ self new 
		sourceCode: aCompiledMethod sourceCode;
		selector: aCompiledMethod selector
		yourself
]

{ #category : #accessing }
EP2MMethod >> ast [
	"Answer my AST with semantic analysis. See #parseTree."
	
	^ self propertyNamed: #ast ifAbsentPut: [ self parseTree doSemanticAnalysisIn: self methodClass ]


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
