Class {
	#name : #EP2RemoteAssociation,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'instance-variables-mapping' }
EP2RemoteAssociation >> associationKeyIndex [
	^ self systemDefinition instanceVariableMapping associationKeyIndex 
]

{ #category : #'instance-variables-mapping' }
EP2RemoteAssociation >> associationValueIndex [
	^ self systemDefinition instanceVariableMapping associationValueIndex 
]

{ #category : #'high-level-message' }
EP2RemoteAssociation >> key [
	^ self instanceVariableAtIndex: self associationKeyIndex
]

{ #category : #accessing }
EP2RemoteAssociation >> layoutClass [
	" generic layout "
	^ EP2FixedLayout
]

{ #category : #printing }
EP2RemoteAssociation >> printOn: aStream [
	self key printOn: aStream.
	aStream nextPutAll: ' -> '.
	self value printOn: aStream
]

{ #category : #'high-level-message' }
EP2RemoteAssociation >> value [
	^ self instanceVariableAtIndex: self associationValueIndex
]

{ #category : #'high-level-message' }
EP2RemoteAssociation >> value: anEP2RemoteObject [ 
	self 
		instanceVariableAtIndex: self associationKeyIndex
		put: anEP2RemoteObject  
]
