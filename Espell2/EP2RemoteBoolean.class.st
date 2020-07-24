Class {
	#name : #EP2RemoteBoolean,
	#superclass : #EP2RemoteEmptyObject,
	#category : #'Espell2-Kernel'
}

{ #category : #controlling }
EP2RemoteBoolean >> ifFalse: aBlockClosure [ 
	self subclassResponsibility 
]

{ #category : #controlling }
EP2RemoteBoolean >> ifTrue: aBlockClosure [ 
	self subclassResponsibility 
]
