Class {
	#name : #EP2Environment,
	#superclass : #IdentityDictionary,
	#instVars : [
		'builder'
	],
	#category : #Espell2
}

{ #category : #accessing }
EP2Environment >> bindingOf: aSymbol [
	| result |
	result := (super bindingOf: aSymbol).
	"maybe aSymbol is the name of class that has not been installed" 
	result ifNil: [
			["we try loading the class in the system and retrieving its binding"
			self builder classNamed: aSymbol.
			result := super bindingOf: aSymbol] 
				on: PBClassDefinitionNotFound 
				do: [^ nil]].
	^ result 
]

{ #category : #accessing }
EP2Environment >> builder [
	^ builder
]

{ #category : #accessing }
EP2Environment >> builder: aPBImageBuilderGeneric [ 
	builder := aPBImageBuilderGeneric 

]
