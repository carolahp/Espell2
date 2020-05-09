Class {
	#name : #EP2RemoteTrue,
	#superclass : #EP2RemoteEmptyObject,
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2RemoteTrue >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #printing }
EP2RemoteTrue >> printOn: aStream [
	^ aStream nextPutAll: '*true*'
]
