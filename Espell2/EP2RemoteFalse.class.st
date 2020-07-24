Class {
	#name : #EP2RemoteFalse,
	#superclass : #EP2RemoteBoolean,
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2RemoteFalse >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #printing }
EP2RemoteFalse >> printOn: aStream [
	^ aStream nextPutAll: '*false*'
]
