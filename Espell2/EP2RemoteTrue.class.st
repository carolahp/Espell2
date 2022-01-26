Class {
	#name : #EP2RemoteTrue,
	#superclass : #EP2RemoteEmpty,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteTrue class >> role [ 
	^ #True
]

{ #category : #printing }
EP2RemoteTrue >> asRemoteObjectCasted [
	^ self
]

{ #category : #printing }
EP2RemoteTrue >> asRemoteTrue [
	^ self
]

{ #category : #testing }
EP2RemoteTrue >> isTrueObject [
	^ true
]

{ #category : #printing }
EP2RemoteTrue >> printOn: aStream [
	^ aStream nextPutAll: '*true*'
]
