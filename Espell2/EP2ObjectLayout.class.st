Class {
	#name : #EP2ObjectLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2ObjectLayout class >> on: anEP2Mirror [
	^ self new 
		object: anEP2Mirror;
		yourself
]

{ #category : #'testing-types' }
EP2ObjectLayout >> isObjectLayout [

	^ true
]

{ #category : #accessing }
EP2ObjectLayout >> layoutName [

	^ #ObjectLayout
]
