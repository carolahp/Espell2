Class {
	#name : #EP2GlobalBinding,
	#superclass : #EP2LiteralBinding,
	#category : #'Espell2-Compiler-Bindings'
}

{ #category : #visiting }
EP2GlobalBinding >> accept: anEPASTInterpreter assign: anEPMirror inNode: aRBVariableNode [ 
	
	anEPASTInterpreter environment globalNamed: name put: anEPMirror
]

{ #category : #'from local to remote' }
EP2GlobalBinding >> asRemoteObjectInObjectSpace: anObjectSpace [ 
	 | binding |
	 binding := anObjectSpace systemDictionary associationAt: name asSymbol.
       "If we did not find a binding for the given global, it means that the global is not declared in the bootstrap.
       1) We then create an undeclared in the undeclared dictionary
       2) We return the new binding"
    ^ binding ifNil: [ 
  		self halt.             
		self haltIf: [ name ~= #Display ].
               objectSpace bootstrapInterpreter
                       evaluateCode: 'Undeclared at: undeclaredName put: nil.
                                                               Undeclared associationAt: undeclaredName'
                       withTemps: { 
                               'undeclaredName' -> (name asSymbol asLiteralInObjectSpace: anObjectSpace)
                       }.
               ]
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
	
	^ anEPASTInterpreter environment globalNamed: name
]

{ #category : #visiting }
EP2GlobalBinding >> value [ 
	^ objectSpace backend builder bootstrapEnvironmentAt: self name
]

{ #category : #visiting }
EP2GlobalBinding >> value: anObject [
	"we keep track in the local representation of the environment of the object space"
	self halt.
	"environment at: self name put: anObject.
	objectSpace environment addGlobal: self name pointingTo: anObject.

	^super value: anObject.	"
]
