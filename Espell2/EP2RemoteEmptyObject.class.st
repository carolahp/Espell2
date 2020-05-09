Class {
	#name : #EP2RemoteEmptyObject,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #printing }
EP2RemoteEmptyObject >> printOn: aStream [
		
	self mirror isNilObject ifTrue:   [ ^ aStream nextPutAll:'aNil'  ].
	self mirror isTrueObject ifTrue:  [ ^ aStream nextPutAll: 'aTrue' ].
	self mirror isFalseObject ifTrue: [ ^ aStream nextPutAll: 'aFalse' ].
	super printOn: aStream
]
