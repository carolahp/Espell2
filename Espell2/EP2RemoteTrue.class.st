Class {
	#name : #EP2RemoteTrue,
	#superclass : #EP2RemoteEmptyObject,
	#category : #'Espell2-Kernel'
}

{ #category : #printing }
EP2RemoteTrue >> printOn: aStream [
	^ aStream nextPutAll: '*true*'
]
