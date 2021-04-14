"
Use as follows:
	|language|
	""instantiates the model""
	language := (LanguageModel 
		named: 'MyLanguage' 
		withEntryPoint: 'System log: ''hola!''. System quit.').
	
	""generates the kernel and executes it using an external VM""
	language generateAndRun.
	
	""loads the generated kernel file into the host (current image) and executes it using the VM simulator""
	language runImageLoadedFromFile.
	
"
Class {
	#name : #LanguageModel,
	#superclass : #ObjectModel,
	#instVars : [
		'bindings',
		'pbRepository',
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
		'image'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'hooks-api' }
LanguageModel class >> classMetaclass [
	" Return the subclass of EP2MClass that defines the metamodel for classes of the language "
	self subclassResponsibility 
]

{ #category : #'accessing-packages' }
LanguageModel class >> defaultPackagesListFull [
	^ nil
]

{ #category : #'hooks-api' }
LanguageModel class >> indexedSlotMetaclass [
	^ IndexedSlotModel
]

{ #category : #'hooks-api' }
LanguageModel class >> instanceVariableSlotMetaclass [
	^ InstanceVariableSlotModel 
]

{ #category : #'hooks-api' }
LanguageModel class >> methodMetaclass [ 
	self deprecated: 'use ClassModel >> methodMetaclass'
	
]

{ #category : #'hooks-api' }
LanguageModel class >> named: aName withEntryPoint: someCode [
	^ self new 
		name: aName; 
			loadTonelRepository: './bootstrap/language-definitions-new-repo/KernelExplicitGit/KernelExplicitMetaclasses';
			entryPointCode: someCode;
			loadCustomClasses;
			yourself.

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
	^ newClass
	
]

{ #category : #'accessing globals' }
LanguageModel >> addGlobalVariable: anEP2MGlobalVariable [
	self globalVariables add: anEP2MGlobalVariable
]

{ #category : #'accessing backend' }
LanguageModel >> addMethodFromMonticelloDefinition: aMCMethodDefinition [ 
	| methodDef classDef mcDef |
	mcDef := aMCMethodDefinition.
	classDef := self ensureClassNamed: mcDef className.
	methodDef := classDef ensureLocalMethodNamed: mcDef selector.
	methodDef extendWithMonticello: mcDef.
	^ methodDef
]

{ #category : #'accessing classes' }
LanguageModel >> allClasses [
	^ behaviors
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

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #calypso }
LanguageModel >> at: aSymbol [

	^ self classNamed: aSymbol
]

{ #category : #'accessing backend' }
LanguageModel >> backend [
	^ backend ifNil: [ backend := LanguageModelBackend for: self ]
]

{ #category : #'accessing backend' }
LanguageModel >> behaviors [ 
	^ behaviors
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
LanguageModel >> classClass [
	^ self classMetaclass 
]

{ #category : #'accessing special classes' }
LanguageModel >> classClassVariable [
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
		do: [[self classWithRole: aString] on: Error do: aBlockClosure]
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
LanguageModel >> classProcessorScheduler [
	^ self classWithRole: #ProcessorScheduler
]

{ #category : #'accessing special classes' }
LanguageModel >> classProtoObject [
	
	^ self classWithRole: #ProtoObject
]

{ #category : #hooks }
LanguageModel >> classRoles [
	^ classRoles ifNil: [ classRoles := {
		#ProtoObject -> #Object.
		#ProcessorScheduler -> #ProcessorScheduler.
		#Context -> #Context.
		#Metaclass -> #Class.
		#Array -> #Array.
		#MethodDictionary -> #MethodDictionary . 
		#CompiledMethod -> #CompiledMethod.
		#Character -> #Character. 
		#ByteArray -> #ByteArray.
		#Association -> #Association.
		#BlockClosure -> #BlockClosure.
		#Point -> #Point.
		#Process -> #Process.
		#ByteString -> #ByteString.
		#ByteSymbol -> #ByteSymbol.
		#True -> #True.
		#False -> #False.
		#UndefinedObject -> #UndefinedObject.
		#Float -> #Float.
		#SmallInteger -> #SmallInteger.
		#LargePositiveInteger -> #LargePositiveInteger.
		#LargeNegativeInteger -> #LargeNegativeInteger.
		#Dictionary -> #Dictionary.
		#Message -> #Message.
		#SmalltalkImage -> #SmalltalkImage.
		"unnecessary"
		#ArrayedCollection -> #ArrayedCollection.
		#String -> #String.
		#Symbol -> #Symbol.
		#SystemDictionary -> #SystemDictionary.
		#Magnitude -> #Magnitude.
		#Number -> #Number.
		#Integer -> #Integer.
		#ProcessList -> #ProcessList
		} asDictionary ] 
]

{ #category : #'accessing special classes' }
LanguageModel >> classSmalltalkImage [
	^ self classWithRole: #SmalltalkImage
]

{ #category : #'accessing classes' }
LanguageModel >> classWithRole: aString [ 
	^ self classNamedExactly: (self classRoles at: aString ifAbsent: [ aString ])
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
	toRemove do: [ :pkg | self packages remove: pkg ]
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
LanguageModel >> defaultGlobalVariables [
	
	^ (IdentitySet new)
		add: ((GlobalModel named: #Processor parent: self) role: #Processor);
		add: ((GlobalModel named: #Undeclared parent: self) role: #Undeclared);
		yourself
]

{ #category : #'default model values' }
LanguageModel >> defaultPackages [
	| package |
	package := PackageModel new
		name: #'Kernel-VM';
		parent: self;
		yourself.
	^ IdentityDictionary new
		at: package name put: package;
		yourself
]

{ #category : #'initialize-destroy' }
LanguageModel >> destroy [
	backend ifNotNil: [ 
		backend environment: nil ].
	backend := nil.
	behaviors do: [ :beh | beh parent: nil ].
	behaviors := nil.
	packages := nil.
	globalVariables := nil.
	
]

{ #category : #'creating classes' }
LanguageModel >> ensureClassNamed: aString [
	^ self
		classNamed: aString
		ifAbsent: [ | newBeh |
			newBeh := self class classMetaclass named: aString parent: self.
			self addBehavior: newBeh.
			newBeh ]
]

{ #category : #'accessing backend' }
LanguageModel >> ensurePackageNamed: aString [

	^ self packages
		at: aString
		ifAbsent: [ | package |
			package := PackageModel new
				name: aString asSymbol;
				parent: self;
				yourself.
			self packages at: package name put: package.
			package ]
]

{ #category : #hooks }
LanguageModel >> entryPointCode [
	^ entryPointCode ifNil: [ Error signal: 'Undefined Entry Point. Define it using entryPointCode:' ]
]

{ #category : #hooks }
LanguageModel >> entryPointCode: aString [
	entryPointCode := aString 
]

{ #category : #'tonel repository' }
LanguageModel >> exportAsTonelRepository: aFileReference [ 
	
	(self packages select: [:pkg | pkg isNotEmpty]) do: [ :aPackage |
		| aSnapshot info aVersion |
		aSnapshot := aPackage asMCSnapshot.

		info := MCVersionInfo new.
		info instVarNamed: #name put: aPackage name, '-author'.
		aVersion := MCVersion package: (MCPackage new name: aPackage name) info: info snapshot: aSnapshot dependencies: #().
		
		EP2TonelWriter 
			fileOut: (aVersion)
			on: aFileReference
			metamodel: self ]
]

{ #category : #refactor }
LanguageModel >> fixCircularInheritance [
	self allClasses do: [ :class | class superclass = self ifTrue: [ class superclass: nil ] ]
]

{ #category : #'vm-constants' }
LanguageModel >> formatOfImmediate [
	^7
]

{ #category : #api }
LanguageModel >> generate [
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
LanguageModel >> generateAndRun [
	self generate.
	self writeImage runBashScript.
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

{ #category : #'accessing globals' }
LanguageModel >> globalVariables [
	^ globalVariables
]

{ #category : #'accessing roles' }
LanguageModel >> globalWithRole: aString [ 
	| result |
	result := (globalVariables select: [ :global | global role = aString ]) .
	^ result isEmpty ifTrue: [ nil ] ifFalse: [ result anyOne ]
]

{ #category : #hooks }
LanguageModel >> hookCreateInitialObjects [
	^ self newDummyInstruction 
]

{ #category : #hooks }
LanguageModel >> hookCreateMetaclassStubWithClassLoader: aPBClassLoaderGeneric [ 
	self deprecated: 'use hooks in EP2MClass instead'.
	self subclassResponsibility 
]

{ #category : #hooks }
LanguageModel >> hookCreateSmalltalkInstance [
	^ nil
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
			newClass := self class classMetaclass new
				parent: self;
				initializeWithLocal: localClass;
				yourself.
			self addBehavior: newClass.
			^ newClass ]
]

{ #category : #hooks }
LanguageModel >> hookInitalizeGlobals [
	^ self newDummyInstruction evaluate
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
	| processor processList |

	processor := (self classWithRole: #ProcessorScheduler) remote basicNew asRemoteScheduler.
	processList := (self classWithRole: #Array) remote basicNew: 5.
	1 to: 5 do: [ :index | 
		| process |
		process := (self classWithRole: #ProcessList) remote basicNew.
		processList at: index put: process ].
	processor suspendedProcessList: processList.
	
	^ processor
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
LanguageModel >> hookInitializeSpecialObjectsArray [
	self subclassResponsibility 
]

{ #category : #hooks }
LanguageModel >> hookInstallClass: aClassDefinition [
	
	aClassDefinition hookInstall.
	aClassDefinition testRemote.
	^ aClassDefinition remote
]

{ #category : #hooks }
LanguageModel >> hookInstallClasses [
	self allClasses do: [ :class | 
		class hookInstall ]
]

{ #category : #hooks }
LanguageModel >> hookInstallMethods [
	self allClasses do: [ :class | class installMethods ]
]

{ #category : #hooks }
LanguageModel >> hookInstallStubs [
	^ self allClassesWithRole do: [ :each |
		each installStub ]
]

{ #category : #hooks }
LanguageModel >> hookNewSystemDictionary [
	self deprecated: 'return the system dictionary fom the hookInitializeGlobals'.
	^ self newDummyInstruction evaluate
]

{ #category : #hooks }
LanguageModel >> hookRegisterClass: remoteClass fromDefinition: anOLClass [ 
	
	self classLoader
		registerClass: remoteClass asRemoteClass
		definition: anOLClass
		fullyLoaded: true.
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

{ #category : #api }
LanguageModel >> image [ 
	^ image
]

{ #category : #'accessing remote backend' }
LanguageModel >> imageBuilder [
	^ self pbBootstrapper builder
]

{ #category : #api }
LanguageModel >> imageLoadedFromFile [
	^ EP2SpurImage onFile: self image imageFileReference.
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
	self loadRequiredBehaviors
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

{ #category : #hooks }
LanguageModel >> loadCustomClasses [
	| metaclass methodDoIt methodStart |
	metaclass := self classMetaclass.

	methodDoIt := metaclass
		addLocalMethodFromSource:
			'entryPoint 
	' , metaclass name , ' start'
		selector: 'entryPoint'.

	methodStart := metaclass
		addLocalMethodFromSource:
			'start 
	' , self entryPointCode
		selector: 'start'.

	^ self
]

{ #category : #initialization }
LanguageModel >> loadRequiredBehaviors [
	| objModel classModel |
	"we load object and class first because they are special in the inheritance chain. 
	Object is the root and class is instance of itself"

	objModel := self newBehaviorFromTemplate: EP2Remote.
	objModel superclass: nil.
	self addBehavior: objModel.
	classModel := self newBehaviorFromTemplate: EP2RemoteClass.
	self addBehavior: classModel.
	objModel initializeWithTemplate: EP2Remote.
	classModel initializeWithTemplate: EP2RemoteClass.
	" recursive call to load subclasses"
	EP2Remote
		subclassesDo: [ :subclass | self loadRequiredBehaviorsRecursive: subclass ].	
	self class classMetaclass slots do: [ :slot | classModel addSlot: slot name ].
	
	
]

{ #category : #initialization }
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
	self test.
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
	^ (self class classMetaclass
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
	self packages anyOne addDefinedBehavior: model.
	^ model
]

{ #category : #marking }
LanguageModel >> objectAccessedPropertyName [ 
	^ markAccessed
]

{ #category : #marking }
LanguageModel >> objectAccessedPropertyName: aString [ 
	markAccessed := aString
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
	^ self packages at: aString
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

{ #category : #accessing }
LanguageModel >> pbRepository: aPBRepository [ 
	pbRepository := aPBRepository 
]

{ #category : #bootstrap }
LanguageModel >> prepareBuilder [
	| repo |
	builder ifNotNil: [ builder destroy ].
	self assert: self name isNotNil.
		 
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

{ #category : #'accessing remote objects' }
LanguageModel >> remote [
	"we use the imageBuilder to interact with the kernel"
	^ self pbBootstrapper builder
]

{ #category : #'accessing backend' }
LanguageModel >> removeBehavior: aMClass [
	self classNamed: aMClass name ifPresent: [ self halt ]
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

{ #category : #api }
LanguageModel >> runImage [ 
	^ self image runBashScript 
]

{ #category : #api }
LanguageModel >> runImageLoadedFromFile [
	^ self imageLoadedFromFile run
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

{ #category : #testing }
LanguageModel >> test [
	self behaviors do: [ :beh | beh test ]
]

{ #category : #testing }
LanguageModel >> testCompletitude [
	self allClasses do: [ :class | self assert: class layout isNotNil description: 'Class #', class name, ' referenced in the properties of another class (like superclass) but not defined' ].
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

{ #category : #api }
LanguageModel >> writeImage [
	^ image := [builder writeImage] ensure: [ builder destroy ]
]