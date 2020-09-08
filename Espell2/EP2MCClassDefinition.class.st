Class {
	#name : #EP2MCClassDefinition,
	#superclass : #MCClassDefinition,
	#instVars : [
		'extraInstVarsDict'
	],
	#category : #'Espell2-Tonel'
}

{ #category : #'as yet unclassified' }
EP2MCClassDefinition >> extraInstVarNamed: key [
	^ self extraInstVarsDict at: key ifAbsent: nil
]

{ #category : #'as yet unclassified' }
EP2MCClassDefinition >> extraInstVarNamed: key put: value [ 
	self extraInstVarsDict at: key put: value
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
