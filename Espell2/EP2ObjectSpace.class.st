Class {
	#name : #EP2ObjectSpace,
	#superclass : #Object,
	#instVars : [
		'backend',
		'systemDictionary',
		'characterTable',
		'symbolTable',
		'interpreter',
		'debuggerInterpreter',
		'specialObjectsArray'
	],
	#category : #'Espell2-Backend'
}

{ #category : #'dummy environment for compilation' }
EP2ObjectSpace >> at: aString ifAbsent: aBlockClosure [ 
	"returns nil because this method is used to get CompiledMethod for generating Compiled Method instances durin the bootstrap"
	^ aBlockClosure value
]

{ #category : #accessing }
EP2ObjectSpace >> backend [
	^ backend
]

{ #category : #accessing }
EP2ObjectSpace >> backend: anEP2Backend [ 
	backend := anEP2Backend 
]

{ #category : #accessing }
EP2ObjectSpace >> characterTable: anEPExternalCharacterTable [ 
	characterTable := anEPExternalCharacterTable 
	
]

{ #category : #'accessing builders' }
EP2ObjectSpace >> contextBuilder [
	^ EP2RemoteContext
]

{ #category : #'creating process' }
EP2ObjectSpace >> createProcessWithPriority: aPriority doing: anExpression withTemps: someTemps [
	| method aContext  |
	method := self methodBuilder createDoit: anExpression withTemps: someTemps inObjectSpace: self.
	aContext := self contextBuilder createContextForMethod: method inObjectSpace: self.
	^self processBuilder createProcessForContext: aContext andPriority: aPriority inObjectSpace: self.
]

{ #category : #accessing }
EP2ObjectSpace >> crossCompiler [
	^ EP2CrossCompiler new
		objectSpace: self;
		yourself
]

{ #category : #accessing }
EP2ObjectSpace >> debuggerInterpreter: aDASTEvaluator [ 
	debuggerInterpreter := aDASTEvaluator 

]

{ #category : #destroy }
EP2ObjectSpace >> destroy [
	backend := nil.
	characterTable ifNotNil: [ 
		characterTable destroy. 
		characterTable := nil].
	debuggerInterpreter ifNotNil: [ 
		debuggerInterpreter destroy.
		debuggerInterpreter := nil ].
	interpreter ifNotNil: [ 
		interpreter destroy.
		interpreter := nil ].
	specialObjectsArray := nil.
	symbolTable ifNotNil: [ 
		symbolTable destroy.
		symbolTable := nil ].
	systemDictionary ifNotNil: [ 
		systemDictionary destroy.
		systemDictionary := nil ].
	
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> falseObject [
	^ self backend falseObject
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> falseObject: aFalseObject [
	self backend falseObject: aFalseObject
]

{ #category : #'local to remote' }
EP2ObjectSpace >> fromLocalByteArray: aCollection [ 
	^ backend fromLocalByteArray: aCollection
]

{ #category : #'from local to remote' }
EP2ObjectSpace >> fromLocalByteString: aString [ 
	^ self backend fromLocalByteString: aString
]

{ #category : #'from local to remote' }
EP2ObjectSpace >> fromLocalByteSymbol: aByteSymbol [  

	^ self symbolTable at: aByteSymbol ifAbsentPut: [ 
		backend fromLocalByteSymbol: aByteSymbol ]
]

{ #category : #'from local to remote' }
EP2ObjectSpace >> fromLocalCharacter: aCharacter [ 
	^ (self backend mirrorOnAddress: (self objectMemory characterObjectOf: aCharacter codePoint)) asRemoteCharacter
]

{ #category : #'from local to remote' }
EP2ObjectSpace >> fromLocalFloat: aLocalFloat [ 
	^ self backend fromLocalFloat: aLocalFloat
]

{ #category : #'from local to remote' }
EP2ObjectSpace >> fromLocalInteger: anInteger [

	^backend fromLocalInteger: anInteger
]

{ #category : #'installing process' }
EP2ObjectSpace >> installAsActiveProcess: aRemoteProcess withProcessor: aRemoteProcessor [ 
	| activeProcess theProcessor |
	theProcessor := aRemoteProcessor asRemoteScheduler.
	activeProcess := theProcessor activeProcess.
	"If this is already the active process we have nothing to do"
	(activeProcess pointsToSameObject: aRemoteProcess)
		ifTrue: [ ^self ].
	
	"If there is another active process we queue it"
	activeProcess isNilObject ifFalse: [
		activeProcess queue
	].
	
	aRemoteProcess asRemoteProcess priorityList: self nilObject.
	theProcessor activeProcess: aRemoteProcess.
]

{ #category : #accessing }
EP2ObjectSpace >> interpreter [
	interpreter ifNil: [ self error: 'interpreter not initialized for this object space' ].
	^interpreter
]

{ #category : #accessing }
EP2ObjectSpace >> interpreter: anEPASTEvaluator [ 
	interpreter := anEPASTEvaluator 

]

{ #category : #'accessing builders' }
EP2ObjectSpace >> methodBuilder [
	^ backend builder methodBuilder
]

{ #category : #'remote-instantiation' }
EP2ObjectSpace >> newArrayWithAll: aCollection [ 
	^ self newRemoteArrayWithAll: aCollection
]

{ #category : #'remote object instantiation' }
EP2ObjectSpace >> newAssociationWithKey: aKey andValue: aValue [

	| association |
	association := self backend associationClass basicNew asRemoteAssociation.
	association instanceVariableAtIndex: association associationKeyIndex put: aKey.
	association instanceVariableAtIndex: association associationValueIndex put: aValue.
	^ association
]

{ #category : #'remote-objects-instantiation' }
EP2ObjectSpace >> newRemoteArrayWithAll: elements [
	
	| array |
	array := (self backend arrayClass basicNew: elements size) asRemoteArray.
	elements withIndexDo: [ :element :index |
		array at: index put: element
	].
	^ array
]

{ #category : #'remote-objects-instantiation' }
EP2ObjectSpace >> newRemoteDictionaryFrom: aDictionary [
	| remoteArray |
	remoteArray := aDictionary associations asRemoteObjectInObjectSpace: self.
	^ EP2RemoteDictionary newFrom: remoteArray
]

{ #category : #'remote-objects-instantiation' }
EP2ObjectSpace >> newRemoteDictionaryOfSize: size [
	
	^ EP2RemoteDictionary newWithBackend: self backend size: size
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> nilObject [
	^ self backend nilObject
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> nilObject: aNilObject [
	self backend nilObject: aNilObject
]

{ #category : #accessing }
EP2ObjectSpace >> objectMemory [
	^ self backend simulator objectMemory
]

{ #category : #accessing }
EP2ObjectSpace >> processBuilder [
	^ EP2RemoteProcess
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> specialObjectsArray [
	^ specialObjectsArray 
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> specialObjectsArray: anEP2Mirror [ 
	specialObjectsArray := anEP2Mirror.
	backend simulator objectMemory specialObjectsOop: anEP2Mirror target address
]

{ #category : #accessing }
EP2ObjectSpace >> symbolTable [
	^ symbolTable
]

{ #category : #accessing }
EP2ObjectSpace >> symbolTable: anEPExternalSymbolTable [ 
	symbolTable := anEPExternalSymbolTable 

]

{ #category : #accessing }
EP2ObjectSpace >> systemDictionary [
	^ systemDictionary
]

{ #category : #accessing }
EP2ObjectSpace >> systemDictionary: anObject [
	systemDictionary := anObject
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> trueObject [
	^ self backend trueObject
]

{ #category : #'accessing-specialObjects' }
EP2ObjectSpace >> trueObject: aTrueObject [
	self backend trueObject: aTrueObject
]
