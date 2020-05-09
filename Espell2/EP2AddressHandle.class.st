"
I hold references to objects installed in the bootstrapped Object Memory, and which can be accessed only by their address in memory
"
Class {
	#name : #EP2AddressHandle,
	#superclass : #EP2InternalObjectHandle,
	#instVars : [
		'address'
	],
	#category : #'Espell2-LowLevel-mirrors'
}

{ #category : #comparing }
EP2AddressHandle >> = aHandle [

	^ self species = aHandle species
		and: [ self address == aHandle address ]
]

{ #category : #accessing }
EP2AddressHandle >> address [
	^ address
]

{ #category : #accessing }
EP2AddressHandle >> address: anInteger [ 
	address := anInteger
]

{ #category : #converting }
EP2AddressHandle >> asClassIndexHandle [

	| hash |
	hash := (backend rawHashOf: address).
	hash > 0 ifFalse: [ ^ self ].
	^ backend handleOnClassIndex: hash.
]

{ #category : #'accessing-header' }
EP2AddressHandle >> basicClassHandle [
	^ backend handleOnAddress: (backend classOf: self)
]

{ #category : #'accessing-header' }
EP2AddressHandle >> classIndex [ 
	^ backend objectMemory classIndexOf: self address  
]
