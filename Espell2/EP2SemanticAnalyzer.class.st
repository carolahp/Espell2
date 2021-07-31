Class {
	#name : #EP2SemanticAnalyzer,
	#superclass : #OCASTSemanticAnalyzer,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #variables }
EP2SemanticAnalyzer >> declareVariableNode: aVariableNode [
	| env varModel |
	
	^ super declareVariableNode: aVariableNode .	
	"old"
	"
	env := compilationContext environment.
	varModel := (compilationContext getClass name beginsWith: 'DynamicTest')
		ifTrue: [ 
			(DynamicVariableModel named: aVariableNode name parent: env)
				index: (aVariableNode parent temporaries indexOf: aVariableNode);
				yourself ]
		ifFalse: [ TempVariableModel named: aVariableNode name parent: env ]."
	
	"latest"
	"env := compilationContext environment.
	varModel := (compilationContext getClass methodDict at: aVariableNode parent parent selector) class tempVariableModel
		newFrom: aVariableNode.
	
	aVariableNode parent parent selector. 
	^ self declareVariableNode: aVariableNode as: varModel"
]
