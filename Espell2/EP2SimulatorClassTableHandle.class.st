Class {
	#name : #EP2SimulatorClassTableHandle,
	#superclass : #EP2SimulatorInternalObjectHandle,
	#instVars : [
		'classIndex'
	],
	#category : #Espell2
}

{ #category : #accessing }
EP2SimulatorClassTableHandle >> address [

	^ backend classAtIndex: classIndex
]

{ #category : #converting }
EP2SimulatorClassTableHandle >> asClassIndexHandle [
	^ self
]

{ #category : #'as yet unclassified' }
EP2SimulatorClassTableHandle >> backend: anEP2Backend [ 
	backend := anEP2Backend 

]

{ #category : #'accessing-mirror' }
EP2SimulatorClassTableHandle >> basicClassHandle [
	
	^ backend handleOnAddress: (backend classOf: self)
]

{ #category : #accessing }
EP2SimulatorClassTableHandle >> classIndex: anInteger [ 
	classIndex := anInteger 

]
