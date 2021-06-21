Class {
	#name : #EP2BlockLayout,
	#superclass : #EP2ExternalLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'instance creation' }
EP2BlockLayout class >> acceptsNewSlots [ 
	^ true
]

{ #category : #'instance creation' }
EP2BlockLayout class >> on: anEP2Mirror [
	^ self new 
		object: anEP2Mirror;
		yourself
]

{ #category : #'gt-extension' }
EP2BlockLayout >> allInstVars [
	
	^ (self object target object basicClass allSlots)
		collect: [ :slot | self object target object instVarNamed: slot name ]
]

{ #category : #'gt-extension' }
EP2BlockLayout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite text
		title: self object asRemoteBlock asString;
		display: [ '*', self object asRemoteBlock sourceCode, '*' ]
]
