Class {
	#name : #GlobalSmalltalkAspect,
	#superclass : #PhAspect,
	#instVars : [
		'languageModelClass'
	],
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
GlobalSmalltalkAspect class >> for: aLanguageModelClass [
	^ self basicNew 
		modelClass: aLanguageModelClass; 
		initialize;
		yourself.
]

{ #category : #accessing }
GlobalSmalltalkAspect >> languageModelClass: aLanguagModelClass [ 
	languageModelClass := aLanguagModelClass
]
