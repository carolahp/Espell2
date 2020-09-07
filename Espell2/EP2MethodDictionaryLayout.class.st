"
vairable sized with instance variables
"
Class {
	#name : #EP2MethodDictionaryLayout,
	#superclass : #EP2VariableWithInstVarsLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2MethodDictionaryLayout class >> defaultRemoteObjectClass [
	^ EP2RemoteMethodDictionary 
]

{ #category : #accessing }
EP2MethodDictionaryLayout >> basicAt: anIndex [
	
	^ (self backend 
		object: remote  
		at: anIndex)
]

{ #category : #accessing }
EP2MethodDictionaryLayout >> basicAt: index put: anObject [

	self backend object: self at: index put: anObject
]
