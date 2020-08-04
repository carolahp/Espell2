Class {
	#name : #EP2RemoteCharacter,
	#superclass : #EP2RemoteImmediate,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteCharacter class >> modelInstSpec [
	^ 7
]

{ #category : #constants }
EP2RemoteCharacter class >> role [ 
	^ 'Character'
]

{ #category : #'high-level-message' }
EP2RemoteCharacter >> asLocalCharacter [
	^ self backend fromRemoteCharacter: self
]

{ #category : #'converting remote-to-local' }
EP2RemoteCharacter >> asLocalLiteral [
	 ^ self asLocalCharacter
]

{ #category : #'high-level-message' }
EP2RemoteCharacter >> printOn: aStream [
	aStream 
		nextPutAll: '*$';
		nextPutAll: self asLocalCharacter asString;
		nextPutAll: '*'
]
