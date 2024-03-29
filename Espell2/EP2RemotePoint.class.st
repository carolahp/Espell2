Class {
	#name : #EP2RemotePoint,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemotePoint class >> indexInClassTable [
	^ 54
]

{ #category : #constants }
EP2RemotePoint class >> indexInSpecialObjectsArray [
	^ 13
]

{ #category : #constants }
EP2RemotePoint class >> layoutClass [ 
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemotePoint class >> modelInstSpec [
	^ 1
]

{ #category : #constants }
EP2RemotePoint class >> modelInstVarNames [ 
	^ #(#x #y) 
]

{ #category : #constants }
EP2RemotePoint class >> role [ 
	^ #Point
]
