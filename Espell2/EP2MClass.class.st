"
I am an abstract class that defines the metamodel of classes in a bootstrapped language.
Subclass me to define the metamodel of classes in your own language.
Return the reference to your subclass from the hook EP2MLanguage>>classMetaclass.
"
Class {
	#name : #EP2MClass,
	#superclass : #EP2MObject,
	#instVars : [
		'layout',
		'template',
		'superclass',
		'methodDict',
		'metaclass'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'accessing methods' }
EP2MClass >> addLocalMethod: anEP2MMethod [
	anEP2MMethod parent: self.
	self methodDict at: anEP2MMethod selector put: anEP2MMethod
]

{ #category : #'accessing slots' }
EP2MClass >> addSlot: aString [ 
	^ self layout addSlot: aString
		
]

{ #category : #'accessing instance variables' }
EP2MClass >> allInstVarNames [
	^ self allSlots collect: #name
]

{ #category : #'accessing slots' }
EP2MClass >> allSlots [
	^ self superclass
		ifNil: [ self slots ]
		ifNotNil: [ self superclass allSlots , self slots ]
]

{ #category : #exporting }
EP2MClass >> asMCDefinition [

	^ MCClassDefinition 
		name: self name
		superclassName: (self superclass ifNil: [ 'nil' ] ifNotNil: [ :aSuperclass | aSuperclass name ])
		traitComposition: ''
		classTraitComposition: ''
		category: 'as yet unclassified'
		instVarNames: self instVarNames
		classVarNames: ''
		poolDictionaryNames: ''
		classInstVarNames: ''
		type: self mcType
		comment: ''
		commentStamp: ''
]

{ #category : #'accessing backend' }
EP2MClass >> backend [
	^ self parent backend 
]

{ #category : #accessing }
EP2MClass >> basicClass [
	^ self metaclass
]

{ #category : #'accessing backend' }
EP2MClass >> classLoader [
	^ self parent classLoader
]

{ #category : #accessing }
EP2MClass >> classSide [
	self subclassResponsibility 
]

{ #category : #'accessing compiler' }
EP2MClass >> classVarNames [
	"compiler compatibility"
	^ #()
]

{ #category : #'accessing compiler' }
EP2MClass >> compiler [

	^ self class compiler
]

{ #category : #'default model values' }
EP2MClass >> defaultMethodDictionary [
	^ IdentityDictionary new 
]

{ #category : #initialization }
EP2MClass >> extendWithMonticello: aMCClassDefinition [
	"An existent class stub is extended with a definition read from Monticello.
	Restrictions should apply here for classes with VM restrictions, therefore, 
	tests should be applied after the modification in each case"

	| mcDef instVarsDefs |
	mcDef := aMCClassDefinition.
	instVarsDefs := (mcDef variables
		select: [ :var | var class type = #instance ])
		reject: [ :var | (self allInstVarNames indexOf: var name) > 0 ].
	instVarsDefs do: [ :each | self addSlot: each name ].
	self superclass name = mcDef superclassName
		ifFalse: [ self halt ].
	^ self
]

{ #category : #accessing }
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

{ #category : #'accessing methods' }
EP2MClass >> includesSelector: aString [ 
	^ self methodDict anySatisfy: [ :method | method selector = aString ]
]

{ #category : #initialization }
EP2MClass >> initialize [ 
	super initialize.
	methodDict := self defaultMethodDictionary
]

{ #category : #initialization }
EP2MClass >> initializeWithLocal: localClass [
	
	self
		metaclass: self parent classMetaclass;
		layout: (self parent layoutForInstSpec: localClass instSpec on: self);
		superclass: (self parent classByRoleOrName: localClass superclass name ifAbsent: [ self parent classNamed: #ProtoObject ]);
		name: localClass name;
		template: nil.
	localClass instVarNames do: [:ivname | self addSlot: ivname ].
	^ self
]

{ #category : #initialization }
EP2MClass >> initializeWithMonticello: aMCClassDefinition [
	"A class is instantiated following the monticello definition"
	| mcDef |
	mcDef := aMCClassDefinition.
	self
		layout: (mcDef espell2LayoutType on: self);
		metaclass: self parent classMetaclass;
		template: nil.
	mcDef superclassName = #nil
		ifTrue: [ self halt ]
		ifFalse: [ self superclass: (self parent ensureClassNamed: mcDef superclassName) ].
	mcDef variables
		do: [ :each | 
			"the simplest metamodel considers only instance variables"
			each class type = #instance
				ifTrue: [ "(each class type = #class) ifTrue: [ 
				self addClassVariable: (RGClassVariable named: each name parent: self)].
			(each class type = #classInstance) ifTrue: [ 
				metaclassDef layout addSlot: (RGInstanceVariableSlot named: each name parent: metaclassDef layout)].
			(each class type = #pool) ifTrue: [ 
				self addSharedPool: (RGPoolVariable named: each name parent: self)]."
					(each name includes: $>)
						ifFalse: [ self addSlot: each name ]
						ifTrue: [ | unknownSlot |
							self halt
							"unknownSlot := RGUnknownSlot
								named: ((each name copyUpTo: $=) copyWithout: $#) trimBoth
								parent: self layout.
							unknownSlot expression: (each name copyAfter: $>) trimBoth.
							self layout addSlot: unknownSlot" ] ] ]
]

{ #category : #initialization }
EP2MClass >> initializeWithTemplate: aTemplateClass [
	| superclassName superclassModel |
	
	superclassName := [aTemplateClass superclass role] on: Error do: [nil].
	superclassModel := self parent classNamed: superclassName ifAbsent: [nil].
	"this happens when a class has more than one role"
	self haltIf:[superclassName = self name].
	self
		superclass: superclassModel.
	"check if we are installing the class with role Class (it is the only class which is instance of itself)"
	(aTemplateClass role = 'Metaclass') 
		ifTrue: [ self metaclass: self ]
		ifFalse: [ self metaclass: parent classMetaclass ].
	^ self
]

{ #category : #bindings }
EP2MClass >> innerBindingOf: aSymbol [ 
	self subclassResponsibility 
]

{ #category : #accessing }
EP2MClass >> instSize [
	^ (self layout slots select: #isInstanceVariableSlot) size
]

{ #category : #accessing }
EP2MClass >> instSpec [
	^ self layout instSpec
]

{ #category : #'accessing instance variables' }
EP2MClass >> instVarIndexFor: aString ifAbsent: aBlockClosure [ 
	^ self allInstVarNames indexOf: aString ifAbsent: aBlockClosure 
]

{ #category : #accessing }
EP2MClass >> instVarNames [
	^ self layout instVarNames
]

{ #category : #'installing stubs' }
EP2MClass >> installMetaclassStub [
	| theNewMetaclass metaclassIndex |
	" If the metaclass was already created, it will be found in the bootstrapEnvironment dictionary "
	self remote
		isNilObject ifFalse: [ :aClass | ^ aClass ].

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

{ #category : #'installing stubs' }
EP2MClass >> installStub [
	| newClass remoteMetaclassClass |
	"this is the class with role metaclass installed in the kernel"
	
	self remote isNilObject ifFalse: [ ^ self ].
	remoteMetaclassClass := self parent classMetaclass remote.
	remoteMetaclassClass isNilObject
		ifTrue: [ 
			"install the metaclass"
			remoteMetaclassClass := self parent classMetaclass
				installMetaclassStub ].
	newClass := remoteMetaclassClass basicNew asRemoteMetaclass.
	newClass format: self format.
	self classLoader
		registerClass: newClass
		definition: self
		fullyLoaded: false.
	^ newClass
]

{ #category : #'accessing compiler' }
EP2MClass >> instanceSide [
	"compiler compatibility"
	^ self
]

{ #category : #'testing layout' }
EP2MClass >> isBehavior [ 
	^ true
]

{ #category : #'testing layout' }
EP2MClass >> isBytes [
	^ self layout isByteLayout
]

{ #category : #'testing layout' }
EP2MClass >> isClassMetamodel [
	^ true
]

{ #category : #'testing layout' }
EP2MClass >> isCompiledMethod [
	^ self layout isCompiledMethodLayout
]

{ #category : #'testing layout' }
EP2MClass >> isEphemeron [
	^ self layout isEphemeronLayout
]

{ #category : #'testing layout' }
EP2MClass >> isImmediate [
	^ self parent immediateClassRoles contains: [:rol | rol = self role ]
]

{ #category : #'accessing compiler' }
EP2MClass >> isMeta [
	"compiler compatibility"
	^ false
]

{ #category : #'testing layout' }
EP2MClass >> isMetaclass [
	"languages don't have metaclasses by default"
	^ false
]

{ #category : #testing }
EP2MClass >> isNilObject [
	^ false
]

{ #category : #'testing layout' }
EP2MClass >> isVariable [
	^ self layout isVariableLayout
]

{ #category : #'testing layout' }
EP2MClass >> isWords [
	^ self layout isWordLayout
]

{ #category : #accessing }
EP2MClass >> layout [
	^ layout
]

{ #category : #accessing }
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

{ #category : #'as yet unclassified' }
EP2MClass >> markMethodAsAccessed: aMethod [ 
	"We ask the class to mark the method instead of asking the method itself to do it, for handling the case in which aMethod is a compiled method coming from DASTBlock or BlockClosure" 
	(self methodNamed: aMethod selector)
		ifNil: [ Transcript show: 'selector ', aMethod selector, 'not found';cr. ]
		ifNotNil: [ :method | method markAsAccessed ] 
]

{ #category : #exporting }
EP2MClass >> mcType [
	^ self layout mcType
]

{ #category : #accessing }
EP2MClass >> metaclass [
	^ metaclass
]

{ #category : #accessing }
EP2MClass >> metaclass: anOLClass [ 
	metaclass := anOLClass
]

{ #category : #'accessing backend' }
EP2MClass >> methodBuilder [
	^ self parent methodBuilder
]

{ #category : #accessing }
EP2MClass >> methodDict [
	^ methodDict
]

{ #category : #'accessing methods' }
EP2MClass >> methodNamed: aString [
	^ self
		methodNamed: aString
		ifAbsent: [ PBMethodDefinitionNotFound
				signal: 'Method "' , aString , '" not found in class "' , self asString , '"' ]
]

{ #category : #'accessing methods' }
EP2MClass >> methodNamed: aString ifAbsent: aBlock [
	
	^ [self methodDict at: aString asSymbol] on: KeyNotFound do: aBlock
]

{ #category : #accessing }
EP2MClass >> methods [
	^ self methodDict values asArray
]

{ #category : #marking }
EP2MClass >> objectAccessedPropertyName [
	^ parent objectAccessedPropertyName
]

{ #category : #accessing }
EP2MClass >> package [
	^ self parent packageFor: self
]

{ #category : #accessing }
EP2MClass >> package: anEP2MPackage [ 
	anEP2MPackage addDefinedBehavior: self
]

{ #category : #printing }
EP2MClass >> printOn: aStream [
	aStream 
		nextPutAll: '"';
		nextPutAll: self name asString;
		nextPutAll: '"'
]

{ #category : #'accessing slots' }
EP2MClass >> readSlotNamed: aString [

	^ (self basicClass slotNamed: #instVarNames) read: self
]

{ #category : #accessing }
EP2MClass >> remote [
	^ (self parent remote bootstrapEnvironmentAt: self name)
		ifNil: [self remoteBackend nilObject]
		ifNotNil: [:found | found asRemoteClass]
]

{ #category : #accessing }
EP2MClass >> role [
	^ template ifNil: [ nil ] ifNotNil: [ template role ]
]

{ #category : #'accessing compiler' }
EP2MClass >> sharedPools [
	"compiler compatibility"
	^#()
]

{ #category : #'accessing slots' }
EP2MClass >> slotNamed: aString [
	^ (self slots select: [ :slot | slot name = aString ])
		ifEmpty: [ PBSlotDefinitionNotFound new
				key: aString;
				signal ]
		ifNotEmpty: [ :collection | collection anyOne ]
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

{ #category : #accessing }
EP2MClass >> superclass: anEP2MBehavior [
	
	superclass := anEP2MBehavior 
]

{ #category : #accessing }
EP2MClass >> template [
	^ template 
]

{ #category : #accessing }
EP2MClass >> template: aClass [ 
	template := aClass
]

{ #category : #hooks }
EP2MClass >> test [
	self template ifNotNil: [ self testVMInstanceVariables. self testFormat ]
]

{ #category : #testing }
EP2MClass >> testFormat [
	self template
		ifNotNil: [ :temp | 
			| myInstSpec goodInstSpec |
			myInstSpec := self instSpec.
			goodInstSpec := temp modelInstSpec.
			self
				assert: (myInstSpec = goodInstSpec or: (goodInstSpec = 1 and: myInstSpec = 0))
				description:
					'Wrong inst spec in class "' , self name , '" (role "' , self role
						, '"). It should be ' , temp modelInstSpec asString
						, ' but it is ' , self instSpec asString.
			self
				assert: temp modelInstVarNames size <= self instSize
				description:
					'Missing instance variables in class "' , self name , '" (role "'
						, self role , '"). It should define at least: '
						, temp modelInstVarNames asString ]
]

{ #category : #testing }
EP2MClass >> testRemote [
	| remote |
	remote := self remote.
	self 
		assert: remote methodDictionary isNilObject not 
		description: 'method dictionary is nil'.
	self assert: remote classNameFromAnyOrigin = self name.
	self assert: remote methodDictionary basicClass instSpec = EP2RemoteMethodDictionary modelInstSpec description: 'Incorrect format of method dictionary. Wrong instSpec of its class'.
	remote methodDictionary size > 0 ifTrue: [ self halt ]
]

{ #category : #testing }
EP2MClass >> testVMInstanceVariables [
	self template modelInstVarNames
		doWithIndex: [ :ivName :index | 
			self
				assert: (self instVarIndexFor: ivName ifAbsent: [ 0 ]) = index
				description:
					'Instance variable "' , ivName , '" should be in position '
						, index asString , ' in class ' , self name , ' (role "'
						, self role , '") ' ]
]

{ #category : #'accessing compiler' }
EP2MClass >> theNonMetaClass [
	"compiler compatibility"
	^ self
]
