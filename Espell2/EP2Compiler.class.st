Class {
	#name : #EP2Compiler,
	#superclass : #OpalCompiler,
	#category : #'Espell2-Backend-Compiler-Generic'
}

{ #category : #plugins }
EP2Compiler >> compilationContextClass [
	^compilationContextClass ifNil: [ EP2CompilationContext  ]
]
