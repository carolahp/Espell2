Class {
	#name : #EP2RemoteFalse,
	#superclass : #EP2RemoteTrue,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteFalse class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteFalse class >> role [ 
	^ 'False'
]

{ #category : #testing }
EP2RemoteFalse >> isTrueObject [
	^ false
]

{ #category : #printing }
EP2RemoteFalse >> printOn: aStream [
	^ aStream nextPutAll: '*false*'
]
