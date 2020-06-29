Class {
	#name : #EP2BlockLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'instance creation' }
EP2BlockLayout class >> on: anEP2Mirror [
	^ self new 
		remote: anEP2Mirror;
		yourself
]

{ #category : #'gt-extension' }
EP2BlockLayout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite text
		title: self remote asString;
		display: [ '*', self remote sourceCode, '*' ]
]
