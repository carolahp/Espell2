"
I am used by EP2Mirrors to hold the reference to the object they point at.
"
Class {
	#name : #EP2Handle,
	#superclass : #Object,
	#instVars : [
		'backend'
	],
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #accessing }
EP2Handle >> backend: anEP2SimulatorBackend [ 
	backend := anEP2SimulatorBackend
]

{ #category : #accessing }
EP2Handle >> isSmallInteger [ 
	self subclassResponsibility 
]

{ #category : #accessing }
EP2Handle >> species [ 
	self subclassResponsibility 
]
