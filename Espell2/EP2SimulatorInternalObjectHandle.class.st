"
I hold references to objects installed in the bootstrapped Object Memory
"
Class {
	#name : #EP2SimulatorInternalObjectHandle,
	#superclass : #EP2SimulatorHandle,
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #comparing }
EP2SimulatorInternalObjectHandle >> = aHandle [

	^ self species = aHandle species
		and: [ self address == aHandle address ]
]

{ #category : #accessing }
EP2SimulatorInternalObjectHandle >> address [ 
	self subclassResponsibility 
]

{ #category : #converting }
EP2SimulatorInternalObjectHandle >> asSmallInteger [
	
	^ backend integerValueOf: self
]

{ #category : #'accessing-instVars' }
EP2SimulatorInternalObjectHandle >> instanceVariableAtIndex: anInteger [ 
	
	^ backend object: self address instVarAt: anInteger
]

{ #category : #'as yet unclassified' }
EP2SimulatorInternalObjectHandle >> isSmallInteger [
	^ backend isSmallInteger: self
]

{ #category : #'as yet unclassified' }
EP2SimulatorInternalObjectHandle >> species [

	^ EP2SimulatorInternalObjectHandle
]
