Class {
	#name : #EP2RemoteByteArray,
	#superclass : #EP2RemoteArrayedCollection,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteByteArray class >> modelInstSpec [
	^ 16
]

{ #category : #constants }
EP2RemoteByteArray class >> role [ 
	^'ByteArray'
]
