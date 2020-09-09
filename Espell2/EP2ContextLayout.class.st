Class {
	#name : #EP2ContextLayout,
	#superclass : #EP2VariableWithInstVarsLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'instance creation' }
EP2ContextLayout class >> defaultRemoteObjectClass [
	^ EP2RemoteContext
]

{ #category : #'instance creation' }
EP2ContextLayout class >> on: anEP2Mirror [
	^ self new 
		object: anEP2Mirror;
		yourself
]

{ #category : #'gt-extension' }
EP2ContextLayout >> allVariables [
	^ (self object basicClass allSlots select: #isInstanceVariableSlot)
		collect: [ :slot | slot read: self object ]
]

{ #category : #'gt-extension' }
EP2ContextLayout >> gtInspectorIn: composite [
	^ composite text
		title: self object asRemoteContext asString;
		display: [ '*', self object asRemoteContext asString, '*' ]
]

{ #category : #'gt-extension' }
EP2ContextLayout >> instanceVariableNamed: aString [ 
	^ (self object mirror target basicRemoteClass slotNamed: aString) read: self 
]
