Class {
	#name : #EP2RemoteCompiledMethod,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #'high-level-message' }
EP2RemoteCompiledMethod >> basicClass [
	^  self backend builder classNamed: #CompiledMethod
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

{ #category : #'accessing - literals' }
EP2RemoteCompiledMethod >> numberOfLiterals [
	"Answer the number of literals used by the receiver."
	^ self headerOfCompiledMethod bitAnd: 16r7FFF
]
