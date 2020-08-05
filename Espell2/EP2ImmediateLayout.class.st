Class {
	#name : #EP2ImmediateLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2ImmediateLayout class >> defaultRemoteObjectClass [
	^ EP2RemoteSmallInteger 
]

{ #category : #'gt-extension' }
EP2ImmediateLayout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite text
		title: self remote asRemoteObjectCasted asString;
		display: #yourself
]

{ #category : #'testing-types' }
EP2ImmediateLayout >> isImmediateLayout [

	^ true
]

{ #category : #accessing }
EP2ImmediateLayout >> layoutName [

	^ #ImmediateLayout
]
