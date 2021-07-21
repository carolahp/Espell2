Class {
	#name : #EP2SemanticAnalyzer,
	#superclass : #OCASTSemanticAnalyzer,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #variables }
EP2SemanticAnalyzer >> declareVariableNode: aVariableNode [
	| language varModel |
	language := compilationContext environment.
	varModel := language class tempVariableModel named: aVariableNode name parent: language.
	^self declareVariableNode: aVariableNode as: varModel
]
