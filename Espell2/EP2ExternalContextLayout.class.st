Class {
	#name : #EP2ExternalContextLayout,
	#superclass : #EP2ExternalLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'accessing - slots' }
EP2ExternalContextLayout >> allInstVars [
	
	^ (self object target object basicClass allSlots)
		collect: [ :slot | self object target object instVarNamed: slot name ]
]

{ #category : #'accessing - slots' }
EP2ExternalContextLayout >> gtInspectorIn: composite [
	^ composite text
		title: self object asRemoteContext asString;
		display: [ '*', self object asRemoteContext asString , '*' ]
]
