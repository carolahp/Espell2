Class {
	#name : #EP2RemoteCharacter,
	#superclass : #EP2RemoteMagnitude,
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

{ #category : #accessing }
EP2RemoteCharacter >> at: index [ 
	self shouldNotImplement 
]

{ #category : #accessing }
EP2RemoteCharacter >> at: index put: value [
	self shouldNotImplement 
]

{ #category : #accessing }
EP2RemoteCharacter >> basicSize [
	^ 0
]

{ #category : #'accessing-instVars' }
EP2RemoteCharacter >> instanceVariableAtIndex: index [
	self shouldNotImplement 
]

{ #category : #'accessing-instVars' }
EP2RemoteCharacter >> instanceVariableAtIndex: index put: anObject [
	self shouldNotImplement 
]

{ #category : #'accessing-instVars' }
EP2RemoteCharacter >> instanceVariableNamed: aString [ 
	self shouldNotImplement 
]

{ #category : #'high-level-message' }
EP2RemoteCharacter >> printOn: aStream [
	aStream 
		nextPutAll: '*$';
		nextPutAll: self asLocalCharacter asString;
		nextPutAll: '*'
]
