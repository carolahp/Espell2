Class {
	#name : #EP2EmptyLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2EmptyLayout class >> on: anEP2Mirror [
	^ self new 
		mirror: anEP2Mirror;
		yourself
]

{ #category : #accessing }
EP2EmptyLayout >> isEmptyLayout [

	^ true
]

{ #category : #accessing }
EP2EmptyLayout >> layoutName [

	^ #EmptyLayout
]
