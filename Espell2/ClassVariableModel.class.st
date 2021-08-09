Class {
	#name : #ClassVariableModel,
	#superclass : #GlobalModel,
	#category : #'Espell2-Metamodel-Variables'
}

{ #category : #hooks }
ClassVariableModel >> accept: anEPASTInterpreter assign: anEP2Remote inNode: aRBGlobalNode [ 
	self value: anEP2Remote 
]

{ #category : #'accessing-api' }
ClassVariableModel >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [
	^ (self language classWithRole: #Association) ensureRemote new
		key: self name;
		value: self value;
		yourself
]

{ #category : #testing }
ClassVariableModel >> isGlobalVariable [
	^ false
]

{ #category : #'accessing-api' }
ClassVariableModel >> value [ 
	^ remote ifNil: [ remote := self initialValue ]
]

{ #category : #value }
ClassVariableModel >> value: anEP2Remote [ 
	self assert: anEP2Remote isEP2Remote.
	self remote: anEP2Remote
]
