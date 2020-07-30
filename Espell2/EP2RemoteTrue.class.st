Class {
	#name : #EP2RemoteTrue,
	#superclass : #EP2RemoteBoolean,
	#category : #'Espell2-Kernel'
}

{ #category : #testing }
EP2RemoteTrue >> isTrueObject [
	^ true
]

{ #category : #accessing }
EP2RemoteTrue >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #printing }
EP2RemoteTrue >> printOn: aStream [
	^ aStream nextPutAll: '*true*'
]
