Class {
	#name : #EP2SemanticAnalyzer,
	#superclass : #OCASTSemanticAnalyzer,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #variables }
EP2SemanticAnalyzer >> declareVariableNode: aVariableNode [
	| env varModel result |
	env := compilationContext environment.
	varModel := env tempVariableModel named: aVariableNode name parent: env.
	result := self declareVariableNode: aVariableNode as: varModel.
	varModel index: (scope tempVars indexOfKey: aVariableNode name).
	^ result
]
