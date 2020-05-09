Class {
	#name : #EP2RemoteByteString,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'from remote to local' }
EP2RemoteByteString >> asLocalByteString [
	^ self backend fromRemoteByteString: self mirror
]

{ #category : #accessing }
EP2RemoteByteString >> layoutClass [
	^ EP2VariableLayout
]

{ #category : #printing }
EP2RemoteByteString >> printOn: aStream [
	aStream nextPutAll: self asLocalByteString
	
]
