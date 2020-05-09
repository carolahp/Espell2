Class {
	#name : #EP2InstanceVariableSlot,
	#superclass : #EP2IndexedSlot,
	#category : #'Espell2-Kernel-Slots'
}

{ #category : #testint }
EP2InstanceVariableSlot >> isInstVarSlot [
]

{ #category : #'meta-object-protocol' }
EP2InstanceVariableSlot >> read: aRemoteObject [
	^ self backend object: aRemoteObject instVarAt: index
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
