Class {
	#name : #EP2SemanticAnalyzer,
	#superclass : #OCASTSemanticAnalyzer,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #variables }
EP2SemanticAnalyzer >> declareVariableNode: aVariableNode [
	| varModel |
	varModel := (aVariableNode methodOrBlockNode isNil "this happens with pragma variables"
	 or: [ aVariableNode methodOrBlockNode isBlock ]) "this happens with blocks"
		ifTrue: [ OCTempVariable new ]
		ifFalse: [ 
			((compilationContext getClass methodDict
				at: aVariableNode methodNode selector) class tempVariableModel
				named: aVariableNode name 
				parent: compilationContext environment)
				index: (aVariableNode temporaryVariables indexOf: aVariableNode name); 
				yourself ].
	^ self declareVariableNode: aVariableNode as: varModel
]
