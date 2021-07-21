Class {
	#name : #EP2IRMethod,
	#superclass : #IRMethod,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #compile }
EP2IRMethod >> additionalLiterals [ 	
	additionalLiterals addAll: (self tempMap associations collect: [:assoc | (#tempMap -> assoc) ]).
	^ additionalLiterals
]

{ #category : #compile }
EP2IRMethod >> compiledMethodWith: trailer model: aMethodModel [ 

	^compiledMethod 
		ifNil: [self generate: trailer model: aMethodModel ]
		ifNotNil: [compiledMethod]
]

{ #category : #compile }
EP2IRMethod >> generate: trailer model: aMethodModel [ 
	
	| irTranslator |
   irTranslator := IRTranslatorV2 context: compilationContext trailer: trailer.
	irTranslator 
		visitNode: self;
		pragmas: pragmas.
	compiledMethod := irTranslator compiledMethod.
	self sourceNode 
		ifNotNil: [ 
			compiledMethod classBinding: self sourceNode methodClass binding.
			compiledMethod selector: self sourceNode selector ]
		ifNil: [ 
			compiledMethod classBinding: UndefinedObject binding.
			compiledMethod selector: #UndefinedMethod ].
	^ compiledMethod
]
