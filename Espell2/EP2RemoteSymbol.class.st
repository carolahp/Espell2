Class {
	#name : #EP2RemoteSymbol,
	#superclass : #EP2RemoteString,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteSymbol class >> modelInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteSymbol class >> role [ 
	^ 'Symbol'
]

{ #category : #accessing }
EP2RemoteSymbol >> layoutClass [
	^ EP2ByteLayout 
]
