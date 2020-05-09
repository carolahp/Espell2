Class {
	#name : #EP2ObjectLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2ObjectLayout class >> on: anEP2Mirror [
	^ self new 
		remote: anEP2Mirror;
		yourself
]

{ #category : #testing }
EP2ObjectLayout >> isObjectLayout [

	^ true
]

{ #category : #testing }
EP2ObjectLayout >> layoutName [

	^ #ObjectLayout
]

{ #category : #testing }
EP2ObjectLayout >> slots [ 

	"only for API compatibility purposes"
	^ Array new
]
