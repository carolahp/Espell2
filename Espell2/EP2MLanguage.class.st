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
		'pbBootstrapper'
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

{ #category : #initialization }
EP2MLanguage >> addBehavior: aMClass [
	self classNamed: aMClass name ifAbsent: [ self behaviors at: aMClass name put: aMClass ]
]

{ #category : #initialization }
EP2MLanguage >> addBehaviorFromTemplate: aClassEP2Remote [
	| template model |
	template := aClassEP2Remote.
	model := self
		classNamed: template role
		ifAbsent: [ (self class classMetaclass
				named: template role parent: self)
				layout: template layoutClass;
				role: template role;
				yourself ].
	self addBehavior: model.
	self packages anyOne addDefinedBehavior: model.
	^ model
]

{ #category : #'accessing backend' }
EP2MLanguage >> behaviors [ 
	^ behaviors
]

{ #category : #'accessing model' }
EP2MLanguage >> classByRoleOrName: aString [ 
	^ self classNamed: aString
]

{ #category : #'accessing backend' }
EP2MLanguage >> classNamed: aString [ 
	^ self classNamed: aString asSymbol ifAbsent: [ KeyNotFound new key: aString; signal ]
]

{ #category : #'accessing backend' }
EP2MLanguage >> classNamed: aString ifAbsent: aBlockClosure [
	^ [self behaviors at: aString] on: KeyNotFound do: [ aBlockClosure value ]
]

{ #category : #'default model values' }
EP2MLanguage >> defaultBehaviors [
	
	^ IdentityDictionary new
]

{ #category : #'default model values' }
EP2MLanguage >> defaultGlobalVariables [
	
	^ IdentitySet new
]

{ #category : #class }
EP2MLanguage >> defaultMetaclass [ 
	"Hook: return the class that is instance of itself"
	^ self classNamed: #Class
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

{ #category : #initialization }
EP2MLanguage >> loadRequiredBehaviors [
	| objModel classModel |
	objModel := self addBehaviorFromTemplate: EP2Remote.
	classModel := self addBehaviorFromTemplate: EP2RemoteClass.
	objModel
		superclass: nil;
		metaclass: self defaultMetaclass.
	classModel
		superclass: (self classNamed: EP2RemoteClass superclass role);
		metaclass: self defaultMetaclass.
	
	" recursive call to load subclasses"
	EP2Remote
		subclassesDo: [ :subclass | self loadRequiredBehaviorsRecursive: subclass ]
]

{ #category : #initialization }
EP2MLanguage >> loadRequiredBehaviorsRecursive: aClassEP2Remote [
	| template model |
	template := aClassEP2Remote.
	model := self addBehaviorFromTemplate: template.
	model
		metaclass: self defaultMetaclass;
		superclass: (self classNamed: aClassEP2Remote superclass role).
	" Recursive call to load subclasses "
	template
		subclassesDo: [ :subclass | self loadRequiredBehaviorsRecursive: subclass ]
]

{ #category : #retrocompatibility }
EP2MLanguage >> loadTonelRepository: aTonelRepository packagesNames: aCollection classesNames: anUndefinedObject [
	"retrocompatibility" 
	^ self
]

{ #category : #'accessing backend' }
EP2MLanguage >> packageFor: anEP2MBehavior [
	^ (self packages
		select:
			[ :package | package definedBehaviors anySatisfy: [:beh | beh = anEP2MBehavior ] ]) anyOne
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

{ #category : #'private-accessing' }
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
