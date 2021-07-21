Class {
	#name : #EP2GlobalBinding,
	#superclass : #EP2LiteralBinding,
	#category : #'Espell2-Compiler-Bindings'
}

{ #category : #visiting }
EP2GlobalBinding >> accept: anEPASTInterpreter assign: anEPMirror inNode: aRBVariableNode [
	self value: anEPMirror
]

{ #category : #visiting }
EP2GlobalBinding >> asGlobalOrClassModel [
	| languageModel |
	self flag: 'hardcoding access to globals, classes or packages is wrong, the metamodel should be more flexible'.
	languageModel := objectSpace backend systemDefinition.
	^ ((languageModel globalVariableNamed: name)
		ifNil: [ languageModel classNamed: name ifAbsent: [ nil ] ])
		ifNil: [ languageModel packageNamed: name ]
]

{ #category : #'from local to remote' }
EP2GlobalBinding >> asRemoteObjectInObjectSpace: anObjectSpace [
	| binding |
	binding := self value
		ifNotNil: [ :val | self name -> val ]
		ifNil: [ nil ].

	"If we did not find a binding for the given global, it means that the global is not declared in the bootstrap.
       1) We then create an undeclared in the undeclared dictionary
       2) We return the new binding"
	^ binding
		ifNil: [ self
				assert: binding isNotNil
				description:
					'A global named ' , name
						,
							' is referenced from a method, but it is not declared in the bootstrap'.
			objectSpace interpreter
				evaluateCode:
					'Undeclared at: undeclaredName put: nil.
                Undeclared associationAt: undeclaredName'
				withTemps:
					{('undeclaredName'
						-> (name asSymbol asLiteralInObjectSpace: anObjectSpace))} ]
]

{ #category : #visiting }
EP2GlobalBinding >> isGlobalClassNameBinding [
	
	"For bootstrapping purposes, all variables are writtable.
	We need to implement this method because Opal is not modular enough so far."
	
	^ false
]

{ #category : #visiting }
EP2GlobalBinding >> isGlobalVariable [
	
	^ true
]

{ #category : #visiting }
EP2GlobalBinding >> isGlobalVariableBinding [
	
	^ true
]

{ #category : #accessing }
EP2GlobalBinding >> key [
	^ self name
]

{ #category : #visiting }
EP2GlobalBinding >> readWith: anEPASTInterpreter inNode: aRBVariableNode [ 
	^ self value
]

{ #category : #visiting }
EP2GlobalBinding >> value [ 
	^ self asGlobalOrClassModel remote
]

{ #category : #visiting }
EP2GlobalBinding >> value: anObject [
	"we keep track in the local representation of the environment of the object space"

	self asGlobalOrClassModel setValue: anObject
]
