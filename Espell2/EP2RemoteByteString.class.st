Class {
	#name : #EP2RemoteByteString,
	#superclass : #EP2RemoteString,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteByteString class >> modelInstSpec [
	^ 16
]

{ #category : #constants }
EP2RemoteByteString class >> role [ 
	^ 'ByteString'
]
