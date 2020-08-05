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
		'behaviors'
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
EP2MLanguage >> behaviors [ 
	^ behaviors
]

{ #category : #accessing }
EP2MLanguage >> classNamed: aString [ 
	^ self behaviors at: aString
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
	self subclassResponsibility 
]

{ #category : #'default model values' }
EP2MLanguage >> defaultPackageNameKernelVM [
	^ #'Kernel-VM'
]

{ #category : #'default model values' }
EP2MLanguage >> defaultPackages [
	| package |
	package := EP2MPackage new
		name: self defaultPackageNameKernelVM;
		parent: self;
		yourself.
	^ IdentitySet new 
		add: package;
		yourself
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
	"self classes keysAndValuesRemove: [:key :val | true]"
	| template model className |
	template := EP2Remote.
	className := template role.
	" Create the new behavior "
	model := self class classMetaclass
		named: className 
		parent: self
		superclass: nil
		layout: template layoutClass.
	" Add the new behavior to the environment "
	self behaviors at: className put: model.
	self packages anyOne addDefinedBehavior: model."we assume we have only one package loaded"
	" recursive call to load subclasses"
	template
		subclassesDo: [ :subclass | self loadRequiredBehaviorsRecursive: subclass ]
]

{ #category : #initialization }
EP2MLanguage >> loadRequiredBehaviorsRecursive: anEP2RemoteClass [
	| template model className |
	
	template := anEP2RemoteClass.
	className := template role.
	" Create the new behavior "
	model := self class classMetaclass 
		named: className 
		parent: self
		superclass: (self behaviors at: template superclass role)
		layout: template layoutClass.
	" Add the new behavior to the environment "
	self behaviors at: className put: model.
	self packages anyOne addDefinedBehavior: model. "we assume we have only one package loaded"
	" Recursive call to load subclasses "
	template subclassesDo: [ :subclass |
		self loadRequiredBehaviorsRecursive: subclass ]
]

{ #category : #retrocompatibility }
EP2MLanguage >> loadTonelRepository: aTonelRepository packagesNames: aCollection classesNames: anUndefinedObject [
	"retrocompatibility" 
	^ self
]

{ #category : #accessing }
EP2MLanguage >> packageFor: anEP2MBehavior [
	^ (self packages
		select:
			[ :package | package definedBehaviors contains: [:beh | beh = anEP2MBehavior ] ]) anyOne
]

{ #category : #accessing }
EP2MLanguage >> packages [
	^ packages
]

{ #category : #'private-accessing' }
EP2MLanguage >> pbRepository: aPBRepository [ 
	pbRepository := aPBRepository 
]

{ #category : #printing }
EP2MLanguage >> printOn: aStream [
	aStream 
		nextPutAll: 'a LangDef "';
		nextPutAll: self name asString;
		nextPutAll: '"'
]
