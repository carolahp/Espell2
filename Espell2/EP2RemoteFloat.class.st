Class {
	#name : #EP2RemoteFloat,
	#superclass : #EP2RemoteNumber,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteFloat class >> indexInClassTable [
	^ 34
]

{ #category : #constants }
EP2RemoteFloat class >> indexInSpecialObjectsArray [
	^ 10
]

{ #category : #constants }
EP2RemoteFloat class >> layoutClass [ 
	^ EP2WordLayout 
]

{ #category : #constants }
EP2RemoteFloat class >> modelInstSpec [
	^ 10
]

{ #category : #constants }
EP2RemoteFloat class >> modelInstVarNames [
	^ #()
]

{ #category : #constants }
EP2RemoteFloat class >> role [ 
	^ #Float
]
