"
I am a system dictionary. I provide access to the system dictionary inside an object space.
"
Class {
	#name : #EP2SystemDictionary,
	#superclass : #Object,
	#instVars : [
		'systemDictionary',
		'objectSpace',
		'cache'
	],
	#category : #'Espell2-Image'
}

{ #category : #'as yet unclassified' }
EP2SystemDictionary class >> withSystemDictionary: aSystemDictionaryMirror [

	^ self new withSystemDictionary: aSystemDictionaryMirror; yourself
]

{ #category : #'accessing-classes' }
EP2SystemDictionary >> arrayClass [
	^ self classNamed: #Array
]

{ #category : #testing }
EP2SystemDictionary >> at: aString [ 
	
	cache at: aString ifPresent: [ :global | ^global ].
	^ objectSpace interpreter
			evaluateCode: 'systemDictionary at: key'
			withTemps: {
				'systemDictionary' -> systemDictionary.
				'key' -> (aString asSymbol asLiteralInObjectSpace: objectSpace) }
]

{ #category : #testing }
EP2SystemDictionary >> at: aString put: aValue [
	
	cache at: aString put: aValue.
	
	^ objectSpace interpreter
			evaluateCode: 'systemDictionary at: key put: aValue'
			withTemps: { 
				'systemDictionary' -> systemDictionary.
				'key' -> (aString asSymbol asLiteralInObjectSpace: objectSpace).
				'aValue' -> aValue }
]

{ #category : #binding }
EP2SystemDictionary >> bindingOf: aName [

	^ objectSpace interpreter
		evaluateCode: 'systemDictionary bindingOf: key'
		withTemps: { 
			'systemDictionary' -> systemDictionary.
			'key' -> (aName asSymbol asLiteralInObjectSpace: objectSpace) }
]

{ #category : #initialization }
EP2SystemDictionary >> buildCache [

	objectSpace backend classes do: [ :each |
		cache at: each className put: each ]
]

{ #category : #'accessing-classes' }
EP2SystemDictionary >> classNamed: aString [ 
	^ self environment bootstrapEnvironmentAt: aString
]

{ #category : #accessing }
EP2SystemDictionary >> environment [
	^ self objectSpace interpreter environment
]

{ #category : #accessing }
EP2SystemDictionary >> globalObjects [
	
	"We get the real system dictionary"
	| globalsArray |
	systemDictionary := self internalSystemDictionary.
	
	"We get the internal array"
	globalsArray := systemDictionary instanceVariableAtIndex: (self instanceVariableMapping dictionaryArrayIndex).
	
	"We collect the values"
	^ (1 to: globalsArray size) collect: [ :i | globalsArray at: i ]
]

{ #category : #testing }
EP2SystemDictionary >> includesGlobalNamed: aString [ 
	
	cache at: aString ifPresent: [ :global | ^ true ].
	^ (objectSpace interpreter
		evaluateCode: 'systemDictionary includesKey: key'
		withTemps: { 
			'systemDictionary' -> systemDictionary.
			'key' -> (aString asSymbol asLiteralInObjectSpace: objectSpace) })
			asBoolean
]

{ #category : #initialization }
EP2SystemDictionary >> initialize [

	super initialize.
	cache := Dictionary new.
]

{ #category : #initialization }
EP2SystemDictionary >> initializeWithObjectSpace: anObjectSpace [
	
	objectSpace := anObjectSpace
]

{ #category : #private }
EP2SystemDictionary >> internalSystemDictionary [
	
	^ objectSpace backend systemDictionary
]

{ #category : #accessing }
EP2SystemDictionary >> messageClass [
	^ self classNamed: #Message
]

{ #category : #accessing }
EP2SystemDictionary >> objectSpace [
	^ objectSpace
]

{ #category : #accessing }
EP2SystemDictionary >> objectSpace: anObjectSpace [ 
	objectSpace := anObjectSpace
]

{ #category : #testing }
EP2SystemDictionary >> size [
	
	^ (objectSpace interpreter
			evaluateCode: 'systemDictionary size'
			withTemps: { 'systemDictionary' -> systemDictionary }) asSmallInteger
]

{ #category : #initialization }
EP2SystemDictionary >> withSystemDictionary: aSystemDictionary [

	systemDictionary := aSystemDictionary
]
