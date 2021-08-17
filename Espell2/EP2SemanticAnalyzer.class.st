Class {
	#name : #EP2SemanticAnalyzer,
	#superclass : #OCASTSemanticAnalyzer,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #variables }
EP2SemanticAnalyzer >> declareVariableNode: aVariableNode [
	| model modelClass |
	modelClass := aVariableNode methodOrBlockNode "this happens with pragma variables"
		ifNil: [ TempVariableModel ]
		ifNotNil: [ (compilationContext getClass methodDict
				at: aVariableNode methodNode selector) class tempVariableModel ].
	model := modelClass newFrom: aVariableNode inContext: compilationContext.		
	^ self declareVariableNode: aVariableNode as: model
]
