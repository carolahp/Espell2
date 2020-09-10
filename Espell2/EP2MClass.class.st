"
I define the basic metamodel of classes in a bootstrapped language.
In this description classes are referred by the name of their role.

According to my metamodel: 
	- The metaclass of every class is #'Metaclass'
	- The metaclass of #'Metaclass' is #'Metaclass' 
=====================================================================
Usage: 
- Subclass me to define the metamodel of classes in your own language.
- In your Language metamodel implement the hook EP2MLanguage>>classMetaclass and return the subclass you just created.
=====================================================================

"
Class {
	#name : #EP2MClass,
	#superclass : #EP2MObject,
	#instVars : [
		'layout',
		'template',
		'superclass',
		'methodDict',
		'format',
		'tagsForMethods'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #calypso }
EP2MClass >> >> aString [ 
	^ self methodDict at: aString
]

{ #category : #'accessing methods' }
EP2MClass >> addLocalMethod: anEP2MMethod [
	anEP2MMethod parent: self.
	self methodDict at: anEP2MMethod selector put: anEP2MMethod
]

{ #category : #calypso }
EP2MClass >> addMethodTag: aSymbol [ 
	self backend addMethodTag: aSymbol to: self
]

{ #category : #'accessing slots' }
EP2MClass >> addSlot: aString [ 
	^ self layout addSlot: aString
		
]

{ #category : #slots }
EP2MClass >> addSlot: aString index: anInteger [  
	self layout addSlot: aString index: anInteger
]

{ #category : #'accessing instance variables' }
EP2MClass >> allInstVarNames [
	^ self allSlots collect: #name
]

{ #category : #'accessing slots' }
EP2MClass >> allSlots [
	^ self layout ifNil: [ #() ] ifNotNil: [:layo | layo allSlots ]
	"^ self superclass
		ifNil: [ self slots ]
		ifNotNil: [ self superclass allSlots , self slots ]"
]

{ #category : #querying }
EP2MClass >> allSubclasses [
	^ (self parent allClasses
		reject: [ :class | class = self ]) 
		select: [ :class | class superclass = self ]
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

{ #category : #calypso }
EP2MClass >> calypsoEnvironmentType [
	^ClyClass
]

{ #category : #calypso }
EP2MClass >> category [
	^ self package name
]

{ #category : #'accessing backend' }
EP2MClass >> classLoader [
	^ self parent classLoader
]

{ #category : #calypso }
EP2MClass >> classSide [
	^ self metaclass
]

{ #category : #'accessing compiler' }
EP2MClass >> classVarNames [
	"compiler compatibility"
	^ #()
]

{ #category : #calypso }
EP2MClass >> comment [
	^ ''
]

{ #category : #calypso }
EP2MClass >> compile: aString classified: aCategory notifying: aRubScrolledTextMorph [ 

	| parseTree ast selector newMethod | 
	
	parseTree := (RBParser 
		parseMethod: aString
		onError: [ :msg :pos | ^ nil ]) methodClass: self.
		
	ast :=  parseTree doSemanticAnalysisIn: self.  
	
	selector := ast selector.
	newMethod := self ensureLocalMethodNamed: selector.
	newMethod sourceCode: aString.
	aCategory ifNotNil: [ 
		newMethod tagWith: aCategory ].
	
	^ selector.

]

{ #category : #'accessing compiler' }
EP2MClass >> compiler [

	^ self class compiler
]

{ #category : #'default model values' }
EP2MClass >> defaultMethodDictionary [
	^ IdentityDictionary new 
]

{ #category : #calypso }
EP2MClass >> definition [

	| aStream |
	
	aStream := (String new: 800) writeStream.
	self superclass
		ifNil: [ aStream nextPutAll: 'nil' ]
		ifNotNil: [ aStream nextPutAll: self superclass name ].
	aStream
		nextPutAll: self kindOfSubclass;
		store: self name.
	aStream
		cr;
		tab;
		nextPutAll: 'instanceVariableNames: ';
		store: self instanceVariablesString.
	"aStream
		cr;
		tab;
		nextPutAll: 'classVariableNames: ';
		store: self owner classVariablesString."
	aStream
		cr;
		tab;
		nextPutAll: 'package: ';
		store: self category asString.
	self superclass
		ifNil:
			[ aStream
				nextPutAll: '.';
				cr.
			aStream nextPutAll: self name.
			aStream
				space;
				nextPutAll: 'superclass: nil' ].
	^ aStream contents
]

{ #category : #calypso }
EP2MClass >> ensureLocalMethodNamed: aSymbol [
	
	^ self localMethodNamed: aSymbol ifAbsent: [ 
		| newMethod |
		newMethod := EP2MMethod named: aSymbol asSymbol parent: self.
		self addLocalMethod: newMethod.
		newMethod].
]

{ #category : #initialization }
EP2MClass >> extendWithMonticello: aMCClassDefinition [
	"An existent class is extended with a definition read from Monticello.
	This procedure may corrupt the class if the Tonel definition is incorrect, that's why we test the class at the end"

	| mcDef instVarsDefs packageDef |
	mcDef := aMCClassDefinition.

	"superclass"
	self
		superclass:
			(mcDef superclassName = #nil
				ifTrue: [ nil ]
				ifFalse: [ self parent ensureClassNamed: mcDef superclassName ]).
	"layout"
	self setLayoutKeepingSlots: (mcDef espell2LayoutType on: self).
	"instance variables"
	instVarsDefs := (mcDef variables
		select: [ :var | var class type = #instance ])
		reject: [ :var | (self allInstVarNames indexOf: var name) > 0 ].
	instVarsDefs do: [ :each | self addSlot: each name ].
	"role"
	mcDef role
		ifNotNil: [ self role ~= mcDef role
				ifTrue: [ self halt ] ].
	"package"
	packageDef := mcDef category.
	(self package isNotNil and: [self package name ~= packageDef]) 
		ifTrue: [ self package definedBehaviors remove: self ].
	
	self package isNil
		ifTrue: [ | newPkg |
			newPkg := self parent ensurePackageNamed: packageDef.
			self package: newPkg ].
	" we can't test yet since not all classes have been loaded "
	self extendWithMonticelloCustom: mcDef.
	^ self
]

{ #category : #hooks }
EP2MClass >> extendWithMonticelloCustom: aMCClassDefinition [
	self subclassResponsibility 
]

{ #category : #accessing }
EP2MClass >> format [
	
	"A class format is composed by"
	"<5 bits inst spec><16 bits inst size>"

	self isImmediate ifTrue:
		[^ self parent formatOfImmediate ].
	
	^ self instSpec << 16 + self instSize
]

{ #category : #calypso }
EP2MClass >> hasComment [
	^ false
]

{ #category : #hooks }
EP2MClass >> hookInstall [
	| remoteMethodDict remoteSuperclass |
	self remote isNilObject ifTrue: [ self installStub ].
	self remote isStub ifFalse: [
		"class is fully loaded"
		^ self remote ].
	"we install an empty methodDict, it will be filled later"
	remoteMethodDict := EP2RemoteMethodDictionary newWithBackend: self parent remote espellBackend.
	remoteMethodDict test.
	remoteSuperclass := self superclass ifNil: [nil] ifNotNil:[self parent remote classNamed: self superclass name].
	self remote 
		methodDictionary: remoteMethodDict;
		superclass: remoteSuperclass;
		format: self format.
	self remoteSystemDictionary at: self name put: self remote.
	self basicClass hookInstall.
	^ self remote
]

{ #category : #'accessing methods' }
EP2MClass >> includesSelector: aString [ 
	^ self methodDict anySatisfy: [ :method | method selector = aString ]
]

{ #category : #initialization }
EP2MClass >> initialize [ 
	super initialize.
	methodDict := IdentityDictionary new.
	tagsForMethods := Set new.
]

{ #category : #initialization }
EP2MClass >> initializeWithLocal: localClass [
	
	self
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
							self layout addSlot: unknownSlot" ] ] ].
	self test
]

{ #category : #initialization }
EP2MClass >> initializeWithTemplate: aTemplateClass [
	| superclassName superclassModel |
	
	superclassName := [aTemplateClass superclass role] on: Error do: [nil].
	superclassModel := self parent classNamed: superclassName ifAbsent: [nil].
	"this happens when a class has more than one role"
	self haltIf:[superclassName = self name].
	self superclass: superclassModel.
	self initializeWithTemplateCustom: aTemplateClass.
	self test.
	^ self
]

{ #category : #initialization }
EP2MClass >> initializeWithTemplateCustom: aTemplateClass [.
	self subclassResponsibility 
]

{ #category : #hooks }
EP2MClass >> innerBindingOf: aSymbol [ 
	self subclassResponsibility 
]

{ #category : #accessing }
EP2MClass >> instSize [
	^ (self layout allSlots select: #isInstanceVariableSlot) size
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
	^ self slots collect: #name
]

{ #category : #accessing }
EP2MClass >> instVarsDict [
	^ instVarsDict
]

{ #category : #'api - stubs creation' }
EP2MClass >> installMetacircularStub [
	"I install a class stub that is instance of itself"
	| theNewMetaclass metaclassIndex |
	" If the metaclass was already created, it will be found in the bootstrapEnvironment dictionary "
	self remote isNilObject
		ifFalse: [ ^ self remote ].

	" We need to create the metaclass from scratch "
	metaclassIndex := self classLoader newClassIndex.

	"This is Metaclass, it is instance of itself"
	theNewMetaclass := self classLoader
		createStubForClassNamed: self name
		metaclassIndex: metaclassIndex
		newClassIndex: metaclassIndex.
	self assert: theNewMetaclass basicClass = theNewMetaclass.
	self assert: theNewMetaclass classTableIndex = metaclassIndex.
	
	^ theNewMetaclass
]

{ #category : #hooks }
EP2MClass >> installMethods [
	| methods |
	methods := (self methodBuilder methodsFromDefinition: self)
		sorted: [ :a :b | a selector < b selector ].
	methods do:
			[ :method | 
			self remote methodDictionary test.
			self remote methodDictionary at: method selector put: method .
			self remote methodDictionary test]
]

{ #category : #'stubs creation' }
EP2MClass >> installStub [
	" I install the stub of my corresponding class in the kernel.
	I depend on the implementation of installStubCustom "
	| newClass |
	self remote isNilObject
		ifFalse: [ ^ self ].
	newClass := self installStubCustom.
	self classLoader
		registerClass: newClass
		definition: self
		fullyLoaded: false.
	newClass testStub.
	^ newClass
]

{ #category : #'stubs creation' }
EP2MClass >> installStubCustom [
	"Using method from protocol 'api-stubs creation' create your own stub and return it"
	self subclassResponsibility
]

{ #category : #'accessing compiler' }
EP2MClass >> instanceSide [
	"compiler compatibility"
	^ self
]

{ #category : #calypso }
EP2MClass >> instanceVariablesString [
	"Answer a string of my instance variable names separated by spaces."

	^String streamContents: [ :stream |
		self instVarNames 
			do: [ :each | stream nextPutAll: each ]
			separatedBy: [ stream space ] ]
]

{ #category : #'testing layout' }
EP2MClass >> isBehavior [ 
	^ true
]

{ #category : #testing }
EP2MClass >> isBits [
	^ self layout isBitsLayout 
]

{ #category : #'testing layout' }
EP2MClass >> isBytes [
	^ self layout isByteLayout
]

{ #category : #'testing layout' }
EP2MClass >> isClassMetamodel [
	^ true
]

{ #category : #calypso }
EP2MClass >> isClassSide [
	^ false
]

{ #category : #'testing layout' }
EP2MClass >> isCompiledMethod [
	^ self layout isCompiledMethodLayout
]

{ #category : #'testing layout' }
EP2MClass >> isEphemeron [
	^ self layout isEphemeronLayout
]

{ #category : #testing }
EP2MClass >> isEphemeronClass [
	^ self layout isEphemeronLayout 
]

{ #category : #'testing layout' }
EP2MClass >> isImmediate [
	^ self parent immediateClassRoles contains: [:rol | rol = self role ]
]

{ #category : #testing }
EP2MClass >> isImmediateClass [
	^ self layout isImmediateLayout
]

{ #category : #calypso }
EP2MClass >> isInstanceSide [
	^ true
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

{ #category : #calypso }
EP2MClass >> isObsolete [
	^ false
]

{ #category : #calypso }
EP2MClass >> isRootInEnvironment [
	^ self superclass == nil
]

{ #category : #'testing layout' }
EP2MClass >> isVariable [
	^ self layout isVariableLayout
]

{ #category : #testing }
EP2MClass >> isWeak [
	^ self layout isWeakLayout
]

{ #category : #'testing layout' }
EP2MClass >> isWords [
	^ self layout isWordLayout
]

{ #category : #calypso }
EP2MClass >> kindOfSubclass [
	"Answer a String that is the keyword that describes the receiver's kind of subclass,
	 either a regular subclass, a variableSubclass, a variableByteSubclass,
	 a variableWordSubclass, a weakSubclass, an ephemeronSubclass or an immediateSubclass.
	 c.f. typeOfClass"
	^self isVariable
		ifTrue:
			[self isBits
				ifTrue:
					[self isBytes
						ifTrue: [' variableByteSubclass: ']
						ifFalse: [' variableWordSubclass: ']]
				ifFalse:
					[self isWeak
						ifTrue: [' weakSubclass: ']
						ifFalse: [' variableSubclass: ']]]
		ifFalse:
			[self isImmediateClass
				ifTrue: [' immediateSubclass: ']
				ifFalse:
					[self isEphemeronClass
						ifTrue: [' ephemeronSubclass: ']
						ifFalse: [' subclass: ']]]
]

{ #category : #accessing }
EP2MClass >> layout [
	^ layout
]

{ #category : #accessing }
EP2MClass >> layout: anEP2LayoutClass [ 
	layout := anEP2LayoutClass
]

{ #category : #calypso }
EP2MClass >> localMethodNamed: aSymbol ifAbsent: aBlock [

	self localMethods do: [ :each | (each name = aSymbol) ifTrue: [^ each]].
	
	^ aBlock value.
]

{ #category : #accessing }
EP2MClass >> localMethods [
	^ methodDict
]

{ #category : #calypso }
EP2MClass >> localSelectors [
	^ self localMethods collect: #name
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

{ #category : #'accessing backend' }
EP2MClass >> methodBuilder [
	^ self parent methodBuilder
]

{ #category : #accessing }
EP2MClass >> methodDict [
	^ methodDict
]

{ #category : #accessing }
EP2MClass >> methodDict: aDictionary [
	^ self writeSlotNamed: #methodDict value: aDictionary 
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

{ #category : #'api - stubs creation' }
EP2MClass >> newStubWithFormat: anInteger [
	" Only valid for metaclasses. 
	I create a new class stub in the kernel by instantiating myself "
	| newClass |
	self assert: (self remote isNotNil and: [self remote isNotNilObject]).
	newClass := self remote basicNew asRemoteMetaclass initialize.
	newClass format: anInteger.
	newClass setHashBitsTo: self classLoader newClassIndex.
	^ newClass
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

{ #category : #calypso }
EP2MClass >> pvtAddMethodTag: aSymbol [ 
	self tagsForMethods add: aSymbol
]

{ #category : #'accessing slots' }
EP2MClass >> readSlotNamed: aString [
	
	^ (self basicClass slotNamed: aString) read: self
]

{ #category : #accessing }
EP2MClass >> remote [
	^ (self parent remote bootstrapEnvironmentAt: self name)
		ifNil: [self remoteBackend nilObject]
		ifNotNil: [:found | found asRemoteClass]
]

{ #category : #'accessing remote backend' }
EP2MClass >> remoteSystemDictionary [
	^ self parent remote espellBackend objectSpace systemDictionary
]

{ #category : #'accessing slots' }
EP2MClass >> removeSlot: aString [ 
	^ self layout removeSlot: aString
		
]

{ #category : #accessing }
EP2MClass >> role [
	^ template ifNil: [ nil ] ifNotNil: [ template role ]
]

{ #category : #accessing }
EP2MClass >> setLayoutKeepingSlots: anEP2Layout [
	| oldSlots |
	oldSlots := self layout ifNil: [#()] ifNotNil: [self slots].
	self layout: anEP2Layout.
	oldSlots do: [ :slot | self addSlot: slot name index: slot index ]
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
EP2MClass >> slotNamed: aString ifNone: aBlockClosure [ 
	^ [ self slotNamed: aString ] on: KeyNotFound do: aBlockClosure
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

{ #category : #calypso }
EP2MClass >> sourceCodeTemplate [
	"Answer an expression to be edited and evaluated in order to define 
	methods in this class or trait."

	^ 'messageSelectorAndArgumentNames
	"comment stating purpose of message"

	| temporary variable names |
	statements'
]

{ #category : #accessing }
EP2MClass >> superclass [
	^ superclass
]

{ #category : #accessing }
EP2MClass >> superclass: anEP2MBehavior [
	^ superclass := anEP2MBehavior 
]

{ #category : #calypso }
EP2MClass >> tagsForAllMethods [
	"I act as #tagsForMethods but I also takes into account methods comming from traits"

	^ self methods flatCollect: [ :each  | each tags ] as: Set
]

{ #category : #calypso }
EP2MClass >> tagsForMethods [
	^ tagsForMethods
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
	self template ifNotNil: [ self testVMInstanceVariables. self testFormat ].
	self assert: self layout isNotNil
]

{ #category : #testing }
EP2MClass >> testFormat [
	self template
		ifNotNil: [ :temp | 
			| myInstSpec correctInstSpec |
			myInstSpec := self instSpec.
			correctInstSpec := temp modelInstSpec.
			self
				assert: (myInstSpec = correctInstSpec or: (correctInstSpec = 1 and: myInstSpec = 0))
				description:
					'Wrong inst spec in class "' , self name , '" (role "' , self role
						, '"). It should be ' , temp modelInstSpec asString
						, ' but it is ' , self instSpec asString.
			self
				assert: temp modelAllInstVarNames size <= self instSize
				description:
					'Missing instance variables in class "' , self name , '" (role "'
						, self role , '"). It should define at least: '
						, temp modelAllInstVarNames asString ]
]

{ #category : #testing }
EP2MClass >> testRemote [
	self remote test
]

{ #category : #testing }
EP2MClass >> testRemoteStub [
	self remote testStub
]

{ #category : #testing }
EP2MClass >> testVMInstanceVariables [
	self template modelAllInstVarNames
		doWithIndex: [ :ivName :index | 
			self
				assert: (self instVarIndexFor: ivName ifAbsent: [ 0 ]) = index
				description:
					'Instance variable "' , ivName , '" should be in position '
						, index asString , ' in class ' , self name , ' (role "'
						, self role , '") ' ].
	self template modelAcceptsExtraInstVars
		ifFalse: [ | instVarsNames expectedInstVarsNames |
			instVarsNames := self allInstVarNames.
			expectedInstVarsNames := self template modelAllInstVarNames.
			self
				assert: instVarsNames size = expectedInstVarsNames size
				description:
					self name , ' defines ' , instVarsNames size asString
						, ' instance variables, but it must have exactly '
						, expectedInstVarsNames size asString , ' inst vars, which are: '
						, expectedInstVarsNames asString ]
]

{ #category : #'accessing compiler' }
EP2MClass >> theNonMetaClass [
	"compiler compatibility"
	^ self
]

{ #category : #'accessing slots' }
EP2MClass >> writeSlotNamed: aString value: anObject [
	
	(self basicClass slotNamed: aString) write: anObject to: self
]
