Class {
	#name : #EP2Backend,
	#superclass : #Object,
	#instVars : [
		'simulator',
		'systemDefinition',
		'objectSpace',
		'extraRoots',
		'byteSymbolClass',
		'associationClass',
		'aSymbolTableClass'
	],
	#category : #'Espell2-Backend'
}

{ #category : #'instance-creation' }
EP2Backend class >> for32Bit [

	^ self withOptions: #(#ObjectMemory #Spur32BitMemoryManager)
]

{ #category : #'instance-creation' }
EP2Backend class >> simulator: aSimulator [
	
	^ self new
		simulator: aSimulator;
		yourself
]

{ #category : #'instance-creation' }
EP2Backend class >> withOptions: options [

	| simulator |
	simulator := StackInterpreterSimulator newWithOptions: options.
	simulator desiredNumStackPages: 8.
	simulator instVarNamed: 'assertVEPAES' put: false.
	simulator initStackPages.
	^ self simulator: simulator
]

{ #category : #accessing }
EP2Backend >> addExtraRoot: anEP2RemoteClass [ 

	extraRoots add: anEP2RemoteClass
]

{ #category : #'accessing-special classes' }
EP2Backend >> arrayClass [
	"The Array class in special objects arrays.
	Smalltalk specialObjectsArray indexOf: Array"
	^ (self specialObjectsArray at: 8) asRemoteClass
]

{ #category : #'accessing-special classes' }
EP2Backend >> arrayClass: anEP2RemoteClass [ 
	"The Array class in special objects arrays.
	Smalltalk specialObjectsArray indexOf: Array"
	self specialObjectsArray at: 8 put: anEP2RemoteClass.
	
	self installClass: anEP2RemoteClass inClassTableIndex: 51.
	
	"Array is a special class that resides in the first page of the class table.
	Array is duplicated in the special class index 16, that can also be obtained by querying the memory manager as follows:
	
		self objectMemory arrayClassIndexPun.
		
	Usually, a class hash must be the same as the class index in the class table. But, since the class is in two different positions, one of them does not hold that invariant.
	To install the class in the table in both positions, we use an Unchecked version of the method that contains no assertions of that invariant."
	self objectMemory classAtIndex: self objectMemory arrayClassIndexPun putUnchecked: anEP2RemoteClass target address.
]

{ #category : #'accessing-special classes' }
EP2Backend >> associationClass: anEP2RemoteClass [ 
	associationClass := anEP2RemoteClass
]

{ #category : #hash }
EP2Backend >> basicIdentityHashOf: anEP2Mirror [ 
	^ self objectMemory hashBitsOf: anEP2Mirror target address
]

{ #category : #'creating-stub-instances' }
EP2Backend >> basicNewOn: aRemoteClass [
	
	| newOop newObject |
	newOop := self objectMemory instantiateClass: aRemoteClass target address.
	self assert: newOop notNil.
	
	newObject := (self mirrorOnAddress: newOop) asRemoteStub.
	1 to: aRemoteClass instanceFixedSize do: [ :index |
		newObject instanceVariableAtIndex: index put: self nilObject.
	].
	aRemoteClass isBitsClass ifFalse: [
		1 to: newObject size do: [ :index |
			newObject at: index put: self nilObject.
		].
	].
	^ newObject
]

{ #category : #'creating-stub-instances' }
EP2Backend >> basicNewOn: aRemoteClass withSize: aSize [ 
	| newOop newObject |
	newOop := self objectMemory instantiateClass: aRemoteClass target address indexableSize: aSize.
	self assert: newOop notNil.
	
	newObject := (self mirrorOnAddress: newOop) asRemoteObject.
	1 to: aRemoteClass instanceFixedSize do: [ :index |
		newObject instanceVariableAtIndex: index put: self nilObject.
	].
	aRemoteClass isBitsClass ifFalse: [
		1 to: newObject size do: [ :index |
			newObject at: index put: self nilObject.
		].
	].
	^ newObject
]

{ #category : #'querying-objects' }
EP2Backend >> basicSizeOf: anEPRemoteObject [
	anEPRemoteObject isSmallInteger ifTrue: [ ^ 0 ].
	^ self simulator uncheckedStSizeOf: anEPRemoteObject target address
]

{ #category : #'accessing-special classes' }
EP2Backend >> blockClass: anEP2RemoteClass [ 

	"The Point class in most special objects arrays.
	Smalltalk specialObjectsArray indexOf: BlockClosure"
	self specialObjectsArray at: 37 put: anEP2RemoteClass.
	self installClass: anEP2RemoteClass inClassTableIndex: 37
]

{ #category : #accessing }
EP2Backend >> builder [ 
	^ self objectSpace interpreter codeProvider
]

{ #category : #'accessing-special classes' }
EP2Backend >> byteArrayClass: anEP2RemoteClass [ 

	"The twenty-seventh special object.
	Smalltalk specialObjectsArray indexOf: ByteArray"
	self specialObjectsArray at: 27 put: anEP2RemoteClass.
	self installClass: anEP2RemoteClass inClassTableIndex: 50.
]

{ #category : #'accessing-special classes' }
EP2Backend >> byteStringClass: anEP2RemoteClass [ 
	"The seventh special object.
	Smalltalk specialObjectsArray indexOf: ByteString"
	self specialObjectsArray at: 7 put: anEP2RemoteClass.
	self objectMemory setHashBitsOf: anEP2RemoteClass target address to: 52.
	self objectMemory classAtIndex: 52 putUnchecked: anEP2RemoteClass target address.
	anEP2RemoteClass target: anEP2RemoteClass target asClassIndexHandle.
]

{ #category : #'accessing-special classes' }
EP2Backend >> byteSymbolClass [
	^ byteSymbolClass
]

{ #category : #'accessing-special classes' }
EP2Backend >> byteSymbolClass: aClass [
	
	byteSymbolClass := aClass
]

{ #category : #'accessing-special classes' }
EP2Backend >> characterClass: aClass [ 
	"The twentieth special object.
	Smalltalk specialObjectsArray indexOf: Character"
	self specialObjectsArray at: 20 put: aClass.
	self objectMemory setHashBitsOf: aClass target address to: 2.
	self objectMemory classAtIndex: 2 putUnchecked: aClass target address.
	aClass target: aClass target asClassIndexHandle.
]

{ #category : #'accessing-class table' }
EP2Backend >> classAtIndex: anInteger [ 
	^ simulator objectMemory classAtIndex: anInteger
]

{ #category : #'modifying-objects' }
EP2Backend >> classHandle: handleFrom setTo: handleTo [ 
	self objectMemory changeClassOf: handleFrom address to: handleTo address
]

{ #category : #'querying-objects' }
EP2Backend >> classOf: anEP2SimulatorAddressHandle [
	^ self objectMemory fetchClassOf: anEP2SimulatorAddressHandle address
]

{ #category : #'querying-objects' }
EP2Backend >> compactClassIndexOf: anEP2RemoteClass [ 
	
	"All classes in Spur are compact, which also means that Spur has no compact classes"
	^ 0
]

{ #category : #'accessing-special classes' }
EP2Backend >> contextClass: anEP2RemoteClass [ 
	"The method Comtext class in most special objects arrays.
	Smalltalk specialObjectsArray indexOf: Context"
	self specialObjectsArray at: 11 put: anEP2RemoteClass. 
	self installClass: anEP2RemoteClass inClassTableIndex: 36
]

{ #category : #'creating-stub-instances' }
EP2Backend >> createObjectWithFormat: classFormat withSize: aSize classIndex: classIndex [
	
	| oop |
	oop := aSize = 0 ifTrue: [ 
		simulator objectMemory 
			newBootstrapInstanceFromClassFormat: classFormat
			classIndex: classIndex.
	] ifFalse: [ 
		simulator objectMemory 
			newBootstrapInstanceFromClassFormat: classFormat
			indexableSize: aSize
			classIndex: classIndex.
	].
	^ self mirrorOnAddress: oop.
]

{ #category : #'executing primitives' }
EP2Backend >> dispatchFunctionPointer: function [
	^ [ self simulator dispatchFunctionPointer: function ]
		on: Error
		do: [ | returnValue |
			returnValue := self interpreter
				evaluateCode: '''' , (self alternativePrimitivesResult at: function) asString , ''''.
			self simulator push: returnValue target address ]
]

{ #category : #'executing primitives' }
EP2Backend >> executePrimitiveMethod: aMethod on: receiver withArguments: aCollection [ 

	| returnValue |
	self simulator internalizeIPandSP.
	self simulator externalizeIPandSP.
	self simulator initPrimCall.
	self simulator argumentCount: aCollection size.
	self simulator push: receiver target address.
	aCollection do: [ :each |
		self simulator push: each target address.
	].

	
	^ [
		aMethod isNamedPrimitive
			ifTrue: [ | pragma function pluginName addr |
				pragma := aMethod pragmas detect: #isPrimitive.
				function := pragma arguments first value.
				pluginName := pragma arguments second value.
				addr := self simulator
					ioLoadFunction: function
					From: pluginName
					AccessorDepthInto: (CPluggableAccessor new
						setObject: nil;
						atBlock: [ :obj :idx | ]
						atPutBlock: [:obj :idx :val| ];
						yourself).
				self simulator callExternalPrimitive: addr.
				self simulator maybeRetryFailureDueToForwarding: 117.
				
				self simulator primitiveFailureCode > 0 ifTrue: [ 
					self halt.
					^ EP2PrimitiveFailed new code: self simulator primitiveFailureCode ].
				
				returnValue := self simulator stackTop.
				self simulator pop: 1.
				^ EP2PrimitiveSuccess new value: (self mirrorOnAddress: returnValue) 
			]
			ifFalse: [ | function |
				function := self simulator functionPointerFor: aMethod primitive inClass: nil.
				function = 0 ifTrue: [ ^ EPPrimitiveFailed new ].
				self simulator primitiveFunctionPointer: function.
				self dispatchFunctionPointer: function.
				self simulator maybeRetryFailureDueToForwarding: aMethod primitive.
			].
			self simulator primitiveFailureCode > 0 ifTrue: [ 
				^ EP2PrimitiveFailed new code: self simulator primitiveFailureCode ].
			
			returnValue := self simulator stackTop.
			self simulator pop: 1.
			^ EP2PrimitiveSuccess new value: (self mirrorOnAddress: returnValue)
		] ensure: [ 
			"We pop extra things..."
			self simulator pop: (((self simulator stackPointer - self simulator framePointer) + (self simulator objectMemory wordSize * 4)) min: 0)  abs / self simulator objectMemory wordSize.
			self assert: self stackIsEmpty.
			"Recursive xeq affects primErrorCode"
			self simulator initPrimCall.
			self simulator internalizeIPandSP].
]

{ #category : #'accessing-special objects' }
EP2Backend >> falseObject [
	
	"The first special object."
	^ (self mirrorOnAddress: simulator objectMemory falseObject) asRemoteEmptyObject 
]

{ #category : #'accessing-special objects' }
EP2Backend >> falseObject: anEP2Mirror [
	"The first special object.
	Smalltalk specialObjectsArray indexOf: nil"

	"^ self specialObjectsArray at: 1 put: anEPMirror"

	self specialObjectsArray
		ifNotNil: [ :soa | 
			self  
				object: soa
				at: 2 
				put: anEP2Mirror ].
	simulator objectMemory falseObject: anEP2Mirror target address
]

{ #category : #'accessing-special classes' }
EP2Backend >> floatClass: anEP2RemoteClass [ 
	"The tenth special object.
	Smalltalk specialObjectsArray indexOf: Float"
	self specialObjectsArray at: 10 put: anEP2RemoteClass.
	self installClass: anEP2RemoteClass inClassTableIndex: 34
]

{ #category : #initializing }
EP2Backend >> forBootstrap [

	self objectMemory
		allocateMemoryOfSize: 30 * 1024 * 1024 "10MB of old space"
		newSpaceSize: 50 * 1024 * 1024 "20MB of new space"
		stackSize: 16 * 1024
		codeSize: 0.
	"self objectMemory
		setHeapBase: self objectMemory startOfMemory
		memoryLimit: self objectMemory startOfMemory + (4 * 1024 * 1024)
		endOfMemory: self objectMemory startOfMemory + 16 * 1024."
	self objectMemory setCheckForLeaks: 15 - 6. "don't check become; or newSpace; soooo many rehashes in bootstrap"
	self objectMemory bootstrapping: true.
	self objectMemory lastHash: Object new basicIdentityHash.
	self objectMemory classTableIndex: 1024.
	self simulator thisClassIndex: 6. "we are in pharo"
	self simulator transcript: ThreadSafeTranscript new.
]

{ #category : #'from local to remote' }
EP2Backend >> fromLocalByteSymbol: aByteSymbol [ 
	| remoteSymbol |
	remoteSymbol := (self byteSymbolClass basicNew: aByteSymbol size) asRemoteObject.
	1 to: aByteSymbol size do: [ :i |
		remoteSymbol at: i put: (aByteSymbol at: i) asciiValue
	].
	^ remoteSymbol
]

{ #category : #'from local to remote' }
EP2Backend >> fromLocalInteger: aLocalInteger [
	
	| integer |
	integer := simulator objectMemory signedMachineIntegerFor: aLocalInteger.
	^ (simulator objectMemory isImmediate: integer)
		ifTrue: [ EP2RemoteSmallInteger on: (self handleOnAddress: integer) from: self ]
		ifFalse: [ self mirrorOnAddress: integer ].
]

{ #category : #'from remote to local' }
EP2Backend >> fromRemoteByteString: remoteOrMirror [ 
	
	| localString remote |
	remote := remoteOrMirror asRemoteByteString.
	localString := ByteString new: remote basicSize.
	1 to: localString size do: [ :i |
		localString byteAt: i put: (remote at: i) asSmallInteger.
	].
	^ localString
]

{ #category : #'from remote to local' }
EP2Backend >> fromRemoteByteSymbol: anEP2Mirror [ 
	
	^ Symbol intern: (self fromRemoteByteString: anEP2Mirror)
]

{ #category : #'creating-handles' }
EP2Backend >> handleOnAddress: anAddress [

	^ EP2AddressHandle new
			backend: self;
			address: anAddress;
			yourself
]

{ #category : #'creating-handles' }
EP2Backend >> handleOnClassIndex: aClassIndex [

	^ EP2ClassTableHandle new
			backend: self;
			classIndex: aClassIndex;
			yourself
]

{ #category : #handles }
EP2Backend >> handleOnExternalObject: aLocalObject [ 
	
	^ EP2ExternalObjectHandle new
			backend: self;
			object: aLocalObject;
			yourself
]

{ #category : #initializing }
EP2Backend >> initialize [
	super initialize.
	extraRoots := Set new
]

{ #category : #initializing }
EP2Backend >> initializeExecutionContext [

	| page pointer stackPages theIP theMethod rcvr numArgs |

"Create empty initial context to be able to execute primitives"
	stackPages := self simulator stackPages.
	page := stackPages newStackPage.
	pointer := page baseAddress.
	theIP := 0.
	theMethod := self nilObject target address.
	rcvr := self nilObject target address.
	numArgs := 0.
	
	"If this is a synthetic context its IP could be pointing at the CallPrimitive opcode.  If so, skip it."
	stackPages longAt: pointer put: rcvr.
	
	"saved caller ip is sender context in base frame"
	stackPages
		longAt: (pointer := pointer - self objectMemory wordSize)
		put: self nilObject target address.

	"base frame's saved fp is null"
	stackPages
		longAt: (pointer := pointer - self objectMemory wordSize)
		put: 0.
	page baseFP: pointer; headFP: pointer.

	stackPages
		longAt: (pointer := pointer - self objectMemory wordSize)
		put: theMethod.

	stackPages
		longAt: (pointer := pointer - self objectMemory wordSize)
		put: (self simulator encodeFrameFieldHasContext: true isBlock: true numArgs: numArgs).
	stackPages
		longAt: (pointer := pointer - self objectMemory wordSize)
		put: self nilObject target address.
	stackPages
		longAt: (pointer := pointer - self objectMemory wordSize)
		put: rcvr.
	
	"top of stack is the instruction pointer"
	"stackPages longAt: (pointer := pointer - self objectMemory wordSize) put: theIP."
	page headSP: pointer.

	self simulator setStackPageAndLimit: page.
	self simulator framePointer: page headFP.
	self simulator stackPointer: page headSP.
	self simulator setMethodUnchecked: (self simulator iframeMethod: page headFP).
	self simulator instructionPointer: 0.
	self simulator internalizeIPandSP.
]

{ #category : #'querying-objects' }
EP2Backend >> instSpecOfClass: anEP2Mirror [ 
	
	^ self simulator objectMemory instSpecOfClass: anEP2Mirror target address
]

{ #category : #'accessing-class table' }
EP2Backend >> installClass: anEP2RemoteClass inClassTableIndex: anInteger [ 
	
	self objectMemory setHashBitsOf: anEP2RemoteClass target address to: anInteger.
	self objectMemory classAtIndex: anInteger putUnchecked: anEP2RemoteClass target address.
	anEP2RemoteClass target: anEP2RemoteClass target asClassIndexHandle.
]

{ #category : #'querying-objects' }
EP2Backend >> instanceFixedSizeOf: aRemoteClass [
	
	^ aRemoteClass format asLocalSmallInteger bitAnd: 16rFFFF
]

{ #category : #'from remote to local' }
EP2Backend >> integerValueOf: anEP2Mirror [ 
	
	^ self objectMemory integerValueOf: anEP2Mirror target address
]

{ #category : #accessing }
EP2Backend >> interpreter [ 
	^ self objectSpace interpreter
]

{ #category : #'testing-classes' }
EP2Backend >> isBitsClass: anEP2RemoteClass [ 
	
	^ (self instSpecOfClass: anEP2RemoteClass) >= 7
]

{ #category : #'testing-classes' }
EP2Backend >> isRoleMetaclass: anEP2RemoteClass [ 
	^ (self builder systemDefinition classRoles at: #Metaclass) = anEP2RemoteClass classNameFromAnyOrigin 
]

{ #category : #'testing-objects' }
EP2Backend >> isSmallInteger: aHandle [ 
	
	^ self objectMemory isIntegerObject: aHandle address
]

{ #category : #'accessing-special classes' }
EP2Backend >> largeNegativeIntegerClass: anEP2RemoteClass [ 
	"The forty-third special object.
	Smalltalk specialObjectsArray indexOf: LargeNegativeInteger"
	self specialObjectsArray at: 43 put: anEP2RemoteClass.
	self installClass: anEP2RemoteClass inClassTableIndex: 32
]

{ #category : #'accessing-special classes' }
EP2Backend >> largePositiveIntegerClass: anEP2RemoteClass [ 
	"The fourteenth special object.
	Smalltalk specialObjectsArray indexOf: LargePositiveInteger"
	self specialObjectsArray at: 14 put: anEP2RemoteClass.
	self installClass: anEP2RemoteClass inClassTableIndex: 33
]

{ #category : #'from local to remote' }
EP2Backend >> localObjectAsRemoteObject: aLocalObject [
	^ aLocalObject asRemoteObjectInObjectSpace: self objectSpace
]

{ #category : #'accessing-special classes' }
EP2Backend >> messageClass: anEP2RemoteClass [ 

	"The method Comtext class in most special objects arrays.
	Smalltalk specialObjectsArray indexOf: Message"
	self specialObjectsArray at: 16 put: anEP2RemoteClass.
	self installClass: anEP2RemoteClass inClassTableIndex: 35
]

{ #category : #'accessing-special classes' }
EP2Backend >> methodClass: anEP2RemoteClass [ 

	"The CompiledMethod instance in most special objects arrays.
	Smalltalk specialObjectsArray indexOf: CompiledMethod"
	^ self specialObjectsArray at: 17 put: anEP2RemoteClass
]

{ #category : #'creating-mirrors' }
EP2Backend >> mirrorOn: anEP2SimulatorHandle [ 
	^ EP2Mirror on: anEP2SimulatorHandle from: self
]

{ #category : #'creating-mirrors' }
EP2Backend >> mirrorOnAddress: anObject [
	
	^ self mirrorOn: (self handleOnAddress: anObject)
]

{ #category : #handles }
EP2Backend >> mirrorOnExternalHandle: aLocalObject [ 
	^ self mirrorOn: (self handleOnExternalObject: aLocalObject)
]

{ #category : #'accessing-special objects' }
EP2Backend >> nilObject [
	
	"The first special object."
	^ (self mirrorOnAddress: simulator objectMemory nilObject) asRemoteNil
]

{ #category : #'accessing-special objects' }
EP2Backend >> nilObject: anEPMirror [
	"The first special object.
	Smalltalk specialObjectsArray indexOf: nil"

	self specialObjectsArray
		ifNotNil: [ :soa | 
			self 
				object: soa
				at: 1 
				put: anEPMirror ].
	simulator objectMemory nilObject: anEPMirror target address
]

{ #category : #'accessing-objects body' }
EP2Backend >> object: object at: index [ 
	^ self 
		objectOop: object target address 
		at: index 
]

{ #category : #'accessing-objects body' }
EP2Backend >> object: object at: index put: value [
	self 
		objectOop: object target address 
		at: index 
		putOop: value target address 
]

{ #category : #'accessing-objects body' }
EP2Backend >> object: object instVarAt: index [ 
	^ self 
		objectOop: object target address 
		instVarAt: index
]

{ #category : #'accessing-objects body' }
EP2Backend >> object: object instVarAt: index put: value [

	self objectOop: object target address 
		instVarAt: index 
		putOop: value target address
]

{ #category : #accessing }
EP2Backend >> objectMemory [
	
	^ simulator objectMemory
]

{ #category : #'accessing-objects body' }
EP2Backend >> objectOop: objectOop at: index [ 
	^ self mirrorOnAddress: (simulator stObject: objectOop at: index)
]

{ #category : #'accessing-objects body' }
EP2Backend >> objectOop: objectOop at: anInteger putOop: valueOop [
	
	simulator objectMemory
		stObject: objectOop
		at: anInteger
		put: valueOop
]

{ #category : #'accessing-objects body' }
EP2Backend >> objectOop: objectOop instVarAt: index [ 
	
	| address |
	address := self objectMemory fetchPointer: index - 1 ofObject: objectOop.	
	((self objectMemory isNonImmediate: address)
		and: [self objectMemory isForwarded: address])
			ifTrue: [ | forwardedObject |
				forwardedObject := self objectMemory followForwarded: address.
				self object: objectOop instVarAt: index put: forwardedObject.
				address := forwardedObject ].
	^ self mirrorOnAddress: address
]

{ #category : #'accessing-objects body' }
EP2Backend >> objectOop: objectOop instVarAt: index putOop: valueOop [
	
	simulator objectMemory storePointer: index - 1 ofObject: objectOop withValue: valueOop
]

{ #category : #accessing }
EP2Backend >> objectSpace [ 
	^ objectSpace
]

{ #category : #accessing }
EP2Backend >> objectSpace: anEPObjectSpace [ 
	objectSpace := anEPObjectSpace
]

{ #category : #'accessing-special classes' }
EP2Backend >> pointClass: anEP2RemoteClass [ 

	"The Point class in most special objects arrays.
	Smalltalk specialObjectsArray indexOf: Point"
	self specialObjectsArray at: 13 put: anEP2RemoteClass.
	self installClass: anEP2RemoteClass inClassTableIndex: 54.
]

{ #category : #'accessing-special classes' }
EP2Backend >> processClass: anEP2RemoteClass [ 

	"The Point class in most special objects arrays.
	Smalltalk specialObjectsArray indexOf: Process"
	^ self specialObjectsArray at: 28 put: anEP2RemoteClass
]

{ #category : #'accessing-special objects' }
EP2Backend >> processorAssociation [

	"The Association object that references the processor.
	Should be index 4.
	Smalltalk specialObjectsArray indexOf: (Smalltalk bindingOf: #Processor)"
	^ (self specialObjectsArray at: 4) asRemoteAssociation
]

{ #category : #'accessing-special objects' }
EP2Backend >> processorAssociation: anEP2RemoteObject [ 
	"The Association object that references the processor.
	Should be index 4.
	Smalltalk specialObjectsArray indexOf: (Smalltalk bindingOf: #Processor)"
	^ self specialObjectsArray at: 4 put: anEP2RemoteObject
]

{ #category : #'querying-objects' }
EP2Backend >> rawHashOf: anAddress [
	
	"this method does not initialize the hash of the object"
	
	^ self objectMemory rawHashBitsOf: anAddress
]

{ #category : #accessing }
EP2Backend >> simulator [
	^ simulator
]

{ #category : #accessing }
EP2Backend >> simulator: aStackInterpreterSimulatorLSB [ 
	simulator := aStackInterpreterSimulatorLSB
]

{ #category : #'accessing-slots' }
EP2Backend >> slotsFor: anEP2RemoteClass do: aBlockClosure [ 
	| classDefinition |
	"getting the corresponding definition from systemDefinition"
	classDefinition := anEP2RemoteClass asClassDefinition. 
	classDefinition 
		ifNotNil: [ classDefinition allSlots do: [:each | | newSlot slotDefiningClass | 
				slotDefiningClass := self builder classNamed: each parent parent name.
				"we create a new EP2Slot from the definition"
				newSlot := each asEP2Slot definingClass: slotDefiningClass; index: each index; yourself.
				aBlockClosure value: newSlot ]]
		ifNil: [ 
			self haltOnce.
			 ]
]

{ #category : #'accessing-special classes' }
EP2Backend >> smallIntegerClass: aClass [

	
	"The Smalltalk instance in most special objects arrays.
	Smalltalk specialObjectsArray indexOf: SmallInteger"
	self specialObjectsArray at: 6 put: aClass.
	
	"SmallInteger is a special class that resides in the first page of the class table.
	For some reason that we ignore so far, this class is in two different indexes of the table: 1 and 3.
	
	Usually, a class hash must be the same as the class index in the class table. But, since the class is in two different positions, one of them does not hold that invariant.
	To install the class in the table in both positions, we use an Unchecked version of the method that contains no assertions of that invariant.
	
	Also the hash of the class is set to 1, following the current behavior of the system:
	
	SmallInteger basicIdentityHash."
	self objectMemory setHashBitsOf: aClass target address to: 1.
	self objectMemory classAtIndex: 1 putUnchecked: aClass target address.
	self objectMemory classAtIndex: 3 putUnchecked: aClass target address.
	aClass target: aClass target asClassIndexHandle.
]

{ #category : #'accessing-special objects' }
EP2Backend >> specialObjectsArray [
	"Careful. This is an external object. Do not send messages to it."
	^ (self objectSpace specialObjectsArray) 
			ifNotNil: [ :soa | soa asRemoteArray ]
			ifNil: [ nil ]
]

{ #category : #'accessing-special objects' }
EP2Backend >> specialSelectors: anArrayOfSelectorsAndArgumentSizePairs [ 
	"The 24th special object.
	Smalltalk specialObjectsArray indexOf: Smalltalk specialSelectors"
	^ self specialObjectsArray at: 24 put: anArrayOfSelectorsAndArgumentSizePairs
]

{ #category : #'executing primitives' }
EP2Backend >> stackIsEmpty [
	
	"We have an initial stack of 16"
	^ self simulator stackPointer - self simulator framePointer == (self simulator objectMemory wordSize * 4) negated
]

{ #category : #'accessing-special classes' }
EP2Backend >> symbolTableClass: anEP2RemoteClass [ 
	
	symbolTableClass := anEP2RemoteClass
]

{ #category : #accessing }
EP2Backend >> systemDefinition [
	^ systemDefinition
]

{ #category : #accessing }
EP2Backend >> systemDefinition: aPBLanguageDefinition [ 
	systemDefinition := aPBLanguageDefinition
]

{ #category : #'accessing-special objects' }
EP2Backend >> trueObject [
	
	"The first special object."
	^ (self mirrorOnAddress: simulator objectMemory trueObject) asRemoteEmptyObject
]

{ #category : #'accessing-special objects' }
EP2Backend >> trueObject: anEPMirror [
	"The first special object.
	Smalltalk specialObjectsArray indexOf: nil"

	"^ self specialObjectsArray at: 1 put: anEPMirror"

	self specialObjectsArray
		ifNotNil: [ :soa | 
			self 
				object: soa
				at: 3
				put: anEPMirror ].
	simulator objectMemory trueObject: anEPMirror target address
]
