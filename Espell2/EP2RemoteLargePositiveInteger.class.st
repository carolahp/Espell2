Class {
	#name : #EP2RemoteLargePositiveInteger,
	#superclass : #EP2RemoteInteger,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteLargePositiveInteger class >> indexInClassTable [
	^ 33
]

{ #category : #constants }
EP2RemoteLargePositiveInteger class >> indexInSpecialObjectsArray [
	^ 14
]

{ #category : #constants }
EP2RemoteLargePositiveInteger class >> layoutClass [ 
	^ EP2ByteLayout 
]

{ #category : #constants }
EP2RemoteLargePositiveInteger class >> modelInstSpec [
	^ 16
]

{ #category : #constants }
EP2RemoteLargePositiveInteger class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteLargePositiveInteger class >> role [ 
	^ 'LargePositiveInteger'
]
