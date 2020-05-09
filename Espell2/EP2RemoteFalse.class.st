Class {
	#name : #EP2RemoteFalse,
	#superclass : #EP2RemoteEmptyObject,
	#category : #'Espell2-Kernel'
}

{ #category : #printing }
EP2RemoteFalse >> printOn: aStream [
	^ aStream nextPutAll: '*false*'
]
