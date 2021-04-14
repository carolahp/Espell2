Class {
	#name : #EP2SpurImage,
	#superclass : #Object,
	#instVars : [
		'nilObject',
		'trueObject',
		'falseObject',
		'specialObjectsArray',
		'classTable',
		'file'
	],
	#category : #'Espell2-Image'
}

{ #category : #constants }
EP2SpurImage class >> metadataFileExtension [
	^ 'metal'
]

{ #category : #'instance creation' }
EP2SpurImage class >> onFile: aFileRefernce [
	| espellBackend model image repository metadata languageMetaclass simulator objectSpace interpreter |
	image := aFileRefernce asFileReference.
	metadata := image parent / image basenameWithoutExtension
		, self metadataFileExtension.
	metadata contents.
	"I need to remove the hardcoded access to the languageMetaclass and to tonel repository, by getting this values from the metadata file"
	languageMetaclass := LanguageModel.
	repository := image parent / image basenameWithoutExtension.
	self
		assert: repository exists
		description: 'Model saved as tonel repository not found in ' , repository asString.

	"initializing language model"
	model := languageMetaclass new
		name: image basename , ' (from disk)';
		yourself.
	model loadTonelRepository: repository.

	"initializing VM simulator"
	simulator := StackInterpreterSimulator
		newWithOptions:
			#(ObjectMemory Spur32BitMemoryManager MULTIPLEBYTECODESETS true).
	simulator desiredNumStackPages: 8.	"Speeds up scavenging when simulating.  Set to e.g. 64 for something like the real VM."
	simulator assertValidExecutionPointersAtEachStep: false.
	simulator openOn: image.

	"initializing espell"
	espellBackend := EP2Backend new
		simulator: simulator;
		systemDefinition: model;
		yourself.
	objectSpace := EP2ObjectSpace new
		backend: espellBackend;
		yourself.
	interpreter := EPASTEvaluator new.
	interpreter
		codeProvider: model;
		environment: interpreter;
		objectSpace: objectSpace.
	objectSpace interpreter: interpreter.
	espellBackend objectSpace: objectSpace.
	"set special objects array"
	objectSpace
		specialObjectsArray:
			(espellBackend
				mirrorOnAddress: simulator objectMemory specialObjectsOop)
				asRemoteArray.
	^ self onFirstObject: objectSpace nilObject file: image
]

{ #category : #instantiation }
EP2SpurImage class >> onFirstObject: anEP2Mirror [ 
	^ self onFirstObject: anEP2Mirror file: nil
]

{ #category : #instantiation }
EP2SpurImage class >> onFirstObject: anEP2Mirror file: aFileReferenceOrNil [
	^ self basicNew 
		nilObject: anEP2Mirror asRemoteNil;
		file: aFileReferenceOrNil;
		initialize;
		yourself
]

{ #category : #'accessing-slots' }
EP2SpurImage >> allVariables [
	^ { nilObject . falseObject . trueObject . specialObjectsArray . classTable }
]

{ #category : #accessing }
EP2SpurImage >> backend [ 
	^ self nilObject backend 
]

{ #category : #'accessing-classes' }
EP2SpurImage >> classNamed: aString [
	(self classes select: [ :class | class name = aString ]) 
		ifNotEmpty: [ :result | ^ result anyOne ].
	^ nil
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> classTable [
	^ classTable
]

{ #category : #'accessing-classes' }
EP2SpurImage >> classes [
	| classes |
	classes := #() asOrderedCollection.
	self classesOopDoWithIndex: [ :classOop :index |
		classes add: (self backend mirrorOnAddress: classOop) asRemoteClass ].
	^ classes
]

{ #category : #'accessing-classes' }
EP2SpurImage >> classesOop [
	| classes |
	classes := #() asOrderedCollection.
	self classesOopDoWithIndex: [ :class :index |
		classes add: class ].
	^ classes
]

{ #category : #'accessing-classes' }
EP2SpurImage >> classesOopDoWithIndex: aBlock [ 
	^ self backend simulator objectMemory classTableObjectsDoWithIndex: aBlock 
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> falseObject [

	^ falseObject
]

{ #category : #accessing }
EP2SpurImage >> file [
	^ file
]

{ #category : #accessing }
EP2SpurImage >> file: anObject [
	file := anObject
]

{ #category : #accessing }
EP2SpurImage >> fromFile [
	^ file isNotNil
]

{ #category : #'gt-inspector' }
EP2SpurImage >> gtInspector: composite [
	<gtInspectorPresentationOrder: 1>
	
	^ composite tree
		rootsExpanded;
		title: 'Remote Image';
		display: [ { self } ];
		children: 
			[ :each | each allVariables collect: #asRemoteObjectCasted ]
]

{ #category : #'gt-inspector' }
EP2SpurImage >> gtInspectorClassTable: composite [
	<gtInspectorPresentationOrder: 2>
	^ composite table
		title: 'Class Table';
		display: [ 
			self classTable
				localCollect: [ :row | 
					| class |
					class := (row at: 2) asRemoteClass.
					{(row at: 1) .
					class classTableIndex .
					class} ] ];
		column: 'index' evaluated: [ :array | array at: 1 ];
		column: 'tag' evaluated: [ :array | array at: 2 ];
		column: 'class' evaluated: [ :array | array at: 3 ];
		send: [ :array | array ifNotNil: [ array at: 3 ] ]
]

{ #category : #'gt-inspector' }
EP2SpurImage >> gtInspectorLoadedClasses: composite [
	<gtInspectorPresentationOrder: 3>
	^ composite table
		title: 'Loaded classes';
		display: [ self backend systemDefinition allClasses
				collect: [ :class | 
					| remoteClass |
					remoteClass := class remote.
					(remoteClass isNil or: [remoteClass isNilObject])
						ifTrue: [ {class name.
							nil.
							class remote} ]
						ifFalse: [ {class name.
							remoteClass classTableIndex.
							remoteClass} ] ] ];
		column: 'name' evaluated: [ :array | array at: 1 ];
		column: 'tag' evaluated: [ :array | array at: 2 ];
		column: 'remote' evaluated: [ :array | array at: 3 ];
		send: [ :array | array ifNotNil: [ array at: 3 ] ]
]

{ #category : #'gt-inspector' }
EP2SpurImage >> gtInspectorSuspendedContext: composite [
	<gtInspectorPresentationOrder: 0>
	^ composite tree
		rootsExpanded;
		title: 'Suspended context';
		display: [ (self specialObjectsArray at: 4) asRemoteAssociation value
				asRemoteScheduler activeProcess asRemoteProcess ];
		children: [ :each | (each allInstVars collect: #value) collect: #asRemoteObjectCasted ]
]

{ #category : #initialization }
EP2SpurImage >> initialize [
	super initialize.
	self initializeSpecialObjects 
]

{ #category : #initialization }
EP2SpurImage >> initializeSpecialObjects [
	| classes |
	falseObject := nilObject nextObject asRemoteFalse.
	trueObject := falseObject nextObject asRemoteTrue.
	specialObjectsArray := self backend specialObjectsArray.
	self fromFile ifTrue: [ self setRemoteForClassDefinitions ].
	"calculating class table"
	classes := #() asOrderedCollection.
	self
		classesOopDoWithIndex: [ :classOop :index | 
			| val |
			val := (self backend mirrorOnAddress: classOop) asRemoteClass.
			classes
				add:
					({index.
					val} asRemoteObjectInObjectSpace: self objectSpace) asRemoteArray ].
	classes
		sort: [ :c1 :c2 | 
			(c1 at: 2) asRemoteClass classNameFromAnyOrigin
				< (c2 at: 2) asRemoteClass classNameFromAnyOrigin ].
	classTable := (classes asArray
		asRemoteObjectInObjectSpace: self objectSpace) asRemoteArray
]

{ #category : #accessing }
EP2SpurImage >> languageDefinition [ 
	^ self backend systemDefinition
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> nilObject [ 
	^ nilObject
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> nilObject: anEP2Mirror [
	nilObject := anEP2Mirror asRemoteNil
]

{ #category : #accessing }
EP2SpurImage >> objectSpace [
	^ self backend interpreter objectSpace
]

{ #category : #running }
EP2SpurImage >> run [ 
	| sis |
	self file ifNil: [ self error: 'Image not loaded from file can not run' ].
	sis := StackInterpreterSimulator newWithOptions: #(
    ObjectMemory Spur32BitMemoryManager
    MULTIPLEBYTECODESETS true).
	sis desiredNumStackPages: 8. "Speeds up scavenging when simulating.  Set to e.g. 64 for something like the real VM."
	sis assertValidExecutionPointersAtEachStep: false. 

	sis openOn: self file.
	sis run.
]

{ #category : #'initializing disk image' }
EP2SpurImage >> setRemoteForClassDefinitions [
	| addressDict |
	addressDict := IdentityDictionary new.
	self classesOopDoWithIndex: [ :classOop :classIndex | | remoteClass |
		remoteClass := (self backend mirrorOnAddress: classOop) asRemoteClass.
		addressDict at: remoteClass indexInClassTable put: remoteClass.
	].
	self languageDefinition allClasses do: [ :classDef | | remoteClass | 
		remoteClass := addressDict at: classDef indexInClassTable ifAbsent: [ nil ].
		classDef remote:  remoteClass.
		"self assert: (classDef remote isNotNil and: [classDef remote isNotNilObject])"
	]
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> specialObjectsArray [
	^ specialObjectsArray
]

{ #category : #'accessing-specialObjects' }
EP2SpurImage >> trueObject [
	^ trueObject
]
