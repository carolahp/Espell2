Class {
	#name : #EP2SemanticAnalyzer,
	#superclass : #OCASTSemanticAnalyzer,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #variables }
EP2SemanticAnalyzer >> declareVariableNode: aVariableNode [
	| env varModel |
	env := compilationContext environment.
	varModel := (compilationContext getClass name beginsWith: 'DynamicTest')
		ifTrue: [ 
			(DynamicVariableModel named: aVariableNode name parent: env)
				index: (aVariableNode parent temporaries indexOf: aVariableNode);
				yourself ]
		ifFalse: [ TempVariableModel named: aVariableNode name parent: env ].
	^ self declareVariableNode: aVariableNode as: varModel
]
