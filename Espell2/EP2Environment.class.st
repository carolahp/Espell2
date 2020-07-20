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
	| result |
	result := (super bindingOf: aSymbol).
	"maybe aSymbol is the name of class that has not been installed" 
	result ifNil: [
			["we try loading the class in the system and retrieving its binding"
			self classNamed: aSymbol.
			result := super bindingOf: aSymbol] 
				on: PBClassDefinitionNotFound 
				do: [ ^ nil]].
	^ EP2GlobalBinding new
			name: aSymbol; 
			objectSpace: builder objectSpace;
			yourself 
]

{ #category : #accessing }
EP2Environment >> bootstrapEnvironmentAt: aString [ 
self halt.
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
	^ self builder classNamed: aSymbol
]

{ #category : #public }
EP2Environment >> globalNamed: aString put: aRemoteObject [ 
	
	builder bootstrapEnvironment at: aString put: aRemoteObject
]
