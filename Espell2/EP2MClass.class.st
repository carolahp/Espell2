"
I am an abstract class that defines the metamodel of classes in a bootstrapped language.
Subclass me to define the metamodel of classes in your own language.
Return the reference to your subclass from the hook EP2MLanguage>>classMetaclass.
"
Class {
	#name : #EP2MClass,
	#superclass : #EP2MObject,
	#instVars : [
		'superclass',
		'methodDict',
		'metaclass',
		'layout',
		'role'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #accessing }
EP2MClass class >> layout: aClass [ 
	layout := aClass
]

{ #category : #methods }
EP2MClass >> addLocalMethod: anEP2MMethod [
	anEP2MMethod parent: self.
	self methodDict at: anEP2MMethod selector put: anEP2MMethod
]

{ #category : #'accessing slots' }
EP2MClass >> addSlot: aString [ 
	^ self layout addSlot: aString
		
]

{ #category : #'accessing slots' }
EP2MClass >> allSlots [
	^ self slots
]

{ #category : #'accessing backend' }
EP2MClass >> backend [
	^ self parent backend 
]

{ #category : #'accessing model' }
EP2MClass >> basicClass [
	^ self metaclass
]

{ #category : #'accessing remote backend' }
EP2MClass >> classLoader [
	^ self parent classLoader
]

{ #category : #'accessing-backend' }
EP2MClass >> classSide [
	self subclassResponsibility 
]

{ #category : #compiler }
EP2MClass >> compiler [

	^ self class compiler
]

{ #category : #'default model values' }
EP2MClass >> defaultMethodDictionary [
	^ IdentityDictionary new 
]

{ #category : #'accessing layout' }
EP2MClass >> format [
	
	"A class format is composed by"
	"<5 bits inst spec><16 bits inst size>"

	self isImmediate ifTrue:
		[^ self parent formatOfImmediate ].
	
	^ self instSpec << 16 + self instSize
]

{ #category : #hooks }
EP2MClass >> hookInstall [
	self subclassResponsibility 
]

{ #category : #query }
EP2MClass >> includesSelector: aString [ 
	^ self methodDict anySatisfy: [ :method | method selector = aString ]
]

{ #category : #initialization }
EP2MClass >> initialize [ 
	super initialize.
	methodDict := self defaultMethodDictionary
]

{ #category : #initialization }
EP2MClass >> initializeWith: template [
	| superclassName superclassRemote |
	superclassName := [template superclass role] on: Error do: [nil].
	superclassRemote := self parent classNamed: superclassName ifAbsent: [nil].
	self
		role: template role;
		layout: (template layoutClass on: self);
		superclass: superclassRemote.
	"check if we are installing the class with role Class (it is the only class which is instance of itself)"
	(template = EP2RemoteClass) 
		ifTrue: [ self metaclass: self ]
		ifFalse: [ self metaclass: parent classMetaclass ].

	template allInstVarNames do: [:ivname | self addSlot: ivname ].
	^ self
]

{ #category : #bindings }
EP2MClass >> innerBindingOf: aSymbol [ 
	"in ObjVLisp there are no class variables"
	^nil
]

{ #category : #'accessing header' }
EP2MClass >> instSize [
	^ (self layout slots select: #isInstanceVariableSlot) size
]

{ #category : #'accessing header' }
EP2MClass >> instSpec [
	^ self layout instSpec
]

{ #category : #accessing }
EP2MClass >> instVarNames [
	^ self layout instVarNames
]

{ #category : #'classes remote' }
EP2MClass >> installMetaclassStub [
	| theNewMetaclass metaclassIndex |
	" If the metaclass was already created, it will be found in the bootstrapEnvironment dictionary "
	self remote
		ifNotNil: [ :aClass | ^ aClass ].

	" We need to create the metaclass from scratch "
	metaclassIndex := self classLoader newClassIndex.

	"This is Metaclass, it is instance of itself"
	theNewMetaclass := self classLoader
		createStubForClassNamed: self name
		metaclassIndex: metaclassIndex
		newClassIndex: metaclassIndex.
	self classLoader registerClass: theNewMetaclass definition: self fullyLoaded: false.

	self assert: theNewMetaclass basicClass = theNewMetaclass .
	^ theNewMetaclass
]

{ #category : #hooks }
EP2MClass >> installMethods [
	self subclassResponsibility 
]

{ #category : #'installing remote' }
EP2MClass >> installStub [
		
	| newClass remoteMetaclassClass |	
	"this is the class with role metaclass installed in the kernel"
	remoteMetaclassClass := self parent classMetaclass remote 
		ifNil: [
			self parent classMetaclass installMetaclassStub
		].
	newClass := remoteMetaclassClass basicNew asRemoteMetaclass.
	newClass format: self format.
	self classLoader registerClass: newClass definition: self fullyLoaded: false.
	
	^ newClass
]

{ #category : #testing }
EP2MClass >> isBehavior [ 
	^ true
]

{ #category : #'accessing header' }
EP2MClass >> isBytes [
	^ self layout isByteLayout
]

{ #category : #testing }
EP2MClass >> isClassMetamodel [
	^ true
]

{ #category : #'accessing header' }
EP2MClass >> isCompiledMethod [
	^ self layout isCompiledMethodLayout
]

{ #category : #'accessing header' }
EP2MClass >> isEphemeron [
	^ self layout isEphemeronLayout
]

{ #category : #testing }
EP2MClass >> isImmediate [
	^ self parent immediateClassRoles contains: [:rol | rol = self role ]
]

{ #category : #hooks }
EP2MClass >> isInstallable [
	^ true
]

{ #category : #testing }
EP2MClass >> isMetaclass [
	"languages don't have metaclasses by default"
	^ false
]

{ #category : #'accessing header' }
EP2MClass >> isVariable [
	^ self layout isVariableLayout
]

{ #category : #'accessing header' }
EP2MClass >> isWords [
	^ self layout isWordLayout
]

{ #category : #accessing }
EP2MClass >> layout [
	^ layout
]

{ #category : #'accessing-api' }
EP2MClass >> layout: anEP2LayoutClass [ 
	layout := anEP2LayoutClass
]

{ #category : #'as yet unclassified' }
EP2MClass >> localMethods [
	^ methodDict
]

{ #category : #marking }
EP2MClass >> lookupSelectorAndMarkTraversedClasses: selector [ 
	"Reimplementation of method RGBehavior >> lookupSelector:
	In here mark the traversed classes"
	| lookupClass |
	lookupClass := self.
	[lookupClass == nil]
		whileFalse: [ 
			"We mark the current behavior as maybe accessed"
			lookupClass markAsMaybeAccessed.
			lookupClass methodDict 
				at: selector
				ifPresent: [ :method | 
						"We mark as accessed all the behaviors that we traversed"
						self environment markMaybeAccessedBehaviorsAsAccessed. 
						"We load the class in the environment so it is available for inspection during the simulated execution of code"
						self environment pbBootstrapper builder classNamed: self name.
						^ method ].
			lookupClass := lookupClass superclass].
	"The method was not found, so we remove the maybeAccessed property from all behaviors"
	self environment removeMaybeAccessedPropertyFromAllBehaviors.
	^ nil
]

{ #category : #marking }
EP2MClass >> markAsAccessed [
	self propertyNamed: self parent objectAccessedPropertyName put: true
]

{ #category : #marking }
EP2MClass >> markAsMaybeAccessed [
	
	self 
		propertyNamed: self environment maybeAccessedPropertyName
		put: true
]

{ #category : #'as yet unclassified' }
EP2MClass >> markMethodAsAccessed: aMethod [ 
	"We ask the class to mark the method instead of asking the method itself to do it, for handling the case in which aMethod is a compiled method coming from DASTBlock or BlockClosure" 
	(self methodNamed: aMethod selector)
		ifNil: [ Transcript show: 'selector ', aMethod selector, 'not found';cr. ]
		ifNotNil: [ :method | method markAsAccessed ] 
]

{ #category : #'accessing-api' }
EP2MClass >> metaclass [
	^ metaclass
]

{ #category : #accessing }
EP2MClass >> metaclass: anOLClass [ 
	metaclass := anOLClass
]

{ #category : #'accessing remote backend' }
EP2MClass >> methodBuilder [
	^ self parent methodBuilder
]

{ #category : #'accessing model' }
EP2MClass >> methodDict [
	^ methodDict
]

{ #category : #methods }
EP2MClass >> methodNamed: aString [ 
	^ self methodDict at: aString asSymbol
]

{ #category : #making }
EP2MClass >> objectAccessedPropertyName [
	^ parent objectAccessedPropertyName
]

{ #category : #'accessing-api' }
EP2MClass >> package [
	^ self parent packageFor: self
]

{ #category : #printing }
EP2MClass >> printOn: aStream [
	aStream 
		nextPutAll: '"';
		nextPutAll: self name asString;
		nextPutAll: '"'
]

{ #category : #'accessing remote objects' }
EP2MClass >> remote [
	^ self parent remote bootstrapEnvironmentAt: self name
]

{ #category : #accessing }
EP2MClass >> role [
	^ role
]

{ #category : #accessing }
EP2MClass >> role: aString [
	role := aString
]

{ #category : #'accessing slots' }
EP2MClass >> slotNamed: aString [ 
	^ (self basicClass slots select: [:slot | slot name = aString]) anyOne
]

{ #category : #'accessing slots' }
EP2MClass >> slots [
	| allSlots |
	allSlots := OrderedCollection new.
	self slotsDo: [ :each | allSlots add: each].
	^ allSlots asArray
]

{ #category : #'accessing slots' }
EP2MClass >> slotsDo: aBlockClosure [ 
	self layout slotsDo: aBlockClosure
]

{ #category : #accessing }
EP2MClass >> superclass [
	^ superclass
]

{ #category : #'accessing-api' }
EP2MClass >> superclass: anEP2MBehavior [
	
	superclass := anEP2MBehavior 
]

{ #category : #hooks }
EP2MClass >> test [
	self subclassResponsibility
]
