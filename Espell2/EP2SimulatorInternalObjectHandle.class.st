Class {
	#name : #EP2SimulatorInternalObjectHandle,
	#superclass : #EP2SimulatorHandle,
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #'accessing-instVars' }
EP2SimulatorInternalObjectHandle >> instanceVariableAtIndex: anInteger [ 
	
	^ backend object: self instVarAt: anInteger
]

{ #category : #'as yet unclassified' }
EP2SimulatorInternalObjectHandle >> isSmallInteger [
	^ backend isSmallInteger: self
]
