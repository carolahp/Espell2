Class {
	#name : #GlobalModel,
	#superclass : #LiteralVariableModel,
	#instVars : [
		'remoteIsStub'
	],
	#category : #'Espell2-Metamodel-Variables'
}

{ #category : #metamodel }
GlobalModel class >> usedModels [
	^#()
]

{ #category : #accessing }
GlobalModel >> environment [ 
	^ self parent
]

{ #category : #accessing }
GlobalModel >> imageBuilder [ 
	^ self parent imageBuilder
]

{ #category : #accessing }
GlobalModel >> initialValue [ 
	^ pbInstruction evaluate
]

{ #category : #accessing }
GlobalModel >> initializationCode: aBlockOraString [
	| languageModel |
	languageModel := self environment.
	
	pbInstruction := aBlockOraString
		asPBInstructionFor: languageModel
]

{ #category : #installing }
GlobalModel >> install [
	| newValue |
	self remote ifNil: [ self installStub ].
	self assert: self remote isNotNil.
	newValue := self initialValue.
	remoteIsStub := false.
	self setValue: newValue.
	self testRemote.
	^ self remote
]

{ #category : #installing }
GlobalModel >> installStub [
	| remoteNil |
	self remote isNotNil
		ifTrue: [ ^ self remote ].
	remoteNil := self imageBuilder espellBackend nilObject.
	remoteIsStub := true.
	self remote: remoteNil.
	self register.
	^ self remote
]

{ #category : #order }
GlobalModel >> order [
	^ #(Undeclared Smalltalk Processor)
		indexOf: self role
		ifAbsent: [ 100 ]
]

{ #category : #printing }
GlobalModel >> printOn: aStream [
	aStream 
		nextPutAll: 'a GlobalModel("';
		nextPutAll: self name;
		nextPutAll: '")'
]

{ #category : #registering }
GlobalModel >> register [
	self registerStub.
	remoteIsStub ifFalse: [ 
		self registerCustom
		 ]
]

{ #category : #registering }
GlobalModel >> registerCustom [
	"Register this global in your system dictionary or anywhere you like"
	^ nil
]

{ #category : #registering }
GlobalModel >> registerStub [
	self imageBuilder 
		registerGlobal: self remote 
		definition: self
		fullyLoaded: false
]

{ #category : #accessing }
GlobalModel >> remote [
	^ remote
]

{ #category : #accessing }
GlobalModel >> remote: anEP2Mirror [
	remote := anEP2Mirror
]

{ #category : #testing }
GlobalModel >> remoteIsInstalled [
	^ self remote isNotNil and: [ remoteIsStub not ]
]

{ #category : #accessing }
GlobalModel >> remoteIsStub: aBoolean [ 
	remoteIsStub := aBoolean
]

{ #category : #accessing }
GlobalModel >> role: aString [ 
	role := aString
]

{ #category : #updating }
GlobalModel >> setValue: anEP2Remote [
	self remote: (anEP2Remote asRemoteObjectInObjectSpace: self environment imageBuilder objectSpace).
	self register

]

{ #category : #testing }
GlobalModel >> test [
	self assert: self name isNotNil.
	self assert: pbInstruction isNotNil
]

{ #category : #testing }
GlobalModel >> testRemote [
	self assert: self remote isNotNil.
	self assert: remoteIsStub not
]
