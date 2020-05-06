Class {
	#name : #EP2ObjectLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2ObjectLayout class >> on: anEP2Mirror [
	^ self new 
		mirror: anEP2Mirror;
		yourself
]
