"
Use as follows:
	|language|
	""instantiate the model""
	language := (LanguageModel 
		named: 'MyLanguage' 
		withEntryPoint: 'System log: ''hola!''. System quit.').
	
	""load the base language definition, or load one created by yourself (tonel format)""
	language loadBaseLanguageModelDefinitions.
	OR
	language 	loadLanguageModelDefinitions: '/path/to/repo' asFileReference.
	
	""browse the language model using calypso""
	language browse.
	
	""generate the kernel and execute it using an external VM""
	language generate.
	
	""evaluate and debug code using the simulated execution environment and guest language debugger""
	language evaluateCode: 'Character cr asString'.
	language debugCode: '|array| array at: 1 put: #a'.
	
	""write the kernel to disk""
	language writeImage.
	
	""execute the generated kernel file using the target VM""
	language imageInDisk executeInVM.

	""load the generated kernel file into the host (current image) 
	and executes it using the VM simulator""
	language imageInDisk executeInVMSimulator.
	
	
"
Class {
	#name : #LanguageModel,
	#superclass : #ObjectModel,
	#instVars : [
		'tonelPath',
		'packages',
		'globalVariables',
		'backend',
		'pbBootstrapper',
		'instanceVariableMapping',
		'classRoles',
		'markAccessed',
		'announcer',
		'builder',
		'entryPointCode',
		'imageInDisk',
		'installAccessedObjectsOnly',
		'classes'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #metamodel }
LanguageModel class >> classModel [
	" Return the subclass of ClassModel that defines the metamodel for classes of the language "
	self subclassResponsibility  
]

{ #category : #metamodels }
LanguageModel class >> classModelFor: aString [ 
	^ self classModel
]

{ #category : #'accessing - defaults' }
LanguageModel class >> defaultPackagesListFull [
	^ nil
]

{ #category : #'accessing - defaults' }
LanguageModel class >> entryPointSelector [
	^ #entryPoint
]

{ #category : #metamodel }
LanguageModel class >> firstClassModels [
	| models |
	models := {self classModel} asOrderedCollection.
	models addAll: (models flatCollect: [ :model | model firstClassModels ]).
	models addAll: self customFirstClassModels.
	^ models
]

{ #category : #metamodel }
LanguageModel class >> globalModel [
	^ GlobalModel
]

{ #category : #instantiation }
LanguageModel class >> new [
	self error: 'use methods in protocol instantiation'
]

{ #category : #instantiation }
LanguageModel class >> newFromDefaultModelWithName: aString1 withEntryPoint: aString2 [
	^ self
		newFromModel: PBBootstrapGeneric baseLanguageModelLocation
		withName: aString1
		withEntryPoint: aString2
]

{ #category : #instantiation }
LanguageModel class >> newFromModel: aFileReferenceToTonelRepo withName: aString1 withEntryPoint: aString2 [
	| langName code |
	langName := aString1.
	code := aString2.
	^ self basicNew
		name: langName;
		tonelPath: aFileReferenceToTonelRepo; 
		entryPointCode: code;
		initialize;
		yourself
]

{ #category : #instantiation }
LanguageModel class >> newPackageModel [
	^ self packageModel new
]

{ #category : #instantiation }
LanguageModel class >> newWithName: aString1 withEntryPoint: aString2 [
	^self
		newFromModel: nil
		withName: aString1
		withEntryPoint: aString2
]

{ #category : #metamodel }
LanguageModel class >> packageModel [
	^ PackageModel
]

{ #category : #metamodel }
LanguageModel class >> undeclaredVariableModel [
	^ UndeclaredVariableModel
]

{ #category : #'method loading - dynamic' }
LanguageModel >> actionDoesNotUnderstand: aRBMessageNode receiver: aRemoteObject [
	"loading the not understood message into the metamodel"

	| selector classModel systemClass traversedClasses |
	(self
		confirm:
			aRemoteObject asString , ' doesNotUnderstand message #'
				, aRBMessageNode selector asString
				, '. Load it from host system to the language model?')
		ifFalse: [ ^ self ].
	
	selector := aRBMessageNode selector.
	classModel := self
		classNamed: aRemoteObject basicClass classNameFromAnyOrigin.
	systemClass := Smalltalk classNamed: classModel name.
	traversedClasses := #() asOrderedCollection.
	[ systemClass isNotNil ]
		whileTrue:
			[ "we save traversed classes because the systemClass does not always belong to the metamodel.
			So we install the method in the metamodel class that is nearest to the system class in the inheritance hierarchy "
			traversedClasses add: systemClass name.
			systemClass methodDict
				at: selector asSymbol
				ifPresent: [ :method | 
					| newMethodModel |
					traversedClasses
						reverseDo: [ :travClass | 
							self
								classNamed: travClass
								ifPresent: [ :class | 
									"classModel := class.
									newMethodModel := self class methodMetaclass
										named: method selector
										parent: classModel.
									newMethodModel initializeWithLocal: method.
									^ classModel addLocalMethod: newMethodModel"
									newMethodModel := class ensureLocalMethodNamed: method selector.
									newMethodModel initializeWithLocal: method.
									^ newMethodModel
									
									 ] ].
					self error: 'class not found' ].
			systemClass := systemClass superclass ].
		self error: 'Method #', aRBMessageNode selector ,' not found in host system!'
]

{ #category : #'bootstrap - build model classes' }
LanguageModel >> addClass: aMClass [

	self
		classNamed: aMClass name
		ifAbsent: [ self allClasses at: aMClass name put: aMClass ]
		ifPresent: [ :found | 
			aMClass = found
				ifFalse: [ self error: 'trying to replace existent behavior' ]
				ifTrue: [ found ] ]
]

{ #category : #'bootstrap - build model classes' }
LanguageModel >> addClassFromMonticelloDefinition: aMCClassDefinition [
	| newClass mcDef |
	mcDef := aMCClassDefinition.		
	newClass := self ensureClassNamedFromMonticello: aMCClassDefinition className.
	newClass extendWithMonticello: mcDef.
	newClass extendWithMonticelloCustom: mcDef.
	" we can't test yet since not all classes have been loaded "
	^ newClass
]

{ #category : #'bootstrap - build model globals' }
LanguageModel >> addGlobalVariable: anEP2MGlobalVariable [
	self globalVariables add: anEP2MGlobalVariable
]

{ #category : #'accessing backend' }
LanguageModel >> addMethodFromMonticelloDefinition: aMCMethodDefinition [
	| methodDef classDef mcDef |
	mcDef := aMCMethodDefinition.
	classDef := self ensureClassNamedFromMonticello: mcDef className.
	methodDef := classDef ensureLocalMethodNamed: mcDef selector.
	methodDef extendWithMonticello: mcDef.
	^ methodDef
]

{ #category : #'accessing packages' }
LanguageModel >> addPackage: aPackageModel [
	
	self assert: (self definesPackageNamed: aPackageModel name) not.
	self packages at: aPackageModel name asSymbol put: aPackageModel
	
]

{ #category : #'accessing classes' }
LanguageModel >> allClasses [
	^ classes
]

{ #category : #'accessing classes' }
LanguageModel >> allClassesAndTraits [
	"added for compatibility"
	^ self allClasses
]

{ #category : #'accessing classes' }
LanguageModel >> allClassesWithRole [
	" classes with role are installed as Stubs at the beginning of bootstrap, they can be extended by loading classes from host system or from tonel repository"

	^ self allClasses
		select: [ :beh | beh isBehavior and: [ beh hasRole ] ]
]

{ #category : #announcer }
LanguageModel >> announcer [

	^ announcer ifNil: [ announcer := LanguageModelAnnouncer new ]
]

{ #category : #'compatibility - compiler' }
LanguageModel >> at: aString ifAbsent: aBlockClosure [ 
	"returns nil because this method is used to get CompiledMethod for generating Compiled Method instances durin the bootstrap"
	^ aBlockClosure value
]

{ #category : #'accessing backend' }
LanguageModel >> backend [
	^ backend ifNil: [ backend := LanguageModelBackend for: self ]
]

{ #category : #'bootstrap - build model classes' }
LanguageModel >> basicNewClassNamed: aString [
	^ (self class classModelFor: aString) basicNew
		name: aString;
		parent: self;
		yourself
]

{ #category : #'bootstrap - build model classes' }
LanguageModel >> basicNewClassWithRole: aString [
	| class className roleName |
	roleName := aString.
	className := self classRoles
		at: roleName
		ifAbsent: [ self error: 'undefined role: ' , roleName ].
	class := self basicNewClassNamed: className asSymbol.
	class
		role: (self newRoleNamed: roleName for: class);
		yourself.
	^ class
]

{ #category : #binding }
LanguageModel >> bindingOf: aSymbol [
	| result |
	result := self
		classNamed: aSymbol
		ifAbsent: [ nil ]
		ifPresent: [ :class | 
			class ensureRemote.
			class ].
	result := result
		ifNil: [ (self globalVariableNamed: aSymbol) ifNil: [ ^ nil ] ].
	^ self newGlobalBindingFor: aSymbol
]

{ #category : #'bootstrap - build kernel' }
LanguageModel >> bootstrap [
	self prepareBuilder.
	builder
		installClasses;
		installMethods;
		installProcess.
	^ self spurImage
]

{ #category : #'api - browse code' }
LanguageModel >> browse [
	self browseAs: self name
]

{ #category : #'compatibility - calypso' }
LanguageModel >> browseAs: browserTitleString [ 
	| clyEnv clyNavEnv browser |
	clyEnv := ClyEspell2Environment new.
	clyEnv environment: self.
	clyEnv name: browserTitleString.

	clyNavEnv := (ClyNavigationEnvironment over: clyEnv)
		addPlugin: ClyDefaultSystemEnvironmentPlugin new;
	   attachToSystem.

	browser := ClyFullBrowser new 
		navigationEnvironment: clyNavEnv;
		addPlugin: ClyStandardBrowserPlugin new.

	^ browser open.
]

{ #category : #'bootstrap - build model' }
LanguageModel >> build [
	self loadClassRoles.
	self loadKernel.
	self test.
	self loadRequiredClasses.
	self loadRequiredGlobalVariables.
	self loadGlobalVariables.
	self loadClassesFromRepository.
	self loadClasses.
	self test.
	"apply custom transformations implemented using MOP"
	self transform.
	self transformClasses.
	self loadEntryPoint.
	self test
]

{ #category : #'accessing kernel backend' }
LanguageModel >> builder [
	^ builder
]

{ #category : #testing }
LanguageModel >> canGenerate [
	^ self allClasses isNotNil and: [ self allClasses isNotEmpty ]
]

{ #category : #'accessing classes - special' }
LanguageModel >> classAssociation [
	^ self classWithRole: #Association
]

{ #category : #'accessing classes - special' }
LanguageModel >> classBlockClosure [
	^ self classWithRole: #BlockClosure
]

{ #category : #'accessing classes' }
LanguageModel >> classByRole: aString [ 
	"We try to return the class using the accessors because accessors know how to handle situations in which a role has not been defined in the dictionary, but another role can replace it (for example the role classClassVariable can be replaces by the class with the role Association. The method classWithRole: should remain private"
	| role |
	role := [ self roleOfClassNamed: aString ]
			on: PBClassDefinitionNotFound 
			do: [ aString ].
	
	^ [self perform: ('class', role) asSymbol] on: Error do: [ nil ]
]

{ #category : #'accessing classes' }
LanguageModel >> classByRoleOrName: aString [
	^ self classByRoleOrName: aString ifAbsent: [ PBClassDefinitionNotFound signal ]
]

{ #category : #'accessing classes' }
LanguageModel >> classByRoleOrName: aString ifAbsent: aBlock [
		"extending the original classByRoleOrName:ifAbsent: method to consider searching classes by system mapping"
	|class|
	class := (self classNamed: aString ifAbsent: [ nil ]).
	class ifNil: [ class := self classByRole: aString ].
	class ifNil: [ class := self classBySystemMapping: aString ifAbsent: [ nil ] ].
	class ifNil: [^ aBlock value].
	^ class
	
	"| class |
	class := (self classNamed: aString ifAbsent: [ nil ]).
	class ifNil: [ class := self classByRole: aString ].
	class ifNil: [^ aBlockClosure value].
	^ class"
]

{ #category : #'accessing classes' }
LanguageModel >> classBySystemMapping: aString [ 
	^ self classBySystemMapping: aString ifAbsent: [  PBClassDefinitionNotFound signal ]
]

{ #category : #hooks }
LanguageModel >> classBySystemMapping: aString ifAbsent: aBlockClosure [ 
	"Classes in metamodel map classes in the system according to systemClassMapping definition"
	| className |
	className := self systemClassMapping at: aString ifAbsent: nil.
	className ifNil: [^ aBlockClosure value].
	^ self classNamed: className
]

{ #category : #'accessing classes - special' }
LanguageModel >> classCharacter [
	
	^ self classWithRole: #Character
]

{ #category : #'accessing classes - special' }
LanguageModel >> classClass [
	^ self classWithRole: #Class
]

{ #category : #'accessing classes - special' }
LanguageModel >> classContext [
	^ self classWithRole: #Context
]

{ #category : #'accessing classes - special' }
LanguageModel >> classDictionary [
	^ self classWithRole: #Dictionary
]

{ #category : #'accessing kernel backend' }
LanguageModel >> classLoader [
	^ self pbBootstrapper builder classLoader
]

{ #category : #'tonel repository' }
LanguageModel >> classNameFromMonticello: aString [ 
	^ aString
]

{ #category : #'accessing classes' }
LanguageModel >> classNamed: aString [
	^ self
		classNamed: aString asSymbol
		ifAbsent: [ PBClassDefinitionNotFound new
				key: aString;
				signal ]
]

{ #category : #'accessing classes' }
LanguageModel >> classNamed: aString ifAbsent: aBlockClosure [
	
	^ [ self classNamedExactly: aString ]
		on: KeyNotFound
		do: [["this is necessary because EPASTInterpreter has some class names hardcoded"
				self classWithRole: aString] on: Error do: aBlockClosure]
]

{ #category : #'accessing classes' }
LanguageModel >> classNamed: aString ifAbsent: absentBlock ifPresent: presentBlock [ 
	|result|
	result := self classNamed: aString ifAbsent: [nil].
	result
		ifNil: [ ^ absentBlock value ] 
		ifNotNil: [ ^ presentBlock cull: result ]
]

{ #category : #'accessing classes' }
LanguageModel >> classNamed: aString ifPresent: aBlockClosure [ 
	|result|
	result := self classNamed: aString ifAbsent: [ nil ].
	result ifNotNil: [ ^ aBlockClosure cull: result ]
]

{ #category : #'accessing classes' }
LanguageModel >> classNamedExactly: aString [ 
	| aSymbol |
	aSymbol := aString ifNotNil: [ aString asSymbol ].
	^ self allClasses at: aSymbol
]

{ #category : #'accessing classes - special' }
LanguageModel >> classProcess [
	^ self classWithRole: #Process
]

{ #category : #'accessing classes - special' }
LanguageModel >> classProcessList [
	^ self classWithRole: #ProcessList
]

{ #category : #'accessing classes - special' }
LanguageModel >> classProcessorScheduler [
	^ self classWithRole: #ProcessorScheduler
]

{ #category : #'accessing classes - special' }
LanguageModel >> classProtoObject [
	
	^ self classWithRole: #ProtoObject
]

{ #category : #roles }
LanguageModel >> classRoles [
	^ classRoles
]

{ #category : #'accessing classes - special' }
LanguageModel >> classSmallInteger [
	
	^ self classWithRole: #SmallInteger
]

{ #category : #'accessing classes' }
LanguageModel >> classWithRole: aString [ 
	^ self classNamedExactly: (self classRoles at: aString )
]

{ #category : #cleaning }
LanguageModel >> cleanInstVars [
	| toRemove |
	toRemove := #() asOrderedCollection.
	" we remove duplicated inst vars due to missmatch between the basic espell classes definitions and the definitions found in Tonel repository"			
	self allClasses
		do: [ :class | 
			class slots
				do: [ :slot | 
					class superclass
						ifNotNil: [ :superclass | 
							(superclass allSlots contains: [ :s | s name = slot name ])
								ifTrue: [ toRemove add: slot ] ] ].
			toRemove do: [ :slot | class layout pvtRemoveSlot: slot ] .
			toRemove removeAll].
	" we recalculate the index of all slots "
	self allClasses
		do: [ :class |
			| index | 
			index := (class superclass
				ifNotNil: [ :superclass | superclass allSlots size ]
				ifNil: [ 0 ]).
			class slots do: [ :slot | slot index: (index := index + 1) ] ]
]

{ #category : #cleaning }
LanguageModel >> cleanPackages [
	"removing empty packages"
	| toRemove |
	toRemove := self packages select: [ :pkg | pkg definedBehaviors isEmpty ].
	toRemove do: [ :pkg | self packages removeKey: pkg name asSymbol ]
]

{ #category : #hooks }
LanguageModel >> createInitialObjects [
	"perform operations to initialize Classes classPools, or instructinos such as String initialize"
	
]

{ #category : #hooks }
LanguageModel >> createRemoteSystemDictionary [
	" return a new SystemDictionary instance, or nil if your language does not define a system dictionary"
	^ nil
]

{ #category : #hooks }
LanguageModel >> customClassRoles [
	"return an Array of Associations indicating role as key, and class name as value.
	Do not implement if:
	- you are loading your language model from a Tonel repo in which the role is indicated.
	- your classes have the same name as their role
	
	The returned value overrides roles read from your Tonel repo
	"
	^ nil
]

{ #category : #'api - code execution' }
LanguageModel >> debugEntryPoint [
	^ self debugCode: self entryPointCode
]

{ #category : #'initialization - default values' }
LanguageModel >> defaultBehaviors [
	
	^ IdentityDictionary new
]

{ #category : #'initialization - default values' }
LanguageModel >> defaultClassRoles [
	
	^ Role defaultClassRolesFor: self
]

{ #category : #'initialization - default values' }
LanguageModel >> defaultGlobalVariables [
	
	^ IdentitySet new
]

{ #category : #'initialization - default values' }
LanguageModel >> defaultPackage [
	^ self ensurePackageNamed: self defaultPackageName
]

{ #category : #'initialization - default values' }
LanguageModel >> defaultPackageName [
	^ #'Kernel-VM'
]

{ #category : #'initialization - default values' }
LanguageModel >> defaultPackages [
	| package |
	package := self newPackageModel 
		name: self defaultPackageName;
		parent: self;
		yourself.
	^ IdentityDictionary new
		at: package name put: package;
		yourself
]

{ #category : #testing }
LanguageModel >> definesPackageNamed: aString [ 
	| package |
	package := self packageNamed: aString ifAbsent: [ nil ].
	^ package isNotNil
]

{ #category : #'initialize-destroy' }
LanguageModel >> destroy [
	super destroy.
	
	classes ifNotNil: [ 
		classes do: [ :beh | beh destroy ].
		classes := nil.].
	
	packages ifNotNil: [ 
		packages do: [ :pac | pac destroy ].
		packages := nil.].
	
	globalVariables ifNotNil: [ 
		globalVariables do: [ :glob | glob destroy ].
		globalVariables := nil.].
		
	builder ifNotNil: [ 	
		builder pbRepository ifNotNil: [:repository | 
			repository bootstrapper ifNotNil: [ :bootstrapper |
					bootstrapper builder ifNotNil: [ :imageBuilder |
						imageBuilder espellBackend ifNotNil: [ :espellBackend |
							espellBackend destroy.
							 ].
						imageBuilder destroy.
						 ].	
				bootstrapper destroy.
				 ].
			repository destroy.
			 ].
		builder destroy.
	 ].
	builder := nil.
	pbBootstrapper := nil.
	backend ifNotNil: [ 
		backend destroy.
		backend := nil].
	
	announcer ifNotNil: [ 
		announcer subscriptions reset.
		announcer := nil.
		 ].
	
	instanceVariableMapping ifNotNil: [ 
		instanceVariableMapping destroy.
		instanceVariableMapping := nil ].
	
	tonelPath := nil.
	classRoles := nil
]

{ #category : #'bootstrap - build model classes' }
LanguageModel >> ensureClassNamed: aString [
	^ self
		classNamed: aString
		ifAbsent: [ | newBeh |
			newBeh := self newClassNamed: aString.
			self addClass: newBeh.
			newBeh ]
]

{ #category : #'tonel repository' }
LanguageModel >> ensureClassNamedFromMonticello: aString [
	^ self ensureClassNamed: (self classNameFromMonticello: aString)
]

{ #category : #'bootstrap - build model packages' }
LanguageModel >> ensurePackageNamed: aString [
	self assert: aString isNotNil.
	^ self packages
		at: aString asSymbol
		ifAbsent: [ | package |
			package := self newPackageModel
				name: aString asSymbol;
				parent: self;
				yourself.
			self addPackage: package.
			package ]
]

{ #category : #hooks }
LanguageModel >> entryPointClass [
	^ self classWithRole: #UndefinedObject
]

{ #category : #hooks }
LanguageModel >> entryPointCode [
	^ entryPointCode ifNil: [ Error signal: 'Undefined Entry Point. Define it using entryPointCode:' ]
]

{ #category : #hooks }
LanguageModel >> entryPointCode: aString [
	entryPointCode := aString 
]

{ #category : #hooks }
LanguageModel >> entryPointReceiver [
	^ 'nil'
]

{ #category : #hooks }
LanguageModel >> entryPointSelector [
	^ self class entryPointSelector
]

{ #category : #binding }
LanguageModel >> environment [ 
	^ self
]

{ #category : #'pharo name mapping' }
LanguageModel >> equivalentClassNameFromPharo: aPharoClassName [ 
	"ugly hardcoded way to get the equivalent name of a class in Pharo"
	self flag: 'Future Caro refactor me!'.
	^ (aPharoClassName endsWith: ' class')
		ifTrue: (aPharoClassName copyReplaceAll: ' class' with: 'Meta')
		ifFalse: aPharoClassName
]

{ #category : #'pharo name mapping' }
LanguageModel >> equivalentClassNameInPharo: aClassModelName [
	"ugly hardcoded way to get the equivalent name of a class in Pharo"
	self flag: 'Future Caro refactor me!'.
	^ (aClassModelName endsWith: 'Meta')
		ifTrue: (aClassModelName copyReplaceAll: 'Meta' with: ' class') 
		ifFalse: aClassModelName
]

{ #category : #'tonel repository' }
LanguageModel >> exportAsTonelRepository: aFileReference [
	(self packages select: [ :pkg | pkg isNotEmpty ])
		do: [ :aPackage | 
			| aSnapshot info aVersion |
			aSnapshot := aPackage asMCSnapshot.
			info := MCVersionInfo new.
			info instVarNamed: #name put: aPackage name , '-author'.
			aVersion := MCVersion
				package: (MCPackage new name: aPackage name)
				info: info
				snapshot: aSnapshot
				dependencies: #().
			EP2TonelWriter fileOut: aVersion on: aFileReference metamodel: self ]
]

{ #category : #hooks }
LanguageModel >> firstMetaclasses [
	"return a collection with the class model of metaclasses involved in circular metaclass references, e.g. { Metaclass . Metaclass class }"
	| depth maxDepth metaclasses found |
	maxDepth := self allClasses size.
	metaclasses := #() asOrderedCollection.
	self allClasses
		do: [ :class | 
			| seen current |
			found := false.
			depth := 0.
			current := class.
			seen := #() asOrderedCollection.
			[ depth > maxDepth or: [ found ] ]
				whileFalse: [ 
					current := current metaclass.
					(seen indexOf: current) > 0
						ifTrue: [ 
							metaclasses add: current.
							found := true ].
					seen add: current.
					depth := depth + 1. ] ].
	^ metaclasses asSet asOrderedCollection
]

{ #category : #'vm-constants' }
LanguageModel >> formatOfImmediate [
	^7
]

{ #category : #'bootstrap - build kernel' }
LanguageModel >> generate [
	self canGenerate ifFalse: [ self error: 'Failure, please build the language model using LanguageModel>>build' ].

	self test.
	self prepareBuilder.
	self builder installClasses.
	self builder installMethods.
	self builder installProcess.
	self testRemote.
	^ self spurImage
]

{ #category : #'bootstrap - build kernel' }
LanguageModel >> generateWriteAndExecute [
	self generate.
	self writeImage.
	^ self imageInDisk executeInVM
]

{ #category : #marking }
LanguageModel >> getAccessedBehaviorsBySimulatedExecution [ 
	^ self allClasses select: [ :beh | beh isMarkedAsAccessed ]
]

{ #category : #marking }
LanguageModel >> getAccessedMethodsBySimulatedExecution [
		^ (self allClasses flatCollect: #localMethods)
		select: [ :meth | meth isMarkedAsAccessed ]
]

{ #category : #'accessing global variables' }
LanguageModel >> globalVariableNamed: aString [
	self globalVariables
		do: [ :global | 
			global name = aString
				ifTrue: [ ^ global ] ].
	^ nil
]

{ #category : #'accessing global variables' }
LanguageModel >> globalVariables [
	^ globalVariables
]

{ #category : #'accessing global variables' }
LanguageModel >> globalVariablesSorted [
	^ self globalVariables asOrderedCollection sort: [ :g1 :g2 | g1 order < g2 order ]
]

{ #category : #'accessing global variables' }
LanguageModel >> globalWithRole: aString [ 
	| result |
	result := (globalVariables select: [ :global | global role = aString ]) .
	^ result isEmpty ifTrue: [ nil ] ifFalse: [ result anyOne ]
]

{ #category : #hooks }
LanguageModel >> hookGlobalNotFound: aString [
	| localClass |
	"load missing class from the system"
	localClass := Smalltalk classNamed: aString.
	localClass ifNil: [ ^ nil ].
	(self
		confirm: 'Load class ' , aString , ' from host system to model?')
		ifTrue: [ | newClass |
			"getting the class from the system"
			newClass := self class classModel new
				parent: self;
				initializeWithLocal: localClass;
				yourself.
			self addClass: newClass.
			^ newClass ]
]

{ #category : #hooks }
LanguageModel >> hookInitializeClassStubs [
	^ self newDummyInstruction 
]

{ #category : #hooks }
LanguageModel >> hookInitializeMethodDictionaryFor: anEP2RemoteClass [ 
	^ self newDummyInstruction   
]

{ #category : #hooks }
LanguageModel >> hookRegisterClass: anEP2RemoteClass named: aString [ 
	self deprecated: 'use ClassModel>>register'.
	^ self newDummyInstruction 
]

{ #category : #hooks }
LanguageModel >> hookSetSpecialObjectsArray: anEP2RemoteArray [
]

{ #category : #'accessing kernel backend' }
LanguageModel >> imageBuilder [
	self pbBootstrapper ifNil: [ ^ nil ].
	^ self pbBootstrapper builder
	
]

{ #category : #'accessing kernel' }
LanguageModel >> imageInDisk [
	^ imageInDisk
]

{ #category : #'accessing kernel' }
LanguageModel >> imageInMemory [
	^ self builder spurImage
]

{ #category : #roles }
LanguageModel >> immediateClassRoles [
	^ #(Character SmallInteger)
]

{ #category : #'initialize-destroy' }
LanguageModel >> initialize [ 
	super initialize.
	classes :=  self defaultBehaviors.
	packages := self defaultPackages.
	globalVariables := self defaultGlobalVariables.
	
	
]

{ #category : #hooks }
LanguageModel >> initializeRemoteGlobals [
	
	self deprecated: 'use LanguageModel>>loadGlobals, and set their initial value'.
]

{ #category : #hooks }
LanguageModel >> initializeSpecialObjectsArray [
	"stores a reference to the special objects array in a language element"
]

{ #category : #'bootstrap - build kernel configuration' }
LanguageModel >> installAccessedObjectsOnly [
	^ installAccessedObjectsOnly ifNil: [ installAccessedObjectsOnly := false ]
]

{ #category : #'bootstrap - build kernel configuration' }
LanguageModel >> installAccessedObjectsOnly: anObject [
	installAccessedObjectsOnly := anObject
]

{ #category : #hooks }
LanguageModel >> installClass: aClassDefinition [
	self deprecated: 'use ClassModel>>installBasic / installCustom instead'.
	aClassDefinition hookInstall.
	aClassDefinition testRemote.
	^ aClassDefinition remote
]

{ #category : #hooks }
LanguageModel >> installClasses [
	self allClasses do: #installBasic.
	self allClasses do: #installCustom
]

{ #category : #hooks }
LanguageModel >> installMethods [
	(self allClasses select: #isInstallable)
		do: [ :class | class installMethods ]
]

{ #category : #'vm-constants' }
LanguageModel >> instanceVariableMapping [
	
	^ instanceVariableMapping ifNil: [ instanceVariableMapping := PBInstanceVariableMappingGeneric on: self ]
]

{ #category : #retrocompatibility }
LanguageModel >> isClassDefinition: aString [ 
	^ false
]

{ #category : #testing }
LanguageModel >> isLanguageModel [
	^ true
]

{ #category : #'vm-constants' }
LanguageModel >> layoutClassForInstSpec: anInteger [
 ^ EP2Layout layoutClassForInstSpec: anInteger
]

{ #category : #'vm-constants' }
LanguageModel >> layoutForInstSpec: anInteger on: anEP2Class [
 ^ (self layoutClassForInstSpec: anInteger) on: anEP2Class 
]

{ #category : #'loading definitions' }
LanguageModel >> loadClassRoles [
	| defaultRoles customRoles |
	defaultRoles := self defaultClassRoles.
	customRoles := (self customClassRoles ifNil: [ #() ]) asDictionary.
	classRoles := #() asDictionary.
	"custom roles override default ones"
	customRoles
		associationsDo:
			[ :assoc | classRoles at: assoc key put: assoc value ].
	defaultRoles
		associationsDo: [ :assoc | 
			classRoles at: assoc key ifAbsentPut: assoc value ].
	^ classRoles
]

{ #category : #'loading definitions' }
LanguageModel >> loadClasses [
	
]

{ #category : #'loading definitions' }
LanguageModel >> loadClassesFromRepository [
	self tonelPath ifNotNil: [ :path | self loadTonelRepository: path ].
	self cleanInstVars.
	self cleanPackages.
	self allClasses do: [ :class | class initializeCustom ].
	self testCompletitude
]

{ #category : #'loading definitions' }
LanguageModel >> loadEntryPoint [
	| classUndefinedObject selector |
	"do not modify unless you know what you are doing"
	classUndefinedObject := self entryPointClass.
	selector := self entryPointSelector.
	classUndefinedObject
		addLocalMethodFromSource:
			selector, '
' , self entryPointCode asString
		selector: selector.

	^ self
]

{ #category : #hooks }
LanguageModel >> loadGlobalVariables [
	" create and instances of GlobalModel to this model, representing globals in the bootstrapped system"
	
]

{ #category : #'loading definitions' }
LanguageModel >> loadKernel [
	| objModel classModel |
	" load the first classes necessary to create the rest "
	" OVERRIDE if your language has implicit metaclasses "
	objModel := self basicNewClassWithRole: #ProtoObject.
	classModel := self basicNewClassWithRole: #Class.
	
	objModel superclass: nil.
	classModel superclass: objModel.
	
	self addClass: objModel.
	self addClass: classModel.
	
	objModel initialize.
	classModel initialize
]

{ #category : #'loading definitions' }
LanguageModel >> loadRequiredClasses [
	
	| missingRoles |
	" missing roles are those that were not loaded in the kernel "
	missingRoles := self classRoles keys asSet
		difference: (self allClasses values select: #hasRole thenCollect: [:class | class role name ]).
	missingRoles
		do: [ :aRole | 
			| class |
			class := self newClassWithRole: aRole.
			self addClass: class ].
	
	self test.
]

{ #category : #'loading definitions' }
LanguageModel >> loadRequiredGlobalVariables [
	self globalVariables
		add:
			((self class globalModel named: #Undeclared parent: self)
				role: 'Undeclared';
				initializationCode: [ :remoteBackend | 
						EP2RemoteDictionary newWithBackend: remoteBackend ];
				yourself);
		add:
			((self class globalModel named: #Processor parent: self)
				role: #Processor;
				initializationCode: [ :anEspellBackend | 
					| processor processList |
					processor := (self classWithRole: #ProcessorScheduler) ensureRemote
						basicNew asRemoteScheduler.
					processList := (self classWithRole: #Array) ensureRemote basicNew: 5.
					1 to: 5 do: [ :index | 
						| process |
						process := (self classWithRole: #ProcessList) ensureRemote basicNew.
						processList at: index put: process ].
					processor suspendedProcessList: processList.
					processor ])
]

{ #category : #'tonel repository' }
LanguageModel >> loadTonelRepository: aFileReference [
	| tonel packagesNames mcClassDefinitions | 
	tonel := EP2TonelRepository new
		directory: aFileReference asFileReference;
		metamodel: self. 
	packagesNames := tonel packageDescriptionsFromReadableFileNames collect: [:each | each at: 1].
	self assert: packagesNames isNotEmpty description: 'The repository is empty'.

	mcClassDefinitions := #() asOrderedCollection.
	packagesNames	do: [ :pn | | package snap version |
			package := self ensurePackageNamed: pn.
			version := tonel versionWithInfo: (tonel versionInfoFromVersionNamed: pn).
			snap := version snapshot.
			snap definitions do: [ :each |
				each ensureEspellDefinitionIn: self package: package.
				each isClassDefinition ifTrue: [mcClassDefinitions add: each].
			 ]].
	mcClassDefinitions do: [ :each | 
		(self classNamed: (self classNameFromMonticello: each name)) extendLayoutWithMonticello: each
		 ]
	
]

{ #category : #'tonel repository' }
LanguageModel >> loadTonelRepository: aTonelRepository packagesNames: aCollection classesNames: anUndefinedObject [
	"I exist for compatibility reasons"
	self loadTonelRepository: aTonelRepository directory
]

{ #category : #marking }
LanguageModel >> markMaybeAccessedBehaviorsAsAccessed [
	"We mark as accessed all behaviors that were previously marked as maybe accessed"
	(self allClasses
		select: [ :beh | beh propertyNamed: self maybeAccessedPropertyName ifAbsent: [ false ] ])
		do: [ :beh | beh removePropertyNamed: self maybeAccessedPropertyName.
			beh propertyNamed: self objectAccessedPropertyName put: true ]
]

{ #category : #marking }
LanguageModel >> maybeAccessedPropertyName [
	^ #maybeAccessed
]

{ #category : #'accessing kernel backend' }
LanguageModel >> methodBuilder [
	^ self pbBootstrapper builder methodBuilder
]

{ #category : #'bootstrap - build model classes' }
LanguageModel >> newClassNamed: aString [
	^ (self basicNewClassNamed: aString asSymbol)
		initialize;
		yourself
]

{ #category : #'bootstrap - build model classes' }
LanguageModel >> newClassWithRole: aString [ 
	| class |
	class := self basicNewClassWithRole: aString.
	class superclass: self classProtoObject.
	class initialize.
	^ class
]

{ #category : #binding }
LanguageModel >> newGlobalBindingFor: aSymbol [
	^ EP2GlobalBinding new
		name: aSymbol;
		objectSpace: self objectSpace;
		yourself
]

{ #category : #instanciation }
LanguageModel >> newPackageModel [
	^ self class newPackageModel
]

{ #category : #roles }
LanguageModel >> newRoleNamed: aString for: anObjectModel [
	^ Role named: aString for: anObjectModel
]

{ #category : #marking }
LanguageModel >> objectAccessedPropertyName [ 
	^ markAccessed ifNil: [ markAccessed := #accessed ]
]

{ #category : #marking }
LanguageModel >> objectAccessedPropertyName: aString [ 
	markAccessed := aString
]

{ #category : #'accessing kernel backend' }
LanguageModel >> objectSpace [
	^pbBootstrapper builder objectSpace
]

{ #category : #'accessing packages' }
LanguageModel >> packageFor: anEP2MBehavior [
	^ (self packages
		select: [ :package | package definesBehavior: anEP2MBehavior ])
		ifEmpty: [ nil ]
		ifNotEmpty: [ :collection | 
			collection size > 1
				ifTrue: [ self
						error:
							'Class #' , anEP2MBehavior name
								, ' contained by more than one package' ].
			collection anyOne ]
]

{ #category : #'accessing packages' }
LanguageModel >> packageNamed: aString [ 
	^ self packages at: aString asSymbol
]

{ #category : #'accessing packages' }
LanguageModel >> packageNamed: aString ifAbsent: aBlockClosure [ 
	^ [self packageNamed: aString] on: KeyNotFound do: [ aBlockClosure value ]
]

{ #category : #'accessing packages' }
LanguageModel >> packages [
	^ packages
]

{ #category : #'accessing kernel backend' }
LanguageModel >> pbBootstrapper [
	^ pbBootstrapper
]

{ #category : #'accessing kernel backend' }
LanguageModel >> pbBootstrapper: aPBBootstrapGeneric [ 
	pbBootstrapper := aPBBootstrapGeneric
]

{ #category : #'bootstrap - build kernel' }
LanguageModel >> prepareBuilder [
	| repo |
	builder ifNotNil: [ builder destroy ].
		 
	repo := PBRepository new 
		systemDefinition: self;
		bootstrapper: PBBootstrapGeneric for32Bits;
		yourself.
	
	builder := PBBuilder new
		bootstrapping: true;
		pbRepository: repo;
		imageName: self name.
		
	builder initializeImage
	
]

{ #category : #printing }
LanguageModel >> printOn: aStream [
	aStream 
		nextPutAll: 'a Language "';
		nextPutAll: self name asString;
		nextPutAll: '"'
]

{ #category : #hooks }
LanguageModel >> registerClass: remoteClass fromDefinition: aClassModel [ 
	
	self classLoader
		registerClass: remoteClass asRemoteClass
		definition: aClassModel
		fullyLoaded: true.
	aClassModel register
]

{ #category : #'accessing kernel objects' }
LanguageModel >> remote [
	"we use the imageBuilder to interact with the kernel"
	^ self pbBootstrapper builder
]

{ #category : #'bootstrap - build model classes' }
LanguageModel >> removeBehavior: aMClass [
	self deprecated: 'Use #removeClass: instead.' transformWith: '`@receiver removeBehavior:`@arg' -> '`@receiver removeClass:`@arg'.
	self classNamed: aMClass name ifPresent: [ classes removeKey: aMClass name ]
]

{ #category : #'bootstrap - build model classes' }
LanguageModel >> removeClass: aClassMode [
	self classNamed: aClassMode name ifPresent: [ classes removeKey: aClassMode name ]
]

{ #category : #marking }
LanguageModel >> removeFromAllElementsPropertyNamed: aString [ 
	self allClasses do: [ :beh | 
			beh removePropertyNamed: aString.
			beh localMethods do: [ :meth | meth removePropertyNamed: aString ].
		 ]
]

{ #category : #marking }
LanguageModel >> removeMaybeAccessedPropertyFromAllBehaviors [
	"We remove the property maybeAccessed from all behaviors"
	(self allClasses do: [ :beh | beh removePropertyNamed: self maybeAccessedPropertyName ])
		
]

{ #category : #roles }
LanguageModel >> roleOfClass: anOLClass [ 
	^ [ self classRoles keyAtValue: anOLClass name ] on: ValueNotFound do: [ nil ]
]

{ #category : #roles }
LanguageModel >> roleOfClassNamed: aString [ 
	^ [self classRoles keyAtValue: aString]
		on: ValueNotFound 
		do: [(self classRoles includesKey: aString)
				ifTrue: [ aString ]
				ifFalse: [ PBClassDefinitionNotFound signal: 'class "', aString, '" not found' ]]
]

{ #category : #'accessing kernel' }
LanguageModel >> spurImage [
	^ builder spurImage
]

{ #category : #hooks }
LanguageModel >> systemClassMapping [
	^ {
		"#ProtoObject -> #ProtoObject.
		#Object -> #ProtoObject.
		#Behavior -> #Class.
		#ClassDescription -> #Class
		"} asDictionary 
]

{ #category : #testing }
LanguageModel >> test [
	self assert: self name isNotNil.
	" cycles in inheritance chain are forbidden "
	self allClasses do: [ :class | class test ].
	self globalVariables do: [ :glob | glob test ]
]

{ #category : #testing }
LanguageModel >> testCompletitude [
	self allClasses
		do: [ :class | 
			self
				assert: class layout isNotNil
				description:
					'Class #' , class name
						,
							' referenced in the properties of another class (such as superclass or metaclass) but not defined' ]
]

{ #category : #testing }
LanguageModel >> testRemote [
	self allClasses do: [ :class | class testRemote ]
]

{ #category : #testing }
LanguageModel >> testRemoteStub [
	self allClasses do: [ :class | 
		class remoteIsInstalled ifTrue: [ class testRemoteStub ] ]
]

{ #category : #testing }
LanguageModel >> testStub [
	(self allClasses
		select: [ :class | class remote isNotNil ]) do: #testStub
]

{ #category : #'tonel repository' }
LanguageModel >> tonelPath [ 
	^ tonelPath 
]

{ #category : #'tonel repository' }
LanguageModel >> tonelPath: aFileReference [
	tonelPath := aFileReference
]

{ #category : #hooks }
LanguageModel >> transform [
	"for the user to define custom transformations on the language model post default roles creation"
	self subclassResponsibility 
]

{ #category : #hooks }
LanguageModel >> transformClasses [
	self allClasses do: #transform
]

{ #category : #metamodel }
LanguageModel >> undeclaredVariableModel [
	^ UndeclaredVariableModel
]

{ #category : #'bootstrap - build kernel' }
LanguageModel >> writeImage [
	^ imageInDisk := [builder writeImage] ensure: [ builder destroy ]
]
