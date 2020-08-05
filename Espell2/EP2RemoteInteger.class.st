Class {
	#name : #EP2RemoteInteger,
	#superclass : #EP2RemoteNumber,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteInteger class >> layoutClass [ 
	^ EP2EmptyLayout 
]

{ #category : #constants }
EP2RemoteInteger class >> modelInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteInteger class >> role [ 
	^ 'Integer'
]
