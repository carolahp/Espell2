Class {
	#name : #EP2EmptyLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2EmptyLayout class >> on: anEP2Mirror [
	^ self new 
		mirror: anEP2Mirror;
		yourself
]
