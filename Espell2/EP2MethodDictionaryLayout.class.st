"
vairable sized with instance variables
"
Class {
	#name : #EP2MethodDictionaryLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2MethodDictionaryLayout class >> defaultRemoteObjectClass [
	^ EP2RemoteMethodDictionary 
]
