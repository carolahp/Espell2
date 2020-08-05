Class {
	#name : #EP2RemoteTrue,
	#superclass : #EP2RemoteBoolean,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteTrue class >> role [ 
	^ 'True'
]

{ #category : #testing }
EP2RemoteTrue >> isTrueObject [
	^ true
]

{ #category : #printing }
EP2RemoteTrue >> printOn: aStream [
	^ aStream nextPutAll: '*true*'
]
