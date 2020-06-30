Class {
	#name : #EP2RemoteCompiledMethod,
	#superclass : #EP2RemoteObject,
	#category : #'Espell2-Kernel'
}

{ #category : #'high-level-message' }
EP2RemoteCompiledMethod >> basicClass [
	^  self backend builder classNamed: #CompiledMethod
]

{ #category : #'high-level-messages' }
EP2RemoteCompiledMethod >> byteAt: anInteger put: anEP2RemoteSmallInteger [ 
	^ self at: anInteger put: anEP2RemoteSmallInteger 
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> bytecodes: someBytecodes [

	| start |
	start := self initialPC - 1.
	someBytecodes withIndexDo: [ :bytecode :index |
		self byteAt: start + index put: (bytecode asLiteralInObjectSpace: self backend).
	]
]

{ #category : #'accessing - header' }
EP2RemoteCompiledMethod >> headerOfCompiledMethod [
	^ (self layout instanceVariableAtIndex: 1) asLocalSmallInteger 
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> initialPC [
	"Answer the program counter for the receiver's first bytecode."
	^ (self numberOfLiterals + 1) * self backend wordSize + 1
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> literalAt: anIndex [
	^ self at: anIndex + 1
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> literalAt: anInteger put: anRemoteObject [ 
	^ self at: anInteger + 1 put: anRemoteObject 
]

{ #category : #'accessing - literals' }
EP2RemoteCompiledMethod >> numberOfLiterals [
	"Answer the number of literals used by the receiver."
	^ self headerOfCompiledMethod bitAnd: 16r7FFF
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> penultimateLiteral [

	| index |
	index := self numberOfLiterals - 1.
	^ index > 0
		ifTrue: [ self literalAt: index ]
		ifFalse: [ self objectSpace nilObject ]
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> selector [
	| penultimateLiteral remoteSelector isSymbol |
	penultimateLiteral := self penultimateLiteral.
	penultimateLiteral isNilObject ifTrue: [ ^nil ].
	
	isSymbol := penultimateLiteral basicClass = self backend byteSymbolClass.
	remoteSelector := isSymbol ifTrue: [ penultimateLiteral ]
										ifFalse: [ "It is a method properties object whose second inst var has the selector"
														penultimateLiteral instanceVariableAtIndex: 2 ].
	^ self backend fromRemoteByteSymbol: remoteSelector
]
