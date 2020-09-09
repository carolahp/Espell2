Class {
	#name : #EP2EmptyLayout,
	#superclass : #EP2Layout,
	#category : #'Espell2-Kernel-Layouts'
}

{ #category : #'gt-inspector-extension' }
EP2EmptyLayout class >> on: anEP2Mirror [
	^ self new 
		object: anEP2Mirror;
		yourself
]

{ #category : #'gt-extension' }
EP2EmptyLayout >> gtInspectorIn: composite [
	"self remote isRoleMetaclass ifTrue: [ self haltOnce. ]."
	^ composite text
		title: self object asRemoteObjectCasted asString
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
	self assert: (self object mirror backend basicSizeOf: self object mirror) equals: 0.
	self assert: self object basicClass format asLocalSmallInteger equals: 0
]
