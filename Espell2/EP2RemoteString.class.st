Class {
	#name : #EP2RemoteString,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'from remote to local' }
EP2RemoteString >> asLocalByteString [
	^ self backend fromRemoteByteString: self mirror
]

{ #category : #accessing }
EP2RemoteString >> layoutClass [
	^ EP2VariableLayout
]

{ #category : #printing }
EP2RemoteString >> printOn: aStream [
	aStream nextPutAll: '*';
		nextPutAll: self asLocalByteString;
		nextPutAll: '*'
]
