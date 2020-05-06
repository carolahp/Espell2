Class {
	#name : #EP2PointerLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2PointerLayout class >> on: anEP2Mirror [
	^ self new 
		mirror: anEP2Mirror;
		yourself
]
