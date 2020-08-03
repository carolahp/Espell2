Class {
	#name : #EP2RemoteFalse,
	#superclass : #EP2RemoteBoolean,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteFalse class >> role [ 
	^ 'False'
]

{ #category : #testing }
EP2RemoteFalse >> isTrueObject [
	^ false
]

{ #category : #accessing }
EP2RemoteFalse >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #printing }
EP2RemoteFalse >> printOn: aStream [
	^ aStream nextPutAll: '*false*'
]
