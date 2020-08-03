Class {
	#name : #EP2RemoteUndefinedObject,
	#superclass : #EP2RemoteEmptyObject,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteUndefinedObject class >> format [ 
	^ 0
]

{ #category : #constants }
EP2RemoteUndefinedObject class >> remoteInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteUndefinedObject class >> role [ 
	^ 'UndefinedObject'
]

{ #category : #accessing }
EP2RemoteUndefinedObject >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #printing }
EP2RemoteUndefinedObject >> printOn: aStream [
	^ aStream nextPutAll: '*nil*'
]
