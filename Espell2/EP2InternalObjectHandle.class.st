"
I hold references to objects installed in the bootstrapped Object Memory
"
Class {
	#name : #EP2InternalObjectHandle,
	#superclass : #EP2Handle,
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #comparing }
EP2InternalObjectHandle >> = aHandle [

	^ self species = aHandle species
		and: [ self address == aHandle address ]
]

{ #category : #accessing }
EP2InternalObjectHandle >> address [ 
	self subclassResponsibility 
]

{ #category : #converting }
EP2InternalObjectHandle >> asSmallInteger [
	
	^ backend integerValueOf: self
]

{ #category : #'accessing-instVars' }
EP2InternalObjectHandle >> instanceVariableAtIndex: anInteger [ 
	
	^ backend object: self address instVarAt: anInteger
]

{ #category : #'as yet unclassified' }
EP2InternalObjectHandle >> isSmallInteger [
	^ backend isSmallInteger: self
]

{ #category : #'as yet unclassified' }
EP2InternalObjectHandle >> species [

	^ EP2InternalObjectHandle
]
