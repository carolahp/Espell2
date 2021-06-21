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

{ #category : #'layout mapping' }
EP2MCClassDefinition >> espell2LayoutType [
	^ (Dictionary
		newFrom:
			{(#compiledMethod -> EP2CompiledMethodLayout).
			(#bytes -> EP2ByteLayout).
			(#immediate -> EP2ImmediateLayout).
			(#words -> EP2WordLayout).
			(#week -> EP2WeakLayout).
			(#variable
				->
					(self instVarNames isEmpty
						ifTrue: EP2VariableLayout
						ifFalse: EP2VariableWithInstVarsLayout)).
			"#ephemeron -> EP2EphemeronLayout."
			(#normal -> EP2FixedLayout).
			(#weak -> EP2WeakLayout).
			(#empty -> EP2EmptyLayout)}) at: type
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
