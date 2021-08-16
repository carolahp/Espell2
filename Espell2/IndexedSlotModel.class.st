Class {
	#name : #IndexedSlotModel,
	#superclass : #SlotModel,
	#instVars : [
		'index'
	],
	#category : #'Espell2-Metamodel-Variables'
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
	aStream
		nextPutAll: objectName;
		nextPutAll: ' => ';
		nextPutAll: self slotName
]

{ #category : #'meta object protocol' }
IndexedSlotModel >> read: aRemoteObject [
	
	^ self backend object: aRemoteObject at: index
]

{ #category : #testing }
IndexedSlotModel >> slotName [ 
	^ 'IndexedSlot'
]

{ #category : #'meta object protocol' }
IndexedSlotModel >> write: aRemoteValue to: aRemoteObject [
	self backend 
		object: aRemoteObject
		at: index 
		put: aRemoteValue
]
