Class {
	#name : #EP2RemoteUndefinedObject,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteUndefinedObject class >> layoutClass [
	^ EP2EmptyLayout
]

{ #category : #constants }
EP2RemoteUndefinedObject class >> modelInstSpec [
	^ 0
]

{ #category : #constants }
EP2RemoteUndefinedObject class >> modelInstVarNames [
	^ #()
]

{ #category : #'instance creation' }
EP2RemoteUndefinedObject class >> on: anEPMirror [ 
	^ self new
		mirror: anEPMirror;
		yourself
]

{ #category : #constants }
EP2RemoteUndefinedObject class >> role [ 
	^ 'UndefinedObject'
]

{ #category : #'converting local' }
EP2RemoteUndefinedObject >> asLocalLiteral [
	^ nil
]

{ #category : #'converting local' }
EP2RemoteUndefinedObject >> asRemoteNil [
	^ self
]

{ #category : #'converting local' }
EP2RemoteUndefinedObject >> asRemoteObjectCasted [
	^ self
]

{ #category : #printing }
EP2RemoteUndefinedObject >> printOn: aStream [
	^ aStream nextPutAll: '*nil*'
]
