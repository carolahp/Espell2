Class {
	#name : #EP2ContextLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'instance creation' }
EP2ContextLayout class >> defaultRemoteObjectClass [
	^ EP2RemoteContext
]

{ #category : #'instance creation' }
EP2ContextLayout class >> on: anEP2Mirror [
	^ self new 
		remote: anEP2Mirror;
		yourself
]

{ #category : #'gt-extension' }
EP2ContextLayout >> gtInspectorIn: composite [
	^ composite text
		title: self remote asRemoteContext asString;
		display: [ '*', self remote asRemoteContext asString, '*' ]
]

{ #category : #'gt-extension' }
EP2ContextLayout >> instanceVariableNamed: aString [ 
	^ (self remote mirror target basicRemoteClass slotNamed: aString) read: self 
]
