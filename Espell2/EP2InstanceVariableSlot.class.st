Class {
	#name : #EP2InstanceVariableSlot,
	#superclass : #EP2IndexedSlot,
	#category : #'Espell2-Kernel-Slots'
}

{ #category : #testing }
EP2InstanceVariableSlot >> isInstanceVariableSlot [
	^ true
]

{ #category : #'meta-object-protocol' }
EP2InstanceVariableSlot >> read: aRemoteObject [
	^ (self backend object: aRemoteObject instVarAt: index) asRemoteObject
]

{ #category : #'as yet unclassified' }
EP2InstanceVariableSlot >> slotName [ 
	^ 'InstVarSlot'
]

{ #category : #'meta-object-protocol' }
EP2InstanceVariableSlot >> write: aRemoteValue to: aRemoteObject [
	self backend 
		object: aRemoteObject
		instVarAt: index 
		put: aRemoteValue
]
