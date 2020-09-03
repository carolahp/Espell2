Class {
	#name : #EP2BlockLayout,
	#superclass : #EP2ExternalLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'instance creation' }
EP2BlockLayout class >> on: anEP2Mirror [
	^ self new 
		remote: anEP2Mirror;
		yourself
]

{ #category : #'gt-extension' }
EP2BlockLayout >> allInstVars [
	
	^ (self remote target object basicClass allSlots)
		collect: [ :slot | self remote target object instVarNamed: slot name ]
]

{ #category : #'gt-extension' }
EP2BlockLayout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite text
		title: self remote asRemoteBlock asString;
		display: [ '*', self remote asRemoteBlock sourceCode, '*' ]
]
