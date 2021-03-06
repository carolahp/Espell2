Class {
	#name : #EP2EmptyLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2EmptyLayout class >> on: anEP2Mirror [
	^ self new 
		remote: anEP2Mirror;
		yourself
]

{ #category : #'gt-extension' }
EP2EmptyLayout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite text
		title: self remote asRemoteObjectCasted asString
]

{ #category : #'testing-layouts' }
EP2EmptyLayout >> isEmptyLayout [

	^ true
]

{ #category : #accessing }
EP2EmptyLayout >> layoutName [

	^ #EmptyLayout
]

{ #category : #'vm-tests' }
EP2EmptyLayout >> testRemote [
	self assert: (self remote mirror backend basicSizeOf: self remote mirror) equals: 0.
	self assert: self remote basicClass format asLocalSmallInteger equals: 0
]
