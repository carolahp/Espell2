Class {
	#name : #EP2RemoteCompiledMethod,
	#superclass : #EP2Remote,
	#category : #'Espell2-Kernel'
}

{ #category : #constants }
EP2RemoteCompiledMethod class >> layoutClass [
	^ EP2CompiledMethodLayout 
]

{ #category : #constants }
EP2RemoteCompiledMethod class >> modelInstSpec [
	^ 24
]

{ #category : #constants }
EP2RemoteCompiledMethod class >> role [ 
	^ 'CompiledMethod'
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> asRemoteCompiledMethod [
	^ self
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> asRemoteObjectCasted [
	^ self
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> byteAt: anIndex [
	^ self at: anIndex
]

{ #category : #'high-level-messages' }
EP2RemoteCompiledMethod >> byteAt: anInteger put: anEP2RemoteSmallInteger [ 
	^ self at: anInteger put: anEP2RemoteSmallInteger 
]

{ #category : #'as yet unclassified' }
EP2RemoteCompiledMethod >> bytecodes [
	| bytecodes |
	bytecodes := EP2RemoteByteArray newWithSize: 100 withBackend: self backend.
	self initialPC to: self endPC do: [:i | 
			bytecodes at:i put: (self byteAt: i) ].
	^ bytecodes asRemoteByteArray
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> bytecodes: someBytecodes [

	| start |
	start := self initialPC - 1.
	someBytecodes withIndexDo: [ :bytecode :index |
		self byteAt: start + index put: (bytecode asLiteralInObjectSpace: self backend).
	]
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> endPC [
	^(EP2MethodTrailer new method: self) endPC
]

{ #category : #'as yet unclassified' }
EP2RemoteCompiledMethod >> frameSize [
	(self header noMask: 16r20000)
		ifTrue: [^ 16 "SmallFrame"]
		ifFalse: [^ 56 "LargeFrame"]
]

{ #category : #'high-level-messages' }
EP2RemoteCompiledMethod >> gtInspectorRaw2In: composite [ 
	<gtInspectorPresentationOrder: 2>
	^ self layout gtInspectorRawIn: composite
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> header [
	^ (self objectAt: 1) target asSmallInteger
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

	^ self objectAt: anIndex + 1
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> literalAt: anIndex put: aLiteralMirror [

	self
		objectAt: anIndex + 1
		put: aLiteralMirror
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> literals [
	^(1 to: self numberOfLiterals) collect: [ :index | | literal |
		literal := self literalAt: index.
		literal asRemoteObject ]
]

{ #category : #'as yet unclassified' }
EP2RemoteCompiledMethod >> localBytecodes [
	
	^ ByteArray streamContents: [ :s |
		self initialPC to: self endPC do: [:i | 
			s nextPut: (self byteAt: i) asLocalSmallInteger ] ].
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> methodClass [
	| binding |
	binding := self literalAt: self numberOfLiterals.
	binding isNilObject ifTrue: [ ^nil ].
	^ binding asRemoteAssociation value asRemoteClass
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> numberOfArguments [
	"Answer the number of arguments the receiver takes."

	^ (self header bitShift: -24) bitAnd: 16r0F
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> numberOfLiterals [
	"Answer the number of literals used by the receiver."
	
	^ self backend numberOfLiteralsOf: self target
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> numberOfTemps [
	"Answer the number of temporary variables used by the receiver."
	
	^ (self header bitShift: -18) bitAnd: 16r3F
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> objectAt: anIndex [
	
	^ self backend compiledMethod: self objectAt: anIndex
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> objectAt: anIndex put: anObjectMirror [
	
	self backend compiledMethod: self objectAt: anIndex put: anObjectMirror
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> penultimateLiteral [

	| index |
	index := self numberOfLiterals - 1.
	^ index > 0
		ifTrue: [ self literalAt: index ]
		ifFalse: [ self backend nilObject ]
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> primitive [
	| primBits |
	primBits := self header bitAnd: 16r100001FF.
	
	^ (primBits bitAnd: 16r1FF) + (primBits bitShift: -19)

]

{ #category : #printing }
EP2RemoteCompiledMethod >> printOn: aStream [
	aStream 
		nextPutAll: '* >> ';
		nextPutAll: (self selector ifNil: ['--no selector--']);
		nextPutAll: '*'
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> remoteLiterals [
	^(1 to: self numberOfLiterals) collect: [ :index | self literalAt: index]
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> remoteSelector [
	| penultimateLiteral remoteSelector isSymbol |
	penultimateLiteral := self penultimateLiteral.
	penultimateLiteral isNilObject ifTrue: [ ^nil ].
	
	isSymbol := penultimateLiteral basicClass = self backend byteSymbolClass.
	remoteSelector := isSymbol ifTrue: [ penultimateLiteral ]
										ifFalse: [ "It is a method properties object whose second inst var has the selector"
														penultimateLiteral instanceVariableAtIndex: 2 ].
	^ remoteSelector asRemoteByteSymbol
]

{ #category : #'high-level-message' }
EP2RemoteCompiledMethod >> selector [
	^ self backend fromRemoteByteSymbol: self remoteSelector
]

{ #category : #accessing }
EP2RemoteCompiledMethod >> sourceCode [
	"^ backend objectSpace sourceCodeManager
		sourceCodeOfMethod: self
		ifAbsent: [ self decompile decompileString ]"

	(self methodClass asRGClass localMethods
		select: [ :rgmethod | rgmethod selector = self selector ]) 
		ifNotEmpty: [ :found | ^ found anyOne sourceCode ].
	^ nil
]

{ #category : #'vm-tests' }
EP2RemoteCompiledMethod >> test [ 
	self assert: self basicClass instSpec = EP2RemoteCompiledMethod modelInstSpec description: 'Incorrect format of compiled method: Wrong instSpec of its class'.
	self localBytecodes do: [ :bc | bc isInteger ].
	self literals do: [ :lit | lit test ]
]
