Class {
	#name : #EP2RemoteSmallInteger,
	#superclass : #Object,
	#instVars : [
		'mirror',
		'layout'
	],
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

{ #category : #accessing }
EP2RemoteSmallInteger >> mirror [
	^ mirror
]

{ #category : #accessing }
EP2RemoteSmallInteger >> mirror: anEP2Mirror [ 
	mirror := anEP2Mirror
]

{ #category : #printing }
EP2RemoteSmallInteger >> printOn: aStream [
	aStream nextPutAll: '*', self asLocalSmallInteger asString, '*'
]

{ #category : #accessing }
EP2RemoteSmallInteger >> target [ 
	^ mirror target
]
