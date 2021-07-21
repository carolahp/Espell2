Class {
	#name : #EP2ImmediateLayout,
	#superclass : #EP2ObjectLayout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'remote-objects-relationship' }
EP2ImmediateLayout class >> acceptsNewSlots [
	^ false
]

{ #category : #'remote-objects-relationship' }
EP2ImmediateLayout class >> defaultRemoteObjectClass [
	^ EP2RemoteSmallInteger 
]

{ #category : #'testing-types' }
EP2ImmediateLayout >> allInstVars [
	^ #()
]

{ #category : #'testing-types' }
EP2ImmediateLayout >> allVariables [
	^ #()
]

{ #category : #'gt-extension' }
EP2ImmediateLayout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite text
		title: self object asRemoteObjectCasted asString;
		display: #yourself
]

{ #category : #'accessing header' }
EP2ImmediateLayout >> instSpec [
	^ 7
]

{ #category : #'testing-types' }
EP2ImmediateLayout >> isImmediateLayout [

	^ true
]

{ #category : #accessing }
EP2ImmediateLayout >> layoutName [

	^ #ImmediateLayout
]

{ #category : #exporting }
EP2ImmediateLayout >> mcType [

	^ #immediate 
]
