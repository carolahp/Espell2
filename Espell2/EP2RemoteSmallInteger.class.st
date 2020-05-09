Class {
	#name : #EP2RemoteSmallInteger,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #'instance-creation' }
EP2RemoteSmallInteger class >> on: anEPMirror [ 
	
	^ self new
		mirror: anEPMirror;
		yourself
]

{ #category : #'instance creation' }
EP2RemoteSmallInteger class >> on: anEP2SimulatorAddressHandle from: anEP2Backend [ 
	^ self on: (EP2Mirror on: anEP2SimulatorAddressHandle from: anEP2Backend)
]

{ #category : #converting }
EP2RemoteSmallInteger >> asLocalSmallInteger [
	^ self mirror asLocalSmallInteger
]

{ #category : #converting }
EP2RemoteSmallInteger >> asRemoteSmallInteger [
	^ self 
]

{ #category : #'high-level-message' }
EP2RemoteSmallInteger >> basicClass [
	^ self backend classNamed: #SmallInteger
]

{ #category : #accessing }
EP2RemoteSmallInteger >> layoutClass [ 
	^ EP2ImmediateLayout 
]

{ #category : #printing }
EP2RemoteSmallInteger >> printOn: aStream [
	aStream nextPutAll: '*', self asLocalSmallInteger asString, '*'
]
