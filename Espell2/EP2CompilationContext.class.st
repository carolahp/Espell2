Class {
	#name : #EP2CompilationContext,
	#superclass : #CompilationContext,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #accessing }
EP2CompilationContext >> semanticAnalyzerClass [
	^ semanticAnalyzerClass ifNil: [ semanticAnalyzerClass := EP2SemanticAnalyzer  ]
]
