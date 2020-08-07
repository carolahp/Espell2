"
I am an abstract class that defines the metamodel of a bootstrapped language.
Subclass me to define the metamodel of your own language.

To bootstrap a new language using the bootstrapper UI, open the UI evaluating 'PBBuilder new openUI' and put the name of your subclass in the 'metaclass' textfield, fill the name of your new language and push the button ""New Repository""
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
		'pbBootstrapper',
		'backend',
		'instanceVariableMapping',
		'classRoles',
		'markAccessed',
		'announcer'
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
	" Return the subclass of EP2MSlot that defines the metamodel for slots of the language "
	self subclassResponsibility 
]

{ #category : #'hooks-api' }
EP2MLanguage class >> instanceVariableSlotMetaclass [
	" Return the subclass of EP2MSlot that defines the metamodel for slots of the language "
	self subclassResponsibility 
]

{ #category : #'hooks-api' }
EP2MLanguage class >> methodMetaclass [
	self subclassResponsibility 
]

{ #category : #'hooks-dynamic method loading' }
EP2MLanguage >> actionDoesNotUnderstand: aRBMessageNode receiver: aRemoteObject [
	|selector classModel systemClass methodModel|
	selector := aRBMessageNode selector.
	classModel := self classNamed: aRemoteObject basicClass classNameFromAnyOrigin.
	systemClass := Smalltalk classNamed: classModel name.
	[systemClass isNotNil] whileTrue: [
		systemClass methodDict 
			at: aRBMessageNode selector asSymbol 
			ifPresent: [:method | |newMethodModel| 
				classModel :=	self classNamed: systemClass name ifAbsent: [self error: 'class not found'].
				newMethodModel := self class methodMetaclass newFromLocal: method.
				self halt.
				classModel addLocalMethod: newMethodModel
				].
		
		systemClass := systemClass superclass ]
	
	 
]

{ #category : #'accessing backend' }
EP2MLanguage >> addBehavior: aMClass [
	self classNamed: aMClass name ifAbsent: [ self behaviors at: aMClass name put: aMClass ]
]

{ #category : #'accessing backend' }
EP2MLanguage >> addBehaviorFromTemplate: aClassEP2Remote [
	| template model |
	template := aClassEP2Remote.
	model := self
		classNamed: template role
		ifAbsent: [ self class classMetaclass named: template role parent: self ].
	self addBehavior: model.
	self packages anyOne addDefinedBehavior: model.
	
	^ model
]

{ #category : #'accessing classes' }
EP2MLanguage >> allClasses [
	^ behaviors
]

{ #category : #'accessing classes' }
EP2MLanguage >> allClassesAndTraits [
	^ self allClasses
]

{ #category : #'accessing classes' }
EP2MLanguage >> allClassesWithRole [
	" classes with role are installed as Stubs at the beginning of bootstrap"

	^ self allClasses
		select: [ :beh | beh isBehavior and: [ beh role isNotNil ] ]
]

{ #category : #announcer }
EP2MLanguage >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #'accessing backend' }
EP2MLanguage >> backend [
	^ backend ifNil: [ backend := EP2MLanguageBackend for: self ]
]

{ #category : #'accessing backend' }
EP2MLanguage >> behaviors [ 
	^ behaviors
]

{ #category : #'browse-code' }
EP2MLanguage >> browse [
	self halt.
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classAssociation [
	^ self classWithRole: #Association
]

{ #category : #'accessing classes' }
EP2MLanguage >> classByRoleOrName: aString [ 
	^ self classNamed: aString
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classClass [
	^ self classWithRole: #Class
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
	^ self classClass
]

{ #category : #'accessing backend' }
EP2MLanguage >> classNamed: aString [ 
	^ self classNamed: aString ifAbsent: [ KeyNotFound new key: aString; signal ]
]

{ #category : #'accessing backend' }
EP2MLanguage >> classNamed: aString ifAbsent: aBlockClosure [
	| aSymbol |
	aSymbol := aString ifNotNil: [ aString asSymbol ].
	^ [ self behaviors at: aSymbol ]
		on: KeyNotFound
		do: [ aBlockClosure value ]
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
		#ProtoObject -> #ProtoObject.
		#ProcessorScheduler -> #ProcessorScheduler.
		#Context -> #MethodContext.
		#Class -> #Class.
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
		#Smalltalk -> #Smalltalk
		} asDictionary ] 
]

{ #category : #'accessing special classes' }
EP2MLanguage >> classSmalltalk [
	^ self classWithRole: #Smalltalk
]

{ #category : #'accessing classes' }
EP2MLanguage >> classWithRole: aString [ 
	^ self classNamed: aString
]

{ #category : #'default model values' }
EP2MLanguage >> defaultBehaviors [
	
	^ IdentityDictionary new
]

{ #category : #'default model values' }
EP2MLanguage >> defaultGlobalVariables [
	
	^ IdentitySet new
]

{ #category : #'default model values' }
EP2MLanguage >> defaultPackages [
	| package |
	package := EP2MPackage new
		name: #'Kernel-VM';
		parent: self;
		yourself.
	^ IdentitySet new
		add: package;
		yourself
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

{ #category : #'accessing globals' }
EP2MLanguage >> globalVariables [
	^ globalVariables
]

{ #category : #hooks }
EP2MLanguage >> hookCreateInitialObjects [
	self subclassResponsibility 
]

{ #category : #hooks }
EP2MLanguage >> hookCreateMetaclassStubWithClassLoader: aPBClassLoaderGeneric [ 
	self subclassResponsibility 
]

{ #category : #hooks }
EP2MLanguage >> hookInitializeClassStubs [
	^ self subclassResponsibility 
]

{ #category : #hooks }
EP2MLanguage >> hookInitializeMethodDictionaryFor: anEP2RemoteClass [ 
	^ self newDummyInstruction 
]

{ #category : #hooks }
EP2MLanguage >> hookInstallClass: anOLClass [ 
	self subclassResponsibility 
]

{ #category : #hooks }
EP2MLanguage >> hookInstallStubs [
	^ self allClassesWithRole do: [ :each |
		each installStub ]
]

{ #category : #hooks }
EP2MLanguage >> hookNewSystemDictionary [
	self subclassResponsibility .
]

{ #category : #hooks }
EP2MLanguage >> hookRegisterClass: anEP2RemoteClass fromDefinition: anOLClass withLoader: aPBClassLoaderGeneric [ 
	^ self newDummyInstruction
]

{ #category : #hooks }
EP2MLanguage >> hookRegisterClass: anEP2RemoteClass named: aString [ 
	^ self newDummyInstruction 
]

{ #category : #'as yet unclassified' }
EP2MLanguage >> immediateClassRoles [
	^ #(Character SmallInteger)
]

{ #category : #initialization }
EP2MLanguage >> initialize [ 
	behaviors :=  self defaultBehaviors.
	packages := self defaultPackages.
	globalVariables := self defaultGlobalVariables.
	self loadRequiredBehaviors.
	
]

{ #category : #'vm-constants' }
EP2MLanguage >> instanceVariableMapping [
	
	^ instanceVariableMapping ifNil: [ instanceVariableMapping := PBInstanceVariableMappingGeneric on: self ]
]

{ #category : #hooks }
EP2MLanguage >> instructionRegisterInstalledBehaviorInGlobals: anEP2RemoteClass [ 
	^ self newDummyInstruction 
]

{ #category : #initialization }
EP2MLanguage >> loadRequiredBehaviors [
	| objModel classModel |
	objModel := self addBehaviorFromTemplate: EP2Remote.
	classModel := self addBehaviorFromTemplate: EP2RemoteClass.
	objModel initializeWith: EP2Remote.
	classModel initializeWith: EP2RemoteClass.
	
	" recursive call to load subclasses"
	EP2Remote
		subclassesDo: [ :subclass | self loadRequiredBehaviorsRecursive: subclass ].
	
	self class classMetaclass slots do: [ :slot | classModel addSlot: slot name ].
]

{ #category : #initialization }
EP2MLanguage >> loadRequiredBehaviorsRecursive: aClassEP2Remote [
	| template model |
	template := aClassEP2Remote.
	model := self addBehaviorFromTemplate: template.
	model initializeWith: aClassEP2Remote.
	" Recursive call to load subclasses "
	template
		subclassesDo: [ :subclass | self loadRequiredBehaviorsRecursive: subclass ]
]

{ #category : #retrocompatibility }
EP2MLanguage >> loadTonelRepository: aTonelRepository packagesNames: aCollection classesNames: anUndefinedObject [
	"retrocompatibility" 
	^ self
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

{ #category : #'instruction hooks' }
EP2MLanguage >> newDummyInstruction [
	^ PBInstructionDummy new
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
		anyOne
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
