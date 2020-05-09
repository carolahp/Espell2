Class {
	#name : #EP2RemoteNil,
	#superclass : #EP2RemoteEmptyObject,
	#category : #'Espell2-Kernel'
}

{ #category : #accessing }
EP2RemoteNil >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #printing }
EP2RemoteNil >> printOn: aStream [
	^ aStream nextPutAll: '*nil*'
]
