Class {
	#name : #EP2Environment,
	#superclass : #IdentityDictionary,
	#instVars : [
		'builder'
	],
	#category : #'Espell2-Backend'
}

{ #category : #'accessing classes' }
EP2Environment >> allClasses [
	^ self select: [ :item | item isRemoteClass ]
]

{ #category : #accessing }
EP2Environment >> bindingOf: aSymbol [
	^ builder languageDefinition bindingOf: aSymbol
]

{ #category : #accessing }
EP2Environment >> bootstrapEnvironmentAt: aString [ 

	self deprecated: 'use EP2GlobalBinding instead?'.
	^ self bindingOf: aString
]

{ #category : #accessing }
EP2Environment >> builder [
	^ builder
]

{ #category : #accessing }
EP2Environment >> builder: aPBImageBuilderGeneric [ 
	builder := aPBImageBuilderGeneric 

]

{ #category : #accessing }
EP2Environment >> classLoader [
	^ self builder classLoader
]

{ #category : #public }
EP2Environment >> classNamed: aSymbol [
	self deprecated: 'use (LanguageDefinition >> classNamed) and then ensure the remote is installed'.
	
	^ self builder classNamed: aSymbol
]

{ #category : #public }
EP2Environment >> globalNamed: aString put: aRemoteObject [ 
	self deprecated: 'Use (LanguageModel>>gobalVariableNamed:) setValue:'.
	builder bootstrapEnvironment at: aString put: aRemoteObject
]

{ #category : #globals }
EP2Environment >> setGlobal: aString value: anEP2Remote [ 

	self deprecated: 'Use (LanguageModel>>gobalVariableNamed:) setValue:'.
	self at: aString asSymbol put: anEP2Remote
]
