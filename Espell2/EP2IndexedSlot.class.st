Class {
	#name : #EP2IndexedSlot,
	#superclass : #EP2Slot,
	#instVars : [
		'index'
	],
	#category : #'Espell2-Kernel-Slots'
}

{ #category : #testing }
EP2IndexedSlot >> isIndexedSlot [
	^ true
]

{ #category : #'meta-object-protocol' }
EP2IndexedSlot >> read: aRemoteObject [
	^ (self backend object: aRemoteObject at: index) asRemoteObject
]

{ #category : #'meta-object-protocol' }
EP2IndexedSlot >> slotName [ 
	^ 'IndexedSlot'
]

{ #category : #'meta-object-protocol' }
EP2IndexedSlot >> write: aRemoteValue to: aRemoteObject [
	self backend 
		object: aRemoteObject
		at: index 
		put: aRemoteValue
]
