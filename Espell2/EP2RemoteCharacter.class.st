Class {
	#name : #EP2RemoteCharacter,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #'high-level-message' }
EP2RemoteCharacter >> asLocalCharacter [
	^ self backend fromRemoteCharacter: self
]

{ #category : #'high-level-message' }
EP2RemoteCharacter >> basicClass [
	^  self backend builder classNamed: #Character
]

{ #category : #'high-level-message' }
EP2RemoteCharacter >> printOn: aStream [
	aStream 
		nextPutAll: '*$';
		nextPutAll: self asLocalCharacter asString;
		nextPutAll: '*'
]
