Class {
	#name : #EP2RemoteString,
	#superclass : #EP2RemoteArrayedCollection,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteString class >> layoutClass [ 
	^ EP2FixedLayout 
]

{ #category : #constants }
EP2RemoteString class >> modelInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteString class >> role [ 
	^ 'String'
]

{ #category : #'from remote to local' }
EP2RemoteString >> asLocalByteString [
	^ self backend fromRemoteByteString: self mirror
]

{ #category : #'converting-local' }
EP2RemoteString >> asLocalLiteral [
	^ self asLocalByteString 
]

{ #category : #'converting-local' }
EP2RemoteString >> asLocalString [
	^ self backend fromRemoteByteString: self.
]

{ #category : #printing }
EP2RemoteString >> printOn: aStream [
	aStream nextPutAll: '*''';
		nextPutAll: self asLocalByteString;
		nextPutAll: '''*'
]
