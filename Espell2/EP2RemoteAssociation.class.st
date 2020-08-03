Class {
	#name : #EP2RemoteAssociation,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'instance creation' }
EP2RemoteAssociation class >> newWithBackend: anEP2Backend key: aString value: anInteger [ 
	^ (anEP2Backend basicNewOn: anEP2Backend associationClass) asRemoteAssociation
		key: (aString asRemoteObjectInObjectSpace: anEP2Backend objectSpace);
		value: (anInteger asRemoteObjectInObjectSpace: anEP2Backend objectSpace);
		yourself
]

{ #category : #constants }
EP2RemoteAssociation class >> remoteInstSpec [
	^ 1
]

{ #category : #'instance creation' }
EP2RemoteAssociation class >> role [ 
	^ 'Association'
]

{ #category : #'converting-local' }
EP2RemoteAssociation >> asLocalLiteral [
	self flag: 'different from Espell'.
	^ self key -> self value
]

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

{ #category : #'accessing-instVars' }
EP2RemoteAssociation >> key: aString [ 
	self instanceVariableAtIndex: self associationKeyIndex put: aString
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
		instanceVariableAtIndex: self associationValueIndex
		put: anEP2RemoteObject  
]
