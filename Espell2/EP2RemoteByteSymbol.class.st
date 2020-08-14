Class {
	#name : #EP2RemoteByteSymbol,
	#superclass : #EP2RemoteString,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteByteSymbol class >> layoutClass [ 
	^ EP2ByteLayout 
]

{ #category : #constants }
EP2RemoteByteSymbol class >> modelInstSpec [
	^ 16
]

{ #category : #constants }
EP2RemoteByteSymbol class >> role [ 
	^ 'ByteSymbol'
]
