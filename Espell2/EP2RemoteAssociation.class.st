Class {
	#name : #EP2RemoteAssociation,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'instance-variables-mapping' }
EP2RemoteAssociation >> associationKeyIndex [
	^ self systemDefinition instanceVariableMapping associationKeyIndex 
]

{ #category : #accessing }
EP2RemoteAssociation >> layoutClass [
	" generic layout "
	^ EP2FixedLayout
]

{ #category : #'high-level-message' }
EP2RemoteAssociation >> value: anEP2RemoteObject [ 
	self 
		instanceVariableAtIndex: self associationKeyIndex
		put: anEP2RemoteObject  
]
