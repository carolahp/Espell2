Class {
	#name : #EP2RemoteUndefinedObject,
	#superclass : #EP2RemoteEmpty,
	#category : #'Espell2-Kernel'
}

{ #category : #'instance creation' }
EP2RemoteUndefinedObject class >> on: anEPMirror [ 
	^ self new
		mirror: anEPMirror;
		yourself
]

{ #category : #constants }
EP2RemoteUndefinedObject class >> role [ 
	^ #UndefinedObject
]

{ #category : #casting }
EP2RemoteUndefinedObject >> asCastedRemoteClass [
	^ self class
]

{ #category : #'converting local' }
EP2RemoteUndefinedObject >> asLocalByteString [
	^ nil
]

{ #category : #'converting local' }
EP2RemoteUndefinedObject >> asLocalLiteral [
	^ nil
]

{ #category : #'converting local' }
EP2RemoteUndefinedObject >> asSmallInteger [
	^ nil
]

{ #category : #printing }
EP2RemoteUndefinedObject >> printOn: aStream [
	^ aStream nextPutAll: '*nil*'
]
