Class {
	#name : #EP2RemoteEmptyObject,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'instance creation' }
EP2RemoteEmptyObject class >> on: anEPMirror [
	
	^ self new
		mirror: anEPMirror;
		yourself
]
