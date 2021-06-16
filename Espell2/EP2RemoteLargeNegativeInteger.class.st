Class {
	#name : #EP2RemoteLargeNegativeInteger,
	#superclass : #EP2RemoteLargePositiveInteger,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteLargeNegativeInteger class >> indexInClassTable [
	^ 32
]

{ #category : #constants }
EP2RemoteLargeNegativeInteger class >> indexInSpecialObjectsArray [
	^ 43
]

{ #category : #constants }
EP2RemoteLargeNegativeInteger class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteLargeNegativeInteger class >> role [ 
	^ 'LargeNegativeInteger'
]
