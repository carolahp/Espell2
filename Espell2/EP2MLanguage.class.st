"
I am an abstract class that defines the metamodel of a bootstrapped language.
Subclass me to define the metamodel of your own language.

=====================================================================
Example of usage:

"" Create your language model ""
myLanguage := OLObjVLisp new name: 'MyLanguage'.

"" Clone or download the basic definition of classes and methods required by the bootstrapper ""
$ git clone https://github.com/carolahp/KernelBasic.git

"" Load these definitions into your language model ""
myLanguage loadTonelRepository: './location/of/KernelBasic'.

"" Generate the image in memory ""
imageInMemory := myLanguage bootstrap.		

"" You can inspect the image at any moment during or after the bootstrap ""
imageInMemory inspect.

"" Write the image to disk ""
imageInDisk := myLanguage writeImage.

"" Run the image standalone using the Pharo VM ""
imageInDisk runBashScript

=====================================================================
Requirements:
- PharoBootstrapGeneric and its dependencies (including Espell2).

"
Class {
	#name : #EP2MLanguage,
	#superclass : #EP2MObject,
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
		'builder'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'hooks-api' }
EP2MLanguage class >> classMetaclass [
	" Return the subclass of EP2MClass that defines the metamodel for classes of the language "
	self subclassResponsibility 
]

{ #category : #'accessing-packages' }
EP2MLanguage class >> defaultPackagesListFull [
	^ nil
]

{ #category : #'hooks-api' }
EP2MLanguage class >> indexedSlotMetaclass [
	^ EP2MIndexedSlot
]

{ #category : #'hooks-api' }
EP2MLanguage class >> instanceVariableSlotMetaclass [
	^ EP2MInstanceVariableSlot 
]

{ #category : #'hooks-api' }
EP2MLanguage class >> methodMetaclass [ 
	^ EP2MMethod
]

{ #category : #'hooks-dynamic method loading' }
EP2MLanguage >> actionDoesNotUnderstand: aRBMessageNode receiver: aRemoteObject [
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
									classModel := class.
									newMethodModel := self class methodMetaclass
										named: method selector
										parent: classModel.
									newMethodModel initializeWithLocal: method.
									^ classModel addLocalMethod: newMethodModel ] ].
					self error: 'class not found' ].
			systemClass := systemClass superclass ].
		self error: 'Method #', aRBMessageNode selector ,' not found in host system!'
]

{ #category : #'accessing backend' }
EP2MLanguage >> addBehavior: aMClass [
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
EP2MLanguage >> addBehaviorFromMonticelloDefinition: aMCClassDefinition [
	| newClass mcDef |
	mcDef := aMCClassDefinition.
	newClass := self ensureClassNamed: aMCClassDefinition className.
	newClass extendWithMonticello: mcDef.
	^ newClass
	
]

{ #category : #'accessing globals' }
EP2MLanguage >> addGlobalVariable: anEP2MGlobalVariable [
	self globalVariables add: anEP2MGlobalVariable
]

{ #category : #'accessing backend' }
EP2MLanguage >> addMethodFromMonticelloDefinition: aMCMethodDefinition [ 
	| methodDef classDef mcDef |
	mcDef := aMCMethodDefinition.
	classDef := self ensureClassNamed: mcDef className.
	methodDef := self class methodMetaclass named: mcDef selector parent: classDef.
	methodDef extendWithMonticello: mcDef.
	classDef addLocalMethod: methodDef.
	^ methodDef
]

{ #category : #'accessing classes' }
EP2MLanguage >> allClasses [
	^ behaviors
]

{ #category : #'accessing classes' }
EP2MLanguage >> allClassesAndTraits [
	"added for compatibility"
	^ self allClasses
]

{ #category : #'accessing classes' }
EP2MLanguage >> allClassesWithRole [
	" classes with role are installed as Stubs at the beginning of bootstrap, they can be extended by loading classes from host system or from tonel repository"

	^ self allClasses
		select: [ :beh | beh isBehavior and: [ beh role isNotNil ] ]
]

{ #category : #announcer }
EP2MLanguage >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #calypso }
EP2MLanguage >> at: aSymbol [

	^ self classNamed: aSymbol
]

{ #category : #'accessing backend' }
EP2MLanguage >> backend [
	^ backend ifNil: [ backend := EP2MLanguageBackend for: self ]
]

{ #category : #'accessing backend' }
EP2MLanguage >> behaviors [ 
	^ behaviors
]

{ #category : #bootstrap }
EP2MLanguage >> bootstrap [
	self prepareBuilder.
	builder
		installClasses;
		installMethods;
		installProcess.
	^ self spurImage
]

{ #category : #'browse-code' }
EP2MLanguage >> browse [
	self browseAs: self name
]

{ #category : #browser }
EP2MLanguage >> browseAs: browserTitleString [ 
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
EP2MLanguage >> builder [
	^ builder
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classAssociation [
	^ self classWithRole: #Association
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classBlockClosure [
	^ self classWithRole: #BlockClosure
]

{ #category : #'accessing classes' }
EP2MLanguage >> classByRole: aString [ 
	"We try to return the class using the accessors because accessors know how to handle situations in which a role has not been defined in the dictionary, but another role can replace it (for example the role classClassVariable can be replaces by the class with the role Association. The method classWithRole: should remain private"
	| role |
	role := [ self roleOfClassNamed: aString ]
			on: PBClassDefinitionNotFound 
			do: [ aString ].
	
	^ [self perform: ('class', role) asSymbol] on: Error do: [ nil ]
]

{ #category : #'accessing classes' }
EP2MLanguage >> classByRoleOrName: aString [
	^ self classByRoleOrName: aString ifAbsent: [ PBClassDefinitionNotFound signal ]
]

{ #category : #'accessing classes' }
EP2MLanguage >> classByRoleOrName: aString ifAbsent: aBlock [
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
EP2MLanguage >> classBySystemMapping: aString [ 
	^ self classBySystemMapping: aString ifAbsent: [  PBClassDefinitionNotFound signal ]
]

{ #category : #hooks }
EP2MLanguage >> classBySystemMapping: aString ifAbsent: aBlockClosure [ 
	"Classes in metamodel map classes in the system according to systemClassMapping definition"
	| className |
	className := self systemClassMapping at: aString ifAbsent: nil.
	className ifNil: [^ aBlockClosure value].
	^ self classNamed: className
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classClass [
	^ self classMetaclass 
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classClassVariable [
	^ [ self classWithRole: #ClassVariable ] on: KeyNotFound 
			do: [ self classWithRole: #Association ]
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classContext [
	^ self classWithRole: #Context
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classDictionary [
	^ self classWithRole: #Dictionary
]

{ #category : #'accessing remote backend' }
EP2MLanguage >> classLoader [
	^ self pbBootstrapper builder classLoader
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classMetaclass [
	^ self classWithRole: #Metaclass
]

{ #category : #'accessing backend' }
EP2MLanguage >> classNamed: aString [ 
	^ self classNamed: aString ifAbsent: [ PBClassDefinitionNotFound new key: aString; signal ]
]

{ #category : #'accessing backend' }
EP2MLanguage >> classNamed: aString ifAbsent: aBlockClosure [
	^ [ self classNamedExactly: aString ]
		on: KeyNotFound
		do: [[self classWithRole: aString] on: Error do: aBlockClosure]
]

{ #category : #'accessing classes' }
EP2MLanguage >> classNamed: aString ifAbsent: absentBlock ifPresent: presentBlock [ 
	|result|
	result := self classNamed: aString ifAbsent: [nil].
	result
		ifNil: [ ^ absentBlock value ] 
		ifNotNil: [ ^ presentBlock cull: result ]
]

{ #category : #'accessing classes' }
EP2MLanguage >> classNamed: aString ifPresent: aBlockClosure [ 
	|result|
	result := self classNamed: aString ifAbsent: [ nil ].
	result ifNotNil: [ ^ aBlockClosure cull: result ]
]

{ #category : #'accessing backend' }
EP2MLanguage >> classNamedExactly: aString [ 
	| aSymbol |
	aSymbol := aString ifNotNil: [ aString asSymbol ].
	^ self behaviors at: aSymbol
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classProcess [
	^ self classWithRole: #Process
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classProcessorScheduler [
	^ self classWithRole: #ProcessorScheduler
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classProtoObject [
	
	^ self classWithRole: #ProtoObject
]

{ #category : #hooks }
EP2MLanguage >> classRoles [
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
		#Integer -> #Integer
		} asDictionary ] 
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classSmalltalkImage [
	^ self classWithRole: #SmalltalkImage
]

{ #category : #'accessing classes' }
EP2MLanguage >> classWithRole: aString [ 
	^ self classNamedExactly: (self classRoles at: aString ifAbsent: [ aString ])
]

{ #category : #cleaning }
EP2MLanguage >> cleanInstVars [
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
								ifTrue: [ toRemove add: slot name ] ] ].
			toRemove do: [ :slot | class removeSlot: slot ] .
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
EP2MLanguage >> cleanPackages [
	"removing empty packages"
	| toRemove |
	toRemove := self packages select: [ :pkg | pkg definedBehaviors isEmpty ].
	toRemove do: [ :pkg | self packages remove: pkg ]
]

{ #category : #'default model values' }
EP2MLanguage >> defaultBehaviors [
	
	^ IdentityDictionary new
]

{ #category : #'default model values' }
EP2MLanguage >> defaultGlobalVariables [
	
	^ (IdentitySet new)
		add: (EP2MGlobalVariable named: #Processor parent: self);
		add: (EP2MGlobalVariable named: #Undeclared parent: self);
		yourself
]

{ #category : #'default model values' }
EP2MLanguage >> defaultPackages [
	| package |
	package := EP2MPackage new
		name: #'Kernel-VM';
		parent: self;
		yourself.
	^ IdentityDictionary new
		at: package name put: package;
		yourself
]

{ #category : #'initialize-destroy' }
EP2MLanguage >> destroy [
	backend ifNotNil: [ 
		backend environment: nil ].
	backend := nil.
	behaviors do: [ :beh | beh parent: nil ].
	behaviors := nil.
	packages := nil.
	globalVariables := nil.
	
]

{ #category : #'creating classes' }
EP2MLanguage >> ensureClassNamed: aString [
	^ self
		classNamed: aString
		ifAbsent: [ | newBeh |
			newBeh := self class classMetaclass named: aString parent: self.
			self addBehavior: newBeh.
			newBeh ]
]

{ #category : #'accessing backend' }
EP2MLanguage >> ensurePackageNamed: aString [

	^ self packages
		at: aString
		ifAbsent: [ | package |
			package := EP2MPackage new
				name: aString asSymbol;
				parent: self;
				yourself.
			self packages at: package name put: package.
			package ]
]

{ #category : #'tonel repository' }
EP2MLanguage >> exportAsTonelRepository: aFileReference [ 
	
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
EP2MLanguage >> fixCircularInheritance [
	self allClasses do: [ :class | class superclass = self ifTrue: [ class superclass: nil ] ]
]

{ #category : #'vm-constants' }
EP2MLanguage >> formatOfImmediate [
	^7
]

{ #category : #marking }
EP2MLanguage >> getAccessedBehaviorsBySimulatedExecution [ 
	^ self allClasses select: [ :beh | beh isMarkedAsAccessed ]
]

{ #category : #marking }
EP2MLanguage >> getAccessedMethodsBySimulatedExecution [
		^ (self allClasses flatCollect: #localMethods)
		select: [ :meth | meth isMarkedAsAccessed ]
]

{ #category : #binding }
EP2MLanguage >> globalVariableNamed: aString [
	self globalVariables
		do: [ :global | 
			global name = aString
				ifTrue: [ ^ global ] ].
	^ nil
]

{ #category : #'accessing globals' }
EP2MLanguage >> globalVariables [
	^ globalVariables
]

{ #category : #hooks }
EP2MLanguage >> hookCreateInitialObjects [
	^ self newDummyInstruction 
]

{ #category : #hooks }
EP2MLanguage >> hookCreateMetaclassStubWithClassLoader: aPBClassLoaderGeneric [ 
	self deprecated: 'use hooks in EP2MClass instead'.
	self subclassResponsibility 
]

{ #category : #hooks }
EP2MLanguage >> hookEntryPoint [
	self subclassResponsibility 
]

{ #category : #hooks }
EP2MLanguage >> hookGlobalNotFound: aString [
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
EP2MLanguage >> hookInitalizeGlobals [
	^ self newDummyInstruction
]

{ #category : #hooks }
EP2MLanguage >> hookInitializeClassStubs [
	^ self newDummyInstruction 
]

{ #category : #hooks }
EP2MLanguage >> hookInitializeMethodDictionaryFor: anEP2RemoteClass [ 
	^ self newDummyInstruction   
]

{ #category : #hooks }
EP2MLanguage >> hookInitializeProcessScheduler [ 
	|code|
	code := 'Processor := ProcessorScheduler basicNew.
				Processor initProcessLists.'.
	
	^ (self newInstruction
		code: code;
		temps: #();
		yourself ) evaluate

]

{ #category : #hooks }
EP2MLanguage >> hookInstallClass: aClassDefinition [
	
	aClassDefinition hookInstall.
	aClassDefinition testRemote.
	^ aClassDefinition remote
]

{ #category : #hooks }
EP2MLanguage >> hookInstallClasses [
	self allClasses do: [ :class | 
		class hookInstall ]
]

{ #category : #hooks }
EP2MLanguage >> hookInstallMethods [
	self allClasses do: [ :class | class installMethods ]
]

{ #category : #hooks }
EP2MLanguage >> hookInstallStubs [
	^ self allClassesWithRole do: [ :each |
		each installStub ]
]

{ #category : #hooks }
EP2MLanguage >> hookNewSystemDictionary [
	^ self newDummyInstruction 
]

{ #category : #hooks }
EP2MLanguage >> hookRegisterClass: remoteClass fromDefinition: anOLClass [ 
	
	self classLoader
		registerClass: remoteClass asRemoteClass
		definition: anOLClass
		fullyLoaded: true.
]

{ #category : #hooks }
EP2MLanguage >> hookRegisterClass: anEP2RemoteClass fromDefinition: anOLClass withLoader: aPBClassLoaderGeneric [ 
	self halt.
	^ self newDummyInstruction
]

{ #category : #hooks }
EP2MLanguage >> hookRegisterClass: anEP2RemoteClass named: aString [ 
	
	^ self newDummyInstruction 
]

{ #category : #hooks }
EP2MLanguage >> hookSetSpecialObjectsArray: anEP2RemoteArray [
	^ self newDummyInstruction 
]

{ #category : #'accessing remote backend' }
EP2MLanguage >> imageBuilder [
	^ self pbBootstrapper builder
]

{ #category : #'class roles' }
EP2MLanguage >> immediateClassRoles [
	^ #(Character SmallInteger)
]

{ #category : #initialization }
EP2MLanguage >> initialize [ 
	behaviors :=  self defaultBehaviors.
	packages := self defaultPackages.
	globalVariables := self defaultGlobalVariables.
	self loadRequiredBehaviors
]

{ #category : #'vm-constants' }
EP2MLanguage >> instanceVariableMapping [
	
	^ instanceVariableMapping ifNil: [ instanceVariableMapping := PBInstanceVariableMappingGeneric on: self ]
]

{ #category : #retrocompatibility }
EP2MLanguage >> isClassDefinition: aString [ 
	^ false
]

{ #category : #'vm-constants' }
EP2MLanguage >> layoutClassForInstSpec: anInteger [
 ^ EP2Layout layoutClassForInstSpec: anInteger
]

{ #category : #'vm-constants' }
EP2MLanguage >> layoutForInstSpec: anInteger on: anEP2Class [
 ^ (self layoutClassForInstSpec: anInteger) on: anEP2Class 
]

{ #category : #hooks }
EP2MLanguage >> loadCustomClasses [
	^ self 
]

{ #category : #initialization }
EP2MLanguage >> loadRequiredBehaviors [
	| objModel classModel |
	"we load object and class first because they are special in the inheritance chain. 
	Object is the root and class is instance of itself"

	objModel := self newBehaviorFromTemplate: EP2Remote.
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
EP2MLanguage >> loadRequiredBehaviorsRecursive: aClassEP2Remote [
	| template model |
	template := aClassEP2Remote.
	template role ifNotNil: [ 
		model := self newBehaviorFromTemplate: template.
		model initializeWithTemplate: aClassEP2Remote.
		self addBehavior: model ].
	" Recursive call to load subclasses "
	template
		subclassesDo: [ :subclass | self loadRequiredBehaviorsRecursive: subclass ]
]

{ #category : #'tonel repository' }
EP2MLanguage >> loadTonelRepository: aFileReference [
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
EP2MLanguage >> loadTonelRepository: aTonelRepository packagesNames: aCollection classesNames: anUndefinedObject [
	"I exist for compatibility reasons"
	self loadTonelRepository: aTonelRepository directory
]

{ #category : #marking }
EP2MLanguage >> markMaybeAccessedBehaviorsAsAccessed [
	"We mark as accessed all behaviors that were previously marked as maybe accessed"
	(self allClasses
		select: [ :beh | beh propertyNamed: self maybeAccessedPropertyName ifAbsent: [ false ] ])
		do: [ :beh | beh removePropertyNamed: self maybeAccessedPropertyName.
			beh propertyNamed: self objectAccessedPropertyName put: true ]
]

{ #category : #marking }
EP2MLanguage >> maybeAccessedPropertyName [
	^ #maybeAccessed
]

{ #category : #'accessing remote backend' }
EP2MLanguage >> methodBuilder [
	^ self pbBootstrapper builder methodBuilder
]

{ #category : #'accessing backend' }
EP2MLanguage >> newBehaviorFromMonticelloDefinition: aMCClassDefinition [.
	self deprecated: 'use extendWithMonticello: instead'.
	^ (self class classMetaclass
				named: aMCClassDefinition className
				parent: self) 
				initializeWithMonticello: aMCClassDefinition;
				yourself 
]

{ #category : #'accessing backend' }
EP2MLanguage >> newBehaviorFromTemplate: aClassEP2Remote [
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
EP2MLanguage >> objectAccessedPropertyName [ 
	^ markAccessed
]

{ #category : #marking }
EP2MLanguage >> objectAccessedPropertyName: aString [ 
	markAccessed := aString
]

{ #category : #'accessing backend' }
EP2MLanguage >> packageFor: anEP2MBehavior [
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
EP2MLanguage >> packageNamed: aString [ 
	^ self packages at: aString
]

{ #category : #'accessing backend' }
EP2MLanguage >> packages [
	^ packages
]

{ #category : #accessing }
EP2MLanguage >> pbBootstrapper [
	^ pbBootstrapper
]

{ #category : #accessing }
EP2MLanguage >> pbBootstrapper: aPBBootstrapGeneric [ 
	pbBootstrapper := aPBBootstrapGeneric
]

{ #category : #accessing }
EP2MLanguage >> pbRepository: aPBRepository [ 
	pbRepository := aPBRepository 
]

{ #category : #bootstrap }
EP2MLanguage >> prepareBuilder [
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
EP2MLanguage >> printOn: aStream [
	aStream 
		nextPutAll: 'a Language "';
		nextPutAll: self name asString;
		nextPutAll: '"'
]

{ #category : #'accessing remote objects' }
EP2MLanguage >> remote [
	"we use the imageBuilder to interact with the kernel"
	^ self pbBootstrapper builder
]

{ #category : #'accessing backend' }
EP2MLanguage >> removeBehavior: aMClass [
	self classNamed: aMClass name ifPresent: [ self halt ]
]

{ #category : #marking }
EP2MLanguage >> removeFromAllElementsPropertyNamed: aString [ 
	self allClasses do: [ :beh | 
			beh removePropertyNamed: aString.
			beh localMethods do: [ :meth | meth removePropertyNamed: aString ].
		 ]
]

{ #category : #marking }
EP2MLanguage >> removeMaybeAccessedPropertyFromAllBehaviors [
	"We remove the property maybeAccessed from all behaviors"
	(self allClasses do: [ :beh | beh removePropertyNamed: self maybeAccessedPropertyName ])
		
]

{ #category : #'class roles' }
EP2MLanguage >> roleOfClass: anOLClass [ 
	^ [ self classRoles keyAtValue: anOLClass name ] on: ValueNotFound do: [ nil ]
]

{ #category : #'class roles' }
EP2MLanguage >> roleOfClassNamed: aString [ 
	^ [self classRoles keyAtValue: aString]
		on: ValueNotFound 
		do: [(self classRoles includesKey: aString)
				ifTrue: [ aString ]
				ifFalse: [ PBClassDefinitionNotFound signal: 'class "', aString, '" not found' ]]
]

{ #category : #accessing }
EP2MLanguage >> spurImage [
	^ builder spurImage
]

{ #category : #hooks }
EP2MLanguage >> systemClassMapping [
	^ {
		"#ProtoObject -> #ProtoObject.
		#Object -> #ProtoObject.
		#Behavior -> #Class.
		#ClassDescription -> #Class
		"} asDictionary 
]

{ #category : #testing }
EP2MLanguage >> test [
	self behaviors do: [ :beh | beh test ]
]

{ #category : #testing }
EP2MLanguage >> testCompletitude [
	self allClasses do: [ :class | self assert: class layout isNotNil description: 'Class #', class name, ' referenced in the properties of another class (like superclass) but not defined' ].
]

{ #category : #testing }
EP2MLanguage >> testRemote [
	self allClasses do: [ :class | class testRemote ]
]

{ #category : #testing }
EP2MLanguage >> testStub [
	self allClasses do: [ :class | 
		class remote isNotNilObject ifTrue: [ class remote asRemoteClass testStub ] ]
]

{ #category : #bootstrap }
EP2MLanguage >> writeImage [
	^ [builder writeImage] ensure: [ builder destroy ]
]
