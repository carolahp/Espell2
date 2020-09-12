Class {
	#name : #EP2RemoteMetaclass,
	#superclass : #EP2RemoteClass,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteMetaclass class >> modelInstVarNames [
	"I inherit #(#superclass #methodDict #format) from RemoteClass"
	^ #()
]

{ #category : #constants }
EP2RemoteMetaclass class >> role [ 
	^nil
]

{ #category : #accessing }
EP2RemoteMetaclass >> asRemoteMetaclass [
	^ self
]

{ #category : #accessing }
EP2RemoteMetaclass >> className [
	^ self asClassDefinition
		ifNil: [ nil ]
		ifNotNil: [ :classDef | classDef name ]
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
