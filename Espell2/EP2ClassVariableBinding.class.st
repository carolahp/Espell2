Class {
	#name : #EP2ClassVariableBinding,
	#superclass : #EP2LiteralBinding,
	#instVars : [
		'ownerName'
	],
	#category : #'Espell2-Compiler-Bindings'
}

{ #category : #public }
EP2ClassVariableBinding >> accept: anEPASTInterpreter assign: anEP2RemoteObject inNode: aRBGlobalNode [ 
	
	^ (anEPASTInterpreter environment classNamed: ownerName)
			classPool at: name put: anEP2RemoteObject
]

{ #category : #'from local to remote' }
EP2ClassVariableBinding >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [ 
	^ (self classNamed: ownerName)
			classPool bindingOf: name
]

{ #category : #testing }
EP2ClassVariableBinding >> isGlobalVariable [
	
	^ false
]

{ #category : #initialization }
EP2ClassVariableBinding >> name: aBindingName ownerName: anOwnerName objectSpace: anObjectSpace [
	^self 
		ownerName: anOwnerName;
	 	name: aBindingName;
	 	objectSpace: anObjectSpace;
		yourself.
]

{ #category : #accessing }
EP2ClassVariableBinding >> ownerName: aString [ 
	ownerName := aString
]
