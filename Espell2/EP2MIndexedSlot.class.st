Class {
	#name : #EP2MIndexedSlot,
	#superclass : #EP2MSlot,
	#instVars : [
		'index'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #accessing }
EP2MIndexedSlot >> index [
	^ index
]

{ #category : #accessing }
EP2MIndexedSlot >> index: anInteger [ 
	index := anInteger
]

{ #category : #testing }
EP2MIndexedSlot >> isIndexedSlot [
	^ false
]

{ #category : #testing }
EP2MIndexedSlot >> printOn: aStream [
	aStream nextPutAll: objectName ,' => ', self slotName
]

{ #category : #accessing }
EP2MIndexedSlot >> read: aRemoteObject [
	
	^ self backend object: aRemoteObject at: index
]

{ #category : #testing }
EP2MIndexedSlot >> slotName [ 
	^ 'IndexedSlot'
]

{ #category : #testing }
EP2MIndexedSlot >> write: aRemoteValue to: aRemoteObject [
	self backend 
		object: aRemoteObject
		at: index 
		put: aRemoteValue
]
