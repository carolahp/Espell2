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
		'behaviors',
		'backend',
		'pbBootstrapper',
		'instanceVariableMapping',
		'classRoles',
		'markAccessed',
		'announcer',
		'builder',
		'entryPointCode',
		'imageInDisk',
		'installAccessedObjectsOnly'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'accessing - defaults' }
LanguageModel class >> defaultPackagesListFull [
	^ nil
]

{ #category : #'accessing - defaults' }
LanguageModel class >> entryPointSelector [
	^ #entryPoint
]

{ #category : #metamodel }
LanguageModel class >> globalModel [
	" return the subclass of GlobalModel used to represent globals in your language "
	self subclassResponsibility 
]

{ #category : #metamodel }
LanguageModel class >> indexedSlotModel [
	self deprecated: 'use ClassModel>>indexedSlotModel'.
	^ IndexedSlotModel
]

{ #category : #metamodel }
LanguageModel class >> instanceVariableSlotModel [
	^ InstanceVariableSlotModel 
]

{ #category : #metamodel }
LanguageModel class >> metaclassModel [
	" Return the subclass of ClassModel that defines the metamodel for classes of the language "
	self subclassResponsibility  
]

{ #category : #metamodel }
LanguageModel class >> methodModel [ 
	self deprecated: 'use ClassModel >> methodModel'
	
]

{ #category : #instantiation }
LanguageModel class >> new [
	self error: 'use methods in protocol instantiation'
]

{ #category : #instantiation }
LanguageModel class >> newFromDefaultModelWithName: aString1 withEntryPoint: aString2 [
	^ self
		newFromModel: PBBootstrapGeneric baseLanguageModelRepository location
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
LanguageModel class >> tempVariableModel [
	self deprecated: 'use ClassModel>>tempVariableModel'.
	^ TempVariableModel 
]

{ #category : #'hooks-dynamic method loading' }
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

{ #category : #'accessing backend' }
LanguageModel >> addBehavior: aMClass [
	self
		classNamed: aMClass name
		ifAbsent: [ 
			self behaviors at: aMClass name put: aMClass ]
		ifPresent: [ :found | 
			aMClass = found
				ifFalse: [ self error: 'trying to replace existent behavior' ]
				ifTrue: [ found ] ]
]

{ #category : #'accessing backend' }
LanguageModel >> addBehaviorFromMonticelloDefinition: aMCClassDefinition [
	| newClass mcDef |
	mcDef := aMCClassDefinition.				
	newClass := self ensureClassNamed: aMCClassDefinition className.
	newClass extendWithMonticello: mcDef.
	newClass extendWithMonticelloCustom: mcDef.
	" we can't test yet since not all classes have been loaded "
	^ newClass
	
]

{ #category : #'accessing global variables' }
LanguageModel >> addGlobalVariable: anEP2MGlobalVariable [
	self globalVariables add: anEP2MGlobalVariable
]

{ #category : #'accessing backend' }
LanguageModel >> addMethodFromMonticelloDefinition: aMCMethodDefinition [ 
	| methodDef classDef mcDef className |
	mcDef := aMCMethodDefinition.
	className := mcDef classIsMeta ifTrue: [mcDef className, self metaclassSuffix] ifFalse: [mcDef className]. 
	classDef := self ensureClassNamed: className.
	methodDef := classDef ensureLocalMethodNamed: mcDef selector.
	methodDef extendWithMonticello: mcDef.
	^ methodDef
]

{ #category : #'accessing backend' }
LanguageModel >> addPackage: aPackageModel [
	
	self assert: (self definesPackageNamed: aPackageModel name) not.
	self packages at: aPackageModel name asSymbol put: aPackageModel
	
]

{ #category : #'accessing classes' }
LanguageModel >> allClasses [
	^ self behaviors
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
		select: [ :beh | beh isBehavior and: [ beh role isNotNil ] ]
]

{ #category : #announcer }
LanguageModel >> announcer [

	^ announcer ifNil: [ announcer := LanguageModelAnnouncer new ]
]

{ #category : #calypso }
LanguageModel >> at: aSymbol [
self halt.
	^ self classNamed: aSymbol
]

{ #category : #'compiler compatibility' }
LanguageModel >> at: aString ifAbsent: aBlockClosure [ 
	"returns nil because this method is used to get CompiledMethod for generating Compiled Method instances durin the bootstrap"
	^ aBlockClosure value
]

{ #category : #'accessing backend' }
LanguageModel >> backend [
	^ backend ifNil: [ backend := LanguageModelBackend for: self ]
]

{ #category : #'accessing backend' }
LanguageModel >> behaviors [ 
	^ behaviors
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

{ #category : #bootstrap }
LanguageModel >> bootstrap [
	self prepareBuilder.
	builder
		installClasses;
		installMethods;
		installProcess.
	^ self spurImage
]

{ #category : #'browse-code' }
LanguageModel >> browse [
	self browseAs: self name
]

{ #category : #browser }
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

{ #category : #accessing }
LanguageModel >> builder [
	^ builder
]

{ #category : #testing }
LanguageModel >> canGenerate [
	^ self behaviors isNotNil and: [ self behaviors isNotEmpty ]
]

{ #category : #'accessing special classes' }
LanguageModel >> classAssociation [
	^ self classWithRole: #Association
]

{ #category : #'accessing special classes' }
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

{ #category : #'accessing special classes' }
LanguageModel >> classCharacter [
	
	^ self classWithRole: #Character
]

{ #category : #'accessing special classes' }
LanguageModel >> classClass [
	^ self classMetaclass 
]

{ #category : #'accessing special classes' }
LanguageModel >> classClassVariable [
	self deprecated: 'install in your subclass of LanguageModel'.
	^ [ self classWithRole: #ClassVariable ] on: KeyNotFound 
			do: [ self classWithRole: #Association ]
]

{ #category : #'accessing special classes' }
LanguageModel >> classContext [
	^ self classWithRole: #Context
]

{ #category : #'accessing special classes' }
LanguageModel >> classDictionary [
	^ self classWithRole: #Dictionary
]

{ #category : #'accessing remote backend' }
LanguageModel >> classLoader [
	^ self pbBootstrapper builder classLoader
]

{ #category : #'accessing special classes' }
LanguageModel >> classMetaclass [
	^ self classWithRole: #Metaclass
]

{ #category : #'accessing backend' }
LanguageModel >> classNamed: aString [ 
	^ self classNamed: aString ifAbsent: [ PBClassDefinitionNotFound new key: aString; signal ]
]

{ #category : #'accessing backend' }
LanguageModel >> classNamed: aString ifAbsent: aBlockClosure [
	^ [ self classNamedExactly: aString ]
		on: KeyNotFound
		do: aBlockClosure
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

{ #category : #'accessing backend' }
LanguageModel >> classNamedExactly: aString [ 
	| aSymbol |
	aSymbol := aString ifNotNil: [ aString asSymbol ].
	^ self behaviors at: aSymbol
]

{ #category : #'accessing special classes' }
LanguageModel >> classProcess [
	^ self classWithRole: #Process
]

{ #category : #'accessing special classes' }
LanguageModel >> classProcessList [
	^ self classWithRole: #ProcessList
]

{ #category : #'accessing special classes' }
LanguageModel >> classProcessorScheduler [
	^ self classWithRole: #ProcessorScheduler
]

{ #category : #'accessing special classes' }
LanguageModel >> classProtoObject [
	
	^ self classWithRole: #ProtoObject
]

{ #category : #hooks }
LanguageModel >> classRoles [
	^ classRoles
]

{ #category : #roles }
LanguageModel >> classRolesFromTonel: aFileReference [
	| tonel packagesNames result definedClasses |
	self
		flag:
			'I am reading the tonel repo twice, now and when I load the definitions. 
	Refactor me!'.
	result := #() asDictionary.
	definedClasses := #() asOrderedCollection.
	tonel := EP2TonelRepository new
		directory: aFileReference asFileReference;
		metamodel: self.
	packagesNames := tonel packageDescriptionsFromReadableFileNames
		collect: [ :each | each at: 1 ].
	self
		assert: packagesNames isNotEmpty
		description: 'The repository is empty'.
	packagesNames
		do: [ :pn | 
			| package snap version |
			package := self ensurePackageNamed: pn.
			version := tonel
				versionWithInfo: (tonel versionInfoFromVersionNamed: pn).
			snap := version snapshot.
			snap definitions
				do: [ :each | 
					(each isKindOf: EP2MCClassDefinition)
						ifTrue: [ definedClasses add: each name.
							each role
								ifNotNil: [ result at: each role asSymbol put: each name ] ] ] ].
	"I am putting the next code here just to prevent reading the tonel repo twice, but this screams for a refactor"
	"(self customClassRoles ifNil: #())
		do: [ :assoc | 
			self
				assert: (definedClasses anySatisfy: [ :defclass | defclass = assoc value ])
				description: [ 'Class "
					"' , assoc value, '" 
					"mentioned in >>customClassRoles is not defined in Tonel' ] ]."
	^ result
]

{ #category : #'accessing special classes' }
LanguageModel >> classSmallInteger [
	
	^ self classWithRole: #SmallInteger
]

{ #category : #'accessing classes' }
LanguageModel >> classWithRole: aString [ 
	^ self classNamedExactly: (self classRoles at: aString "ifAbsent: [ aString ]")
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
	^ self subclassResponsibility 
]

{ #category : #hooks }
LanguageModel >> createRemoteSystemDictionary [
	" return a new SystemDictionary instance, or nil if your language does not define a system dictionary"
	self subclassResponsibility 
]

{ #category : #roles }
LanguageModel >> customClassRoles [
	"return an Array of Associations indicating role as key, and class name as value.
	Do not implement if:
	- you are loading your language model from a Tonel repo in which the role is indicated.
	- your classes have the same name as their role
	
	The returned value overrides roles read from your Tonel repo
	"
	self subclassResponsibility 
]

{ #category : #'evaluation debugging' }
LanguageModel >> debugEntryPoint [
	^ self debugCode: self entryPointCode
]

{ #category : #'default model values' }
LanguageModel >> defaultBehaviors [
	
	^ IdentityDictionary new
]

{ #category : #'default model values' }
LanguageModel >> defaultClassRoles [
	" get roles from EP2Remote subclasses"
	| templates |
	templates := (EP2Remote allSubclasses add: EP2Remote; yourself).
	^ ((templates select: [ :each | each role isNotNil ])
		collect: [ :each | each role asSymbol -> each role asSymbol ])
		asDictionary
]

{ #category : #'default model values' }
LanguageModel >> defaultGlobalVariables [
	
	^ IdentitySet new
]

{ #category : #'default model values' }
LanguageModel >> defaultPackage [
	^ self packageNamed: self defaultPackageName
]

{ #category : #'default model values' }
LanguageModel >> defaultPackageName [
	^ #'Kernel-VM'
]

{ #category : #'default model values' }
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
	
	behaviors ifNotNil: [ 
		behaviors do: [ :beh | beh destroy ].
		behaviors := nil.].
	
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
	
	tonelPath := nil
]

{ #category : #'creating classes' }
LanguageModel >> ensureClassNamed: aString [
	^ self
		classNamed: aString
		ifAbsent: [ | newBeh |
			newBeh := self class metaclassModel named: aString parent: self.
			self addBehavior: newBeh.
			newBeh ]
]

{ #category : #'accessing backend' }
LanguageModel >> ensurePackageNamed: aString [

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

{ #category : #accessing }
LanguageModel >> environment [ 
	^ self
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
	self subclassResponsibility 
]

{ #category : #refactor }
LanguageModel >> fixCircularInheritance [
	self allClasses
		do: [ :class | 
			class superclass = self
				ifTrue: [ class superclass: nil ].
			class metaclass superclass 
				ifNil: [ class metaclass superclass: self classMetaclass ] ]
]

{ #category : #'vm-constants' }
LanguageModel >> formatOfImmediate [
	^7
]

{ #category : #api }
LanguageModel >> generate [
	self canGenerate ifFalse: [ self error: 'Failure, please instantiate the language model' ].

	self test.
	self prepareBuilder.
	self testRemoteStub.
	self builder installClasses.
	self builder installMethods.
	self builder installProcess.
	self testRemote.
	^ self spurImage
]

{ #category : #api }
LanguageModel >> generateWriteAndExecute [
	self generate.
	self writeImage.
	self imageInDisk executeInVM
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

{ #category : #binding }
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
LanguageModel >> hookCreateMetaclassStubWithClassLoader: aPBClassLoaderGeneric [ 
	self deprecated: 'use hooks in EP2MClass instead'.
	
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
			newClass := self class metaclassModel new
				parent: self;
				initializeWithLocal: localClass;
				yourself.
			self addBehavior: newClass.
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
LanguageModel >> hookInitializeProcessScheduler [ 
	self deprecated: 'Use the GlobalModel with role #Processor instead'
	"|code|
	code := 'Processor := ProcessorScheduler basicNew.
				Processor initProcessLists.'.
	^ (self newInstruction
		code: code;
		temps: #();
		yourself ) evaluate
"
]

{ #category : #hooks }
LanguageModel >> hookRegisterClass: anEP2RemoteClass fromDefinition: anOLClass withLoader: aPBClassLoaderGeneric [ 
	self halt.
	^ self newDummyInstruction
]

{ #category : #hooks }
LanguageModel >> hookRegisterClass: anEP2RemoteClass named: aString [ 
	
	^ self newDummyInstruction 
]

{ #category : #hooks }
LanguageModel >> hookSetSpecialObjectsArray: anEP2RemoteArray [
	^ nil
]

{ #category : #'accessing remote backend' }
LanguageModel >> imageBuilder [
	self pbBootstrapper ifNil: [ ^ nil ].
	^ self pbBootstrapper builder
	
]

{ #category : #api }
LanguageModel >> imageInDisk [
	^ imageInDisk
]

{ #category : #api }
LanguageModel >> imageInMemory [
	^ self builder spurImage
]

{ #category : #'class roles' }
LanguageModel >> immediateClassRoles [
	^ #(Character SmallInteger)
]

{ #category : #initialization }
LanguageModel >> initialize [ 
	behaviors :=  self defaultBehaviors.
	packages := self defaultPackages.
	globalVariables := self defaultGlobalVariables.
	self loadClassRoles.
	self loadRequiredBehaviors.
	self loadRequiredGlobalVariables.
	self loadGlobalVariables.
	"load definitions from Tonel if corresponds"
	self loadClasses.
	"load entry point"
	self loadEntryPoint.
	"apply custom transformations implemented using MOP"
	self transform.
	self test.
	
]

{ #category : #hooks }
LanguageModel >> initializeRemoteGlobals [
	^ nil
]

{ #category : #hooks }
LanguageModel >> initializeSpecialObjectsArray [
	self subclassResponsibility 
]

{ #category : #accessing }
LanguageModel >> installAccessedObjectsOnly [
	^ installAccessedObjectsOnly ifNil: [ installAccessedObjectsOnly := false ]
]

{ #category : #accessing }
LanguageModel >> installAccessedObjectsOnly: anObject [
	installAccessedObjectsOnly := anObject
]

{ #category : #hooks }
LanguageModel >> installClass: aClassDefinition [
	
	aClassDefinition hookInstall.
	aClassDefinition testRemote.
	^ aClassDefinition remote
]

{ #category : #hooks }
LanguageModel >> installClasses [
	(self allClasses select: #isInstallable) do: #install
]

{ #category : #hooks }
LanguageModel >> installMethods [
	(self allClasses select: #isInstallable)
		do: [ :class | class installMethods ]
]

{ #category : #'installing stubs' }
LanguageModel >> installMulticlassStubs: aCollection [
	| names classes |
	" ensure the metaclass of each class-model in the collection is present  "
	names := aCollection collect: #name.
	classes := #() asOrderedCollection.
	aCollection
		do: [ :class | 
			(names anySatisfy: [ :c | c = class metaclass name ])
				ifFalse: [ classes add: class metaclass ] ].
	classes addAll: aCollection.
	"calculate index in class table"
	classes
		do: [ :class | 
			class indexInClassTable
				ifNil: [ class indexInClassTable: self classLoader newClassIndex ] ].
	"create stubs for each class and register"
	classes
		do: [ :class | 
			class remoteIsInstalled
				ifFalse: [ class installStubBasic ] ].
	classes do: [ :class | class testStub ]
]

{ #category : #hooks }
LanguageModel >> installStubs [
	
	self installMulticlassStubs: self firstMetaclasses "self allClassesWithRole"
]

{ #category : #'vm-constants' }
LanguageModel >> instanceVariableMapping [
	
	^ instanceVariableMapping ifNil: [ instanceVariableMapping := PBInstanceVariableMappingGeneric on: self ]
]

{ #category : #retrocompatibility }
LanguageModel >> isClassDefinition: aString [ 
	^ false
]

{ #category : #'vm-constants' }
LanguageModel >> layoutClassForInstSpec: anInteger [
 ^ EP2Layout layoutClassForInstSpec: anInteger
]

{ #category : #'vm-constants' }
LanguageModel >> layoutForInstSpec: anInteger on: anEP2Class [
 ^ (self layoutClassForInstSpec: anInteger) on: anEP2Class 
]

{ #category : #'load definitions - from tonel' }
LanguageModel >> loadBaseLanguageModelDefinitions [
	self deprecated: 'Use loadClasses leaving the variable tonelPath as default'.
	self loadLanguageModelDefinitions: PBBootstrapGeneric baseLanguageModelRepository location
]

{ #category : #roles }
LanguageModel >> loadClassRoles [
	| defaultRoles rolesFromTonel customRoles |
	defaultRoles := self defaultClassRoles.
	rolesFromTonel := (self tonelPath
		ifNotNil: [ :path | self classRolesFromTonel: path ]
		ifNil: [ #() ]) asDictionary.
	
	customRoles := (self customClassRoles ifNil: [ #() ]) asDictionary.
	"initialize the instance var classRoles with no values"
	classRoles := #() asDictionary.
	defaultRoles
		associationsDo: [ :assoc | 
			| theRole theClass classDefault classTonel classCustom |
			theRole := assoc key.
			classDefault := assoc value.
			classTonel := rolesFromTonel at: theRole ifAbsent: [ nil ].
			classCustom := customRoles at: theRole ifAbsent: [ nil ].
			(classTonel isNotNil and: [ classCustom isNotNil ])
				ifTrue: [ self
						assert: classTonel = classCustom
						description:
							'role ' , theRole
								, ' is different between tonel repository and method >>customClassRoles' ].
			theClass := classCustom
				ifNil: [ classTonel ifNil: [ classDefault ] ].
			classRoles at: theRole put: theClass ].
	^ classRoles
]

{ #category : #hooks }
LanguageModel >> loadClasses [
	self tonelPath
		ifNotNil: [ :path | self loadTonelRepository: path ]
]

{ #category : #hooks }
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
	self subclassResponsibility 
]

{ #category : #'load definitions - required' }
LanguageModel >> loadKernel [
	| objModel classModel |
	" load the first classes necessary to create the rest "
	" OVERRIDE if your language has implicit metaclasses "
	objModel := self newBehaviorFromTemplate: EP2RemoteEmpty.
	objModel superclass: nil.
	self addBehavior: objModel.
	classModel := self newBehaviorFromTemplate: EP2RemoteClass.
	classModel superclass: objModel.
	self addBehavior: classModel.
	objModel initializeWithTemplate: EP2RemoteEmpty.
	classModel initializeWithTemplate: EP2RemoteClass.
]

{ #category : #'load definitions - from tonel' }
LanguageModel >> loadLanguageModelDefinitions: aFileReference [
	self deprecated: 'Use loadTonelRepository: self tonelPath'.
	tonelPath := aFileReference.
	self loadTonelRepository: aFileReference
]

{ #category : #'load definitions - required' }
LanguageModel >> loadRequiredBehaviors [
	| objModel classModel |
	"we load object and class first because they are special in the inheritance chain. 
	Object is the root and class is instance of itself"

	self loadKernel.
	" recursive call to load subclasses"
	EP2Remote
		subclassesDo: [ :subclass | self loadRequiredBehaviorsRecursive: subclass ].	
	"self class classMetaclass allClassModelInstVarNames do: [ :ivName | classModel addSlot: ivName ]."
]

{ #category : #'load definitions - required' }
LanguageModel >> loadRequiredBehaviorsRecursive: aClassEP2Remote [
	| template model |
	template := aClassEP2Remote.
	template role ifNotNil: [ 
		model := self newBehaviorFromTemplate: template.
		"self haltIf: (model name = #Object)."
		
		model initializeWithTemplate: aClassEP2Remote.
		self addBehavior: model ].
	" Recursive call to load subclasses "
	template
		subclassesDo: [ :subclass | self loadRequiredBehaviorsRecursive: subclass ]
]

{ #category : #requirements }
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
	| tonel packagesNames  | 
	tonel := EP2TonelRepository new
		directory: aFileReference asFileReference;
		metamodel: self. 
	packagesNames := tonel packageDescriptionsFromReadableFileNames collect: [:each | each at: 1].
	self assert: packagesNames isNotEmpty description: 'The repository is empty'.

	packagesNames	do: [ :pn | | package snap version |
			package := self ensurePackageNamed: pn.
			version := tonel versionWithInfo: (tonel versionInfoFromVersionNamed: pn).
			snap := version snapshot.
			snap definitions do: [ :each |
				each ensureEspellDefinitionIn: self package: package
			 ]].
	self fixCircularInheritance.
	self testCompletitude.
	self cleanInstVars.
	self cleanPackages.
	
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

{ #category : #'accessing remote backend' }
LanguageModel >> methodBuilder [
	^ self pbBootstrapper builder methodBuilder
]

{ #category : #'accessing backend' }
LanguageModel >> newBehaviorFromMonticelloDefinition: aMCClassDefinition [.
	self deprecated: 'use extendWithMonticello: instead'.
	^ (self class metaclassModel
				named: aMCClassDefinition className
				parent: self) 
				initializeWithMonticello: aMCClassDefinition;
				yourself 
]

{ #category : #'accessing backend' }
LanguageModel >> newBehaviorFromTemplate: aClassEP2Remote [
	| template model modelName |
	template := aClassEP2Remote.
	modelName := self classRoles at: template role.
	model := self ensureClassNamed: modelName.
	model template: template.
	model layout: (template layoutClass on: model).
	template modelInstVarNames doWithIndex: [ :ivname :index| model addSlot: ivname index: index ].
	(self packageNamed: self defaultPackageName) addDefinedBehavior: model.
	^ model
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

{ #category : #marking }
LanguageModel >> objectAccessedPropertyName [ 
	^ markAccessed ifNil: [ markAccessed := #accessed ]
]

{ #category : #marking }
LanguageModel >> objectAccessedPropertyName: aString [ 
	markAccessed := aString
]

{ #category : #'accessing remote backend' }
LanguageModel >> objectSpace [
	^pbBootstrapper builder objectSpace
]

{ #category : #'accessing backend' }
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

{ #category : #'accessing backend' }
LanguageModel >> packageNamed: aString [ 
	^ self packages at: aString asSymbol
]

{ #category : #accessing }
LanguageModel >> packageNamed: aString ifAbsent: aBlockClosure [ 
	^ [self packageNamed: aString] on: KeyNotFound do: [ aBlockClosure value ]
]

{ #category : #'accessing backend' }
LanguageModel >> packages [
	^ packages
]

{ #category : #accessing }
LanguageModel >> pbBootstrapper [
	^ pbBootstrapper
]

{ #category : #accessing }
LanguageModel >> pbBootstrapper: aPBBootstrapGeneric [ 
	pbBootstrapper := aPBBootstrapGeneric
]

{ #category : #bootstrap }
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

{ #category : #'accessing remote objects' }
LanguageModel >> remote [
	"we use the imageBuilder to interact with the kernel"
	^ self pbBootstrapper builder
]

{ #category : #'accessing backend' }
LanguageModel >> removeBehavior: aMClass [
	self classNamed: aMClass name ifPresent: [ behaviors removeKey: aMClass name ]
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

{ #category : #'class roles' }
LanguageModel >> roleOfClass: anOLClass [ 
	^ [ self classRoles keyAtValue: anOLClass name ] on: ValueNotFound do: [ nil ]
]

{ #category : #'class roles' }
LanguageModel >> roleOfClassNamed: aString [ 
	^ [self classRoles keyAtValue: aString]
		on: ValueNotFound 
		do: [(self classRoles includesKey: aString)
				ifTrue: [ aString ]
				ifFalse: [ PBClassDefinitionNotFound signal: 'class "', aString, '" not found' ]]
]

{ #category : #accessing }
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

{ #category : #metamodel }
LanguageModel >> tempVariableModel [
	self deprecated: 'use MethodModel>>tempVariableModel'.
	^ self class tempVariableModel
]

{ #category : #testing }
LanguageModel >> test [
	| model metamodel modelVars metamodelVars modelVarsLast metamodelVarsEnd modelVarsFirst object |
	self assert: self name isNotNil.
	
	model := self classWithRole: 'Metaclass'.
	metamodel := self class metaclassModel.
	
	modelVars := model allInstVarNames.
	metamodelVars := metamodel
		allClassModelInstVarNames.
	modelVarsLast := (modelVars
		copyFrom: 4
		to: modelVars size) asIdentitySet.
	metamodelVarsEnd := (metamodelVars
		copyFrom: 4
		to: metamodelVars size) asIdentitySet.
	modelVarsFirst := metamodelVars copyFrom: 1 to: 3.
	self
		assert: (modelVars beginsWith: modelVarsFirst)
		description:
			'The first 3 instance variables of "' , model name
				, '" must be ' , modelVarsFirst asString.
	self
		assert: (modelVarsLast asSet difference: metamodelVarsEnd asSet) isEmpty
		description:
			'The class ' , metamodel asString
				, ' must define the same instance variables than'
				, model asString.
	
	self behaviors do: [ :beh | beh testFull ].
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

{ #category : #accessing }
LanguageModel >> tonelPath [ 
	^ tonelPath 
]

{ #category : #accessing }
LanguageModel >> tonelPath: aFileReference [
	tonelPath := aFileReference
]

{ #category : #hooks }
LanguageModel >> transform [
	"for the user to define custom transformations on the language model post default roles creation"
	self subclassResponsibility 
]

{ #category : #api }
LanguageModel >> writeImage [
	^ imageInDisk := [builder writeImage] ensure: [ builder destroy ]
]
