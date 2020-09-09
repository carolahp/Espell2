Class {
	#name : #EP2MCClassDefinition,
	#superclass : #MCClassDefinition,
	#instVars : [
		'role',
		'extraInstVarsDict'
	],
	#category : #'Espell2-Tonel'
}

{ #category : #'as yet unclassified' }
EP2MCClassDefinition >> doesNotUnderstand: aMessage [
	| selector index result instVarName |
	selector := aMessage selector.
	index := selector indexOf: $:.
	[index > 0
		ifTrue: [ 
			"possibly a setter"
			selector size = index
				ifFalse: [ self error ]
				ifTrue: [ 
					instVarName := selector copyUpTo: $:.
					result := self extraInstVarNamed: instVarName put: (aMessage arguments at: 1) ] ]
		ifFalse: [ 
			"possibly a getter"
			result := self extraInstVarNamed: aMessage selector ].
	] on: Exception do: [ super doesNotUnderstand: aMessage ].
	^ result
]

{ #category : #'as yet unclassified' }
EP2MCClassDefinition >> extraInstVarNamed: key [
	^ self extraInstVarsDict at: key ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
EP2MCClassDefinition >> extraInstVarNamed: key put: value [ 
	self extraInstVarsDict at: key asSymbol put: value
]

{ #category : #accessing }
EP2MCClassDefinition >> extraInstVarsDict [
	^ extraInstVarsDict
]

{ #category : #initialization }
EP2MCClassDefinition >> initialize [ 
	super initialize.
	extraInstVarsDict := IdentityDictionary new
]

{ #category : #accessing }
EP2MCClassDefinition >> role [
	^ role
]

{ #category : #accessing }
EP2MCClassDefinition >> role: anObject [
	role := anObject
]

{ #category : #accessing }
EP2MCClassDefinition >> type: typeSymbol [ 
	type := typeSymbol asSymbol.
	
]
