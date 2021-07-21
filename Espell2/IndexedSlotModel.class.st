Class {
	#name : #IndexedSlotModel,
	#superclass : #SlotModel,
	#instVars : [
		'index'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #accessing }
IndexedSlotModel >> index [
	^ index
]

{ #category : #accessing }
IndexedSlotModel >> index: anInteger [ 
	index := anInteger
]

{ #category : #testing }
IndexedSlotModel >> isIndexedSlot [
	^ false
]

{ #category : #testing }
IndexedSlotModel >> printOn: aStream [
	aStream nextPutAll: objectName ,' => ', self slotName
]

{ #category : #accessing }
IndexedSlotModel >> read: aRemoteObject [
	
	^ self backend object: aRemoteObject at: index
]

{ #category : #testing }
IndexedSlotModel >> slotName [ 
	^ 'IndexedSlot'
]

{ #category : #testing }
IndexedSlotModel >> write: aRemoteValue to: aRemoteObject [
	self backend 
		object: aRemoteObject
		at: index 
		put: aRemoteValue
]
