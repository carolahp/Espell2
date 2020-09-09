Class {
	#name : #EP2UndeclaredBinding,
	#superclass : #EP2LiteralBinding,
	#category : #'Espell2-Compiler-Bindings'
}

{ #category : #'from local to remote' }
EP2UndeclaredBinding >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	| undeclared |
	undeclared := (objectSpace systemDictionary at: #Undeclared).
	undeclared at: name put: nil.
	^ undeclared associationAt: name
]

{ #category : #testing }
EP2UndeclaredBinding >> isTemp [
	
	^ false
]

{ #category : #testing }
EP2UndeclaredBinding >> isUndeclared [
	^ true
]

{ #category : #accessing }
EP2UndeclaredBinding >> isUninitialized [
	
	^ false
]

{ #category : #evaluation }
EP2UndeclaredBinding >> markWrite [
	self error: 'Can not compile a method that tries to write an undefined variable named: #', self name 
]

{ #category : #accessing }
EP2UndeclaredBinding >> semanticNodeClass [
	
	^ RBVariableNode
]
