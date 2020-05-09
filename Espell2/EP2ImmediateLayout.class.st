Class {
	#name : #EP2ImmediateLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2ImmediateLayout class >> defaultRemoteObjectClass [
	^ EP2RemoteSmallInteger 
]

{ #category : #testing }
EP2ImmediateLayout >> isImmediateLayout [

	^ true
]

{ #category : #testing }
EP2ImmediateLayout >> layoutName [

	^ #ImmediateLayout
]
