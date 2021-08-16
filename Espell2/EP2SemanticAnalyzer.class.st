Class {
	#name : #EP2SemanticAnalyzer,
	#superclass : #OCASTSemanticAnalyzer,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #variables }
EP2SemanticAnalyzer >> declareVariableNode: aVariableNode [
	| varModel |
	(compilationContext getClass name endsWith: 'Dyn') ifTrue: [ self halt ].
	varModel := (aVariableNode parent isNil "this happens with pragma variables"
	 or: [ aVariableNode parent parent isBlock ]) "this happens with blocks"
		ifTrue: [ OCTempVariable new ]
		ifFalse: [ 
			
			((compilationContext getClass methodDict
				at: aVariableNode parent parent selector) class tempVariableModel
				named: aVariableNode name 
				parent: compilationContext environment)
				index: (aVariableNode temporaryVariables indexOf: aVariableNode name); 
				yourself ].
	
	^ self declareVariableNode: aVariableNode as: varModel
	"old"
	"
	env := compilationContext environment.
	varModel := (compilationContext getClass name beginsWith: 'DynamicTest')
		ifTrue: [ 
			(DynamicVariableModel named: aVariableNode name parent: env)
				index: (aVariableNode parent temporaries indexOf: aVariableNode);
				yourself ]
		ifFalse: [ TempVariableModel named: aVariableNode name parent: env ]."
	" Unmatched "
]
