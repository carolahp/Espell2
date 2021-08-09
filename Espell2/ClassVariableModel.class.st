Class {
	#name : #ClassVariableModel,
	#superclass : #GlobalModel,
	#category : #'Espell2-Metamodel-Variables'
}

{ #category : #'accessing-api' }
ClassVariableModel >> asRemoteObjectInObjectSpace: anEP2ObjectSpace [
	^ (self language classWithRole: #Association) ensureRemote new
		key: self name;
		value: self value;
		yourself
]

{ #category : #'accessing-api' }
ClassVariableModel >> value [ 
	^ remote ifNil: [ remote := self initialValue ]
]
