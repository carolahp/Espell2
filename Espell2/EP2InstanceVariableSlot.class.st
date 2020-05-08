Class {
	#name : #EP2InstanceVariableSlot,
	#superclass : #EP2IndexedSlot,
	#category : #'Espell2-Kernel-Slots'
}

{ #category : #'meta-object-protocol' }
EP2InstanceVariableSlot >> read: aRemoteObject [
	^ self backend object: aRemoteObject instVarAt: index
]

{ #category : #'meta-object-protocol' }
EP2InstanceVariableSlot >> write: aRemoteValue to: aRemoteObject [
	self backend 
		object: aRemoteObject
		instVarAt: index 
		put: aRemoteValue
]
