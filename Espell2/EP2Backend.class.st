Class {
	#name : #EP2Backend,
	#superclass : #Object,
	#instVars : [
		'simulator',
		'systemDefinition',
		'objectSpace',
		'extraRoots'
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

{ #category : #'adding-roots' }
EP2Backend >> addExtraRoot: anEP2RemoteClass [ 

	extraRoots add: anEP2RemoteClass
]

{ #category : #'high-level-messages' }
EP2Backend >> basicNewOn: aRemoteClass [
	
	| newOop newObject |
	newOop := self objectMemory instantiateClass: aRemoteClass target address.
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

{ #category : #'accessing-mirror' }
EP2Backend >> basicSizeOf: anEPRemoteObject [
	anEPRemoteObject isSmallInteger ifTrue: [ ^ 0 ].
	^ self simulator uncheckedStSizeOf: anEPRemoteObject target address
]

{ #category : #'accessing-classTable' }
EP2Backend >> classAtIndex: anInteger [ 
	^ simulator objectMemory classAtIndex: anInteger
]

{ #category : #'modifying-handle' }
EP2Backend >> classHandle: handleFrom setTo: handleTo [ 
	self objectMemory changeClassOf: handleFrom address to: handleTo address
]

{ #category : #'modifying-mirrors' }
EP2Backend >> classOf: anEP2SimulatorAddressHandle [
 
	^ self objectMemory fetchClassOf: anEP2SimulatorAddressHandle address
]

{ #category : #'accessing-mirrors' }
EP2Backend >> compactClassIndexOf: anEP2RemoteClass [ 
	
	"All classes in Spur are compact, which also means that Spur has no compact classes"
	^ 0
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

{ #category : #'accessing-specialObjects' }
EP2Backend >> falseObject [
	
	"The first special object."
	^ (self mirrorOnAddress: simulator objectMemory falseObject) asRemoteEmptyObject 
]

{ #category : #'accessing-specialObjects' }
EP2Backend >> falseObject: anEP2Mirror [
	"The first special object.
	Smalltalk specialObjectsArray indexOf: nil"

	"^ self specialObjectsArray at: 1 put: anEPMirror"

	self specialObjectsArray
		ifNotNil: [ :soa | soa at: 2 put: anEP2Mirror ].
	simulator objectMemory falseObject: anEP2Mirror target address
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

{ #category : #'from-local-to-mirror' }
EP2Backend >> fromLocalInteger: aLocalInteger [
	
	| integer |
	integer := simulator objectMemory signedMachineIntegerFor: aLocalInteger.
	^ (simulator objectMemory isImmediate: integer)
		ifTrue: [ EP2RemoteSmallInteger on: (self handleOnAddress: integer) from: self ]
		ifFalse: [ self mirrorOnAddress: integer ].
]

{ #category : #'creating-mirrors' }
EP2Backend >> handleOnAddress: anAddress [

	^ EP2SimulatorAddressHandle new
			backend: self;
			address: anAddress;
			yourself
]

{ #category : #'low-level' }
EP2Backend >> handleOnClassIndex: aClassIndex [

	^ EP2SimulatorClassTableHandle new
			backend: self;
			classIndex: aClassIndex;
			yourself
]

{ #category : #initializing }
EP2Backend >> initialize [
	super initialize.
	extraRoots := Set new
]

{ #category : #'accessing-header' }
EP2Backend >> instSpecOfClass: anEP2Mirror [ 
	
	^ self simulator objectMemory instSpecOfClass: anEP2Mirror target address
]

{ #category : #'high-level-message' }
EP2Backend >> instanceFixedSizeOf: aClass [
	
	^ aClass format bitAnd: 16rFFFF
]

{ #category : #'converting-remote-to-loval' }
EP2Backend >> integerValueOf: anEP2Mirror [ 
	
	^ self objectMemory integerValueOf: anEP2Mirror target address
]

{ #category : #accessing }
EP2Backend >> interpreter [ 
	^ self objectSpace interpreter
]

{ #category : #'testing-class' }
EP2Backend >> isBitsClass: anEP2RemoteClass [ 
	
	^ (self instSpecOfClass: anEP2RemoteClass) >= 7
]

{ #category : #testing }
EP2Backend >> isSmallInteger: aHandle [ 
	
	^ self objectMemory isIntegerObject: aHandle address
]

{ #category : #accessing }
EP2Backend >> memoryManager [
	self shouldBeImplemented.
]

{ #category : #mirrors }
EP2Backend >> mirrorOn: anEP2SimulatorHandle [ 
	^ EP2Mirror on: anEP2SimulatorHandle from: self
]

{ #category : #'creating-mirrors' }
EP2Backend >> mirrorOnAddress: anObject [
	
	^ self mirrorOn: (self handleOnAddress: anObject)
]

{ #category : #'accessing-specialObjects' }
EP2Backend >> nilObject [
	
	"The first special object."
	^ (self mirrorOnAddress: simulator objectMemory nilObject) asRemoteEmptyObject 
]

{ #category : #'accessing-specialObjects' }
EP2Backend >> nilObject: anEPMirror [
	"The first special object.
	Smalltalk specialObjectsArray indexOf: nil"

	self specialObjectsArray
		ifNotNil: [ :soa | soa at: 1 put: anEPMirror ].
	simulator objectMemory nilObject: anEPMirror target address
]

{ #category : #'modifying-mirrors' }
EP2Backend >> object: objectOop at: anInteger put: valueOop [
	
	simulator objectMemory
		stObject: valueOop
		at: anInteger
		put: objectOop
]

{ #category : #'accessing-instVars' }
EP2Backend >> object: anEPSimulatorInternalHandle instVarAt: index [ 
	
	| address |
	address := self objectMemory fetchPointer: index - 1 ofObject: anEPSimulatorInternalHandle address.	
	((self objectMemory isNonImmediate: address)
		and: [self objectMemory isForwarded: address])
			ifTrue: [ | forwardedObject |
				forwardedObject := self objectMemory followForwarded: address.
				self object: anEPSimulatorInternalHandle address instVarAt: index put: forwardedObject.
				address := forwardedObject ].
	^ self mirrorOnAddress: address
]

{ #category : #'modifying-mirrors' }
EP2Backend >> object: objectOop instVarAt: index put: valueOop [
	
	simulator objectMemory storePointer: index - 1 ofObject: objectOop withValue: valueOop
]

{ #category : #accessing }
EP2Backend >> objectMemory [
	
	^ simulator objectMemory
]

{ #category : #accessing }
EP2Backend >> objectSpace [ 
	^ objectSpace
]

{ #category : #accessing }
EP2Backend >> objectSpace: anEPObjectSpace [ 
	objectSpace := anEPObjectSpace
]

{ #category : #'accessing-low-level' }
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

{ #category : #'special-classes' }
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

{ #category : #'accessing-specialObjects' }
EP2Backend >> specialObjectsArray [
	"Careful. This is an external object. Do not send messages to it."
	^ self objectSpace specialObjectsArray
]

{ #category : #accessing }
EP2Backend >> systemDefinition [
	^ systemDefinition
]

{ #category : #accessing }
EP2Backend >> systemDefinition: aPBLanguageDefinition [ 
	systemDefinition := aPBLanguageDefinition
]

{ #category : #'accessing-specialObjects' }
EP2Backend >> trueObject [
	
	"The first special object."
	^ (self mirrorOnAddress: simulator objectMemory trueObject) asRemoteEmptyObject
]

{ #category : #'accessing-specialObjects' }
EP2Backend >> trueObject: anEPMirror [
	"The first special object.
	Smalltalk specialObjectsArray indexOf: nil"

	"^ self specialObjectsArray at: 1 put: anEPMirror"

	self specialObjectsArray
		ifNotNil: [ :soa | soa at: 3 put: anEPMirror ].
	simulator objectMemory trueObject: anEPMirror target address
]
