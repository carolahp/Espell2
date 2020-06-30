Class {
	#name : #EP2GlobalBinding,
	#superclass : #EP2LiteralBinding,
	#category : #'Espell2-Compiler-Bindings'
}

{ #category : #'from local to remote' }
EP2GlobalBinding >> asRemoteObjectInObjectSpace: anObjectSpace [ 
	 | binding |
	self halt.
		self flag: 'candle implementation inserted in exeption handler'.
	    [binding := (EPRemoteEnvironment on: anObjectSpace systemDictionary) bindingOf: name asSymbol] on: Exception do: [ ^ anObjectSpace backend interpreter codeProvider createGlobalBindingFor: self ].
       "If we did not find a binding for the given global, it means that the global is not declared in the bootstrap.
       1) We then create an undeclared in the undeclared dictionary
       2) We return the new binding"
       ^ binding ifNil: [ 
               self haltIf: [ name ~= #Display ].
               objectSpace bootstrapInterpreter
                       evaluateCode: 'Undeclared at: undeclaredName put: nil.
                                                               Undeclared associationAt: undeclaredName'
                       withTemps: { 
                               'undeclaredName' -> (name asSymbol asLiteralInObjectSpace: anObjectSpace)
                       }.
               ]

]
