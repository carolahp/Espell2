Class {
	#name : #UndeclaredVariableModel,
	#superclass : #LiteralVariableModel,
	#category : #'Espell2-Metamodel-Variables'
}

{ #category : #'instance creation' }
UndeclaredVariableModel class >> newFrom: aRBVariableNode inContext: anEP2CompilationContext withAnalyzer: anEP2SemanticAnalyzer [
	EP2UndeclaredBindingError
		signal:
			'Can not compile a method that references an undefined variable named: #'
				, aRBVariableNode name
		withTag: aRBVariableNode name
	"^ EP2UndeclaredBinding new
		name: aRBVariableNode name;
		objectSpace: anEP2CompilationContext environment objectSpace;
		yourself"
]
