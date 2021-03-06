Class {
	#name : #EP2RemoteMetaclass,
	#superclass : #EP2RemoteClass,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteMetaclass class >> role [ 
	^nil
]

{ #category : #accessing }
EP2RemoteMetaclass >> className [ 
	^ self asClassDefinition name
]

{ #category : #accessing }
EP2RemoteMetaclass >> classPool [ 
	^ self backend nilObject
]

{ #category : #'inst vars mapping' }
EP2RemoteMetaclass >> metaclassThisClassIndex [

	^ (self systemDefinition instanceVariableMapping metaclassThisClassIndex) ifNil: [ self class unmappedInstVarIndex ]
]

{ #category : #accessing }
EP2RemoteMetaclass >> soleInstance [.
	^ (self instanceVariableAtIndex: self metaclassThisClassIndex) asRemoteClass
]
