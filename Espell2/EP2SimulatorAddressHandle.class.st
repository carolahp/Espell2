"
I hold references to objects installed in the bootstrapped Object Memory, and which can be accessed only by their address in memory
"
Class {
	#name : #EP2SimulatorAddressHandle,
	#superclass : #EP2SimulatorInternalObjectHandle,
	#instVars : [
		'address'
	],
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #comparing }
EP2SimulatorAddressHandle >> = aHandle [

	^ self address == aHandle address
]

{ #category : #accessing }
EP2SimulatorAddressHandle >> address [
	^ address
]

{ #category : #accessing }
EP2SimulatorAddressHandle >> address: anInteger [ 
	address := anInteger
]

{ #category : #converting }
EP2SimulatorAddressHandle >> asClassIndexHandle [

	| hash |
	hash := (backend rawHashOf: address).
	hash > 0 ifFalse: [ ^ self ].
	^ backend handleOnClassIndex: hash.
]

{ #category : #'accessing-header' }
EP2SimulatorAddressHandle >> basicClassHandle [
	^ backend handleOnAddress: (backend classOf: self)
]

{ #category : #'accessing-header' }
EP2SimulatorAddressHandle >> classIndex [ 
	^ backend objectMemory classIndexOf: self address  
]
