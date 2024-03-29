Class {
	#name : #EP2IndexedSlot,
	#superclass : #EP2Slot,
	#instVars : [
		'index'
	],
	#category : #'Espell2-Kernel-Slots'
}

{ #category : #accessing }
EP2IndexedSlot >> index [
	^ index
]

{ #category : #accessing }
EP2IndexedSlot >> index: anInteger [ 
	index := anInteger 
]

{ #category : #testing }
EP2IndexedSlot >> isIndexedSlot [
	^ true
]

{ #category : #printing }
EP2IndexedSlot >> printOn: aStream [
	aStream nextPutAll: name ,' => ', self slotName
]

{ #category : #'meta-object-protocol' }
EP2IndexedSlot >> read: aRemoteObject [
	
	^ self backend object: aRemoteObject at: index
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
