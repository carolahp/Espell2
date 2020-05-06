Class {
	#name : #EP2SimulatorHandle,
	#superclass : #Object,
	#instVars : [
		'backend'
	],
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #accessing }
EP2SimulatorHandle >> backend: anEP2SimulatorBackend [ 
	backend := anEP2SimulatorBackend
]

{ #category : #accessing }
EP2SimulatorHandle >> isSmallInteger [ 
	self subclassResponsibility 
]
