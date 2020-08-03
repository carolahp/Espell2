Class {
	#name : #EP2RemoteBoolean,
	#superclass : #EP2RemoteEmptyObject,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteBoolean class >> remoteInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteBoolean class >> role [ 
	^ ''
]

{ #category : #testing }
EP2RemoteBoolean >> isTrueObject [
	self subclassResponsibility 
]
