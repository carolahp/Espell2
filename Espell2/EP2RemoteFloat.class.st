Class {
	#name : #EP2RemoteFloat,
	#superclass : #EP2RemoteNumber,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteFloat class >> layoutClass [ 
	^ EP2WordLayout 
]

{ #category : #constants }
EP2RemoteFloat class >> modelInstSpec [
	^ 10
]

{ #category : #constants }
EP2RemoteFloat class >> role [ 
	^ 'Float'
]
