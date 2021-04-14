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
	#name : #ClassModel,
	#superclass : #ObjectModel,
	#instVars : [
		'role',
		'remote',
		'indexInClassTable',
		'tagsForMethods',
		'layout',
		'template',
		'superclass',
		'methodDict',
		'format'
	],
	#category : #'Espell2-Metamodel'
}

{ #category : #'hooks-api' }
ClassModel class >> methodMetaclass [
	^ MethodModel
]

{ #category : #calypso }
ClassModel >> >> aString [ 
	^ self methodDict at: aString
]

{ #category : #'accessing methods' }
ClassModel >> addLocalMethod: anEP2MMethod [
	self deprecated: 'use addLocalMethodFromsource:selector:'.
	
]

{ #category : #'accessing methods' }
ClassModel >> addLocalMethodFromSource: source selector: selector [
	
	^ (self ensureLocalMethodNamed: selector)
		sourceCode: source;
		selector: selector;
		yourself
]

{ #category : #calypso }
ClassModel >> addMethodTag: aSymbol [ 
	self backend addMethodTag: aSymbol to: self
]

{ #category : #'accessing slots' }
ClassModel >> addSlot: aString [ 
	^ self layout addSlot: aString
		
]

{ #category : #slots }
ClassModel >> addSlot: aString index: anInteger [  
	self layout addSlot: aString index: anInteger
]

{ #category : #'accessing inst vars' }
ClassModel >> allInstVarNames [
	^ (self allSlots select: #isInstanceVariableSlot) collect: #name
]

{ #category : #'accessing slots' }
ClassModel >> allSlots [
	^ self layout ifNil: [ #() ] ifNotNil: [:layo | layo allSlots ]
	"^ self superclass
		ifNil: [ self slots ]
		ifNotNil: [ self superclass allSlots , self slots ]"
]

{ #category : #querying }
ClassModel >> allSubclasses [
	| subclasses |
	"getting all classes that include self as a superclass in their inheritance hierarchy"
	subclasses := self subclasses.
	subclasses addAll: (subclasses flatCollect: [ :class | class allSubclasses ]).
	^ subclasses
]

{ #category : #exporting }
ClassModel >> asMCDefinition [

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
ClassModel >> backend [
	^ self parent backend 
]

{ #category : #accessing }
ClassModel >> basicClass [
	^ self metaclass
]

{ #category : #calypso }
ClassModel >> calypsoEnvironmentType [
	^ClyClass
]

{ #category : #calypso }
ClassModel >> category [
	^ self package name
]

{ #category : #'accessing backend' }
ClassModel >> classLoader [
	^ self parent classLoader
]

{ #category : #calypso }
ClassModel >> classSide [
	^ self metaclass
]

{ #category : #'accessing compiler' }
ClassModel >> classVarNames [
	"compiler compatibility"
	^ #()
]

{ #category : #calypso }
ClassModel >> comment [
	^ ''
]

{ #category : #calypso }
ClassModel >> compile: aString classified: aCategory notifying: aRubScrolledTextMorph [ 

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
ClassModel >> compiler [

	^ self class compiler
]

{ #category : #'default model values' }
ClassModel >> defaultMethodDictionary [
	^ IdentityDictionary new 
]

{ #category : #calypso }
ClassModel >> definition [

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
ClassModel >> ensureLocalMethodNamed: aSymbol [
	
	^ self localMethodNamed: aSymbol ifAbsent: [ 
		| newMethod |
		newMethod := self methodMetaclass named: aSymbol asSymbol parent: self.
		newMethod parent: self.
		self methodDict at: aSymbol put: newMethod.
		newMethod].
]

{ #category : #initialization }
ClassModel >> extendWithMonticello: aMCClassDefinition [
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
				ifTrue: [ self role ifNil: [ self role: mcDef role ] ifNotNil: [ self halt ] ] ].
	"package"
	packageDef := mcDef category.
	(self package isNotNil and: [ self package name ~= packageDef ])
		ifTrue: [ self package definedBehaviors remove: self ].
	self package isNil
		ifTrue: [ | newPkg |
			newPkg := self parent ensurePackageNamed: packageDef.
			self package: newPkg ].
	"index in class table"
	self indexInClassTable: mcDef indexInClassTable.
	" we can't test yet since not all classes have been loaded "
	self extendWithMonticelloCustom: mcDef.
	^ self
]

{ #category : #hooks }
ClassModel >> extendWithMonticelloCustom: aMCClassDefinition [
	self subclassResponsibility 
]

{ #category : #accessing }
ClassModel >> format [
	
	"A class format is composed by"
	"<5 bits inst spec><16 bits inst size>"

	self isImmediate ifTrue:
		[^ self parent formatOfImmediate ].
	
	^ self instSpec << 16 + self instSize
]

{ #category : #calypso }
ClassModel >> hasComment [
	^ false
]

{ #category : #hooks }
ClassModel >> hookInstall [
	| remoteMethodDict remoteSuperclass |
	self remoteIsInstalled ifFalse: [ self installStub ].
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
	self indexInClassTable: self remote indexInClassTable.
	^ self remote
]

{ #category : #'accessing methods' }
ClassModel >> includesSelector: aString [ 
	^ self methodDict anySatisfy: [ :method | method selector = aString ]
]

{ #category : #accessing }
ClassModel >> indexInClassTable [
	^ indexInClassTable
]

{ #category : #accessing }
ClassModel >> indexInClassTable: anInteger [ 
	indexInClassTable := anInteger
]

{ #category : #initialization }
ClassModel >> initialize [ 
	super initialize.
	methodDict := IdentityDictionary new.
	tagsForMethods := Set new
]

{ #category : #initialization }
ClassModel >> initializeWithLocal: localClass [
	
	self
		layout: (self parent layoutForInstSpec: localClass instSpec on: self);
		superclass: (self parent classByRoleOrName: localClass superclass name ifAbsent: [ self parent classNamed: #ProtoObject ]);
		name: localClass name;
		template: nil.
	localClass instVarNames do: [:ivname | self addSlot: ivname ].
	^ self
]

{ #category : #initialization }
ClassModel >> initializeWithMonticello: aMCClassDefinition [
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
ClassModel >> initializeWithTemplate: aTemplateClass [
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
ClassModel >> initializeWithTemplateCustom: aTemplateClass [.
	self subclassResponsibility 
]

{ #category : #hooks }
ClassModel >> innerBindingOf: aSymbol [ 
	self subclassResponsibility 
]

{ #category : #accessing }
ClassModel >> instSize [
	^ (self layout allSlots select: #isInstanceVariableSlot) size
]

{ #category : #accessing }
ClassModel >> instSpec [
	^ self layout instSpec
]

{ #category : #'accessing instance variables' }
ClassModel >> instVarIndexFor: aString ifAbsent: aBlockClosure [ 
	^ self allInstVarNames indexOf: aString ifAbsent: aBlockClosure 
]

{ #category : #accessing }
ClassModel >> instVarNames [
	^ self slots collect: #name
]

{ #category : #'api - stubs creation' }
ClassModel >> installMetacircularStub [
	"I install a class stub that is instance of itself"
	| theNewMetaclass metaclassIndex |
	" If the metaclass was already created, it will be found in the bootstrapEnvironment dictionary "
	self remoteIsInstalled
		ifTrue: [ ^ self remote ].

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
ClassModel >> installMethods [
	(self localMethods select: #isInstallable)
		do: [ :method | | remoteMethod | 
			remoteMethod := method install.
			self remote methodDictionary at: remoteMethod selector put: remoteMethod ]
]

{ #category : #'stubs creation' }
ClassModel >> installStub [
	" I install the stub of my corresponding class in the kernel.
	I depend on the implementation of installStubCustom "
	| newClass |
	self remoteIsInstalled
		ifTrue: [ ^ self ].
	newClass := self installStubCustom.
	self remote: newClass.
	self classLoader
		registerClass: newClass
		definition: self
		fullyLoaded: false.
	self assert: self remote isNotNil.
	newClass testStub.
	^ newClass
]

{ #category : #'stubs creation' }
ClassModel >> installStubCustom [
	"Using method from protocol 'api-stubs creation' create your own stub and return it"
	self subclassResponsibility
]

{ #category : #'accessing compiler' }
ClassModel >> instanceSide [
	"compiler compatibility"
	^ self
]

{ #category : #calypso }
ClassModel >> instanceVariablesString [
	"Answer a string of my instance variable names separated by spaces."

	^String streamContents: [ :stream |
		self instVarNames 
			do: [ :each | stream nextPutAll: each ]
			separatedBy: [ stream space ] ]
]

{ #category : #'testing layout' }
ClassModel >> isBehavior [ 
	^ true
]

{ #category : #testing }
ClassModel >> isBits [
	^ self layout isBitsLayout 
]

{ #category : #'testing layout' }
ClassModel >> isBytes [
	^ self layout isByteLayout
]

{ #category : #'testing layout' }
ClassModel >> isClassMetamodel [
	^ true
]

{ #category : #calypso }
ClassModel >> isClassSide [
	^ false
]

{ #category : #'testing layout' }
ClassModel >> isCompiledMethod [
	^ self layout isCompiledMethodLayout
]

{ #category : #'testing layout' }
ClassModel >> isEphemeron [
	^ self layout isEphemeronLayout
]

{ #category : #testing }
ClassModel >> isEphemeronClass [
	^ self layout isEphemeronLayout 
]

{ #category : #'testing layout' }
ClassModel >> isImmediate [
	^ self parent immediateClassRoles contains: [:rol | rol = self role ]
]

{ #category : #testing }
ClassModel >> isImmediateClass [
	^ self layout isImmediateLayout
]

{ #category : #calypso }
ClassModel >> isInstanceSide [
	^ true
]

{ #category : #'accessing compiler' }
ClassModel >> isMeta [
	"compiler compatibility"
	^ false
]

{ #category : #'testing layout' }
ClassModel >> isMetaclass [
	"languages don't have metaclasses by default"
	^ false
]

{ #category : #testing }
ClassModel >> isNilObject [
	^ false
]

{ #category : #calypso }
ClassModel >> isObsolete [
	^ false
]

{ #category : #calypso }
ClassModel >> isRootInEnvironment [
	^ self superclass == nil
]

{ #category : #'testing layout' }
ClassModel >> isVariable [
	^ self layout isVariableLayout
]

{ #category : #testing }
ClassModel >> isWeak [
	^ self layout isWeakLayout
]

{ #category : #'testing layout' }
ClassModel >> isWords [
	^ self layout isWordLayout
]

{ #category : #calypso }
ClassModel >> kindOfSubclass [
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
ClassModel >> layout [
	^ layout
]

{ #category : #accessing }
ClassModel >> layout: anEP2LayoutClass [ 
	layout := anEP2LayoutClass
]

{ #category : #calypso }
ClassModel >> localMethodNamed: aSymbol ifAbsent: aBlock [

	self localMethods do: [ :each | (each name = aSymbol) ifTrue: [^ each]].
	
	^ aBlock value.
]

{ #category : #accessing }
ClassModel >> localMethods [
	^ methodDict
]

{ #category : #calypso }
ClassModel >> localSelectors [
	^ self localMethods collect: #name
]

{ #category : #marking }
ClassModel >> lookupSelectorAndMarkTraversedClasses: selector [ 
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
ClassModel >> markMethodAsAccessed: aMethod [ 
	"We ask the class to mark the method instead of asking the method itself to do it, for handling the case in which aMethod is a compiled method coming from DASTBlock or BlockClosure" 
	(self methodNamed: aMethod selector)
		ifNil: [ Transcript show: 'selector ', aMethod selector, 'not found';cr. ]
		ifNotNil: [ :method | method markAsAccessed ] 
]

{ #category : #exporting }
ClassModel >> mcType [
	^ self layout mcType
]

{ #category : #'accessing backend' }
ClassModel >> metaclass [ 
	self subclassResponsibility 
]

{ #category : #'accessing backend' }
ClassModel >> methodBuilder [
	^ self parent methodBuilder
]

{ #category : #accessing }
ClassModel >> methodDict [
	^ methodDict
]

{ #category : #accessing }
ClassModel >> methodDict: aDictionary [
	^ self writeSlotNamed: #methodDict value: aDictionary 
]

{ #category : #'metamodel-accessing' }
ClassModel >> methodMetaclass [
	^ self class methodMetaclass
]

{ #category : #'accessing methods' }
ClassModel >> methodNamed: aString [
	^ self
		methodNamed: aString
		ifAbsent: [ PBMethodDefinitionNotFound
				signal: 'Method "' , aString , '" not found in class "' , self asString , '"' ]
]

{ #category : #'accessing methods' }
ClassModel >> methodNamed: aString ifAbsent: aBlock [
	
	^ [self methodDict at: aString asSymbol] on: KeyNotFound do: aBlock
]

{ #category : #accessing }
ClassModel >> methods [
	^ self methodDict values asArray
]

{ #category : #'api - stubs creation' }
ClassModel >> newStubWithFormat: anInteger [
	" Only valid for metaclasses. 
	I create a new class stub in the kernel by instantiating myself "
	| newClass |
	self assert: self remoteIsInstalled.
	newClass := self remote basicNew asRemoteMetaclass initialize.
	newClass format: anInteger.
	newClass setHashBitsTo: self classLoader newClassIndex.
	^ newClass
]

{ #category : #marking }
ClassModel >> objectAccessedPropertyName [
	^ parent objectAccessedPropertyName
]

{ #category : #accessing }
ClassModel >> package [
	^ self parent packageFor: self
]

{ #category : #accessing }
ClassModel >> package: anEP2MPackage [ 
	anEP2MPackage addDefinedBehavior: self
]

{ #category : #'hooks-dynamic method loading' }
ClassModel >> parserClass [ 
self haltOnce.
	^ RBParser
]

{ #category : #printing }
ClassModel >> printOn: aStream [
	aStream 
		nextPutAll: '"';
		nextPutAll: self name asString;
		nextPutAll: '"'
]

{ #category : #calypso }
ClassModel >> pvtAddMethodTag: aSymbol [ 
	self tagsForMethods add: aSymbol
]

{ #category : #'accessing slots' }
ClassModel >> readSlotNamed: aString [
	self deprecated: 'use Slot>>read: instead'.
	^ (self basicClass slotNamed: aString) read: self
]

{ #category : #accessing }
ClassModel >> remote [
	^ remote
		"ifNil: [ (self parent remote bootstrapEnvironmentAt: self name)
				ifNil: [ self remoteBackend nilObject ]
				ifNotNil: [ :found | found asRemoteClass ] ]"
]

{ #category : #accessing }
ClassModel >> remote: anEP2RemoteClass [ 
	remote := anEP2RemoteClass
]

{ #category : #testing }
ClassModel >> remoteIsInstalled [
	^ self remote isNotNil and: [ self remote isNotNilObject ]
]

{ #category : #'accessing remote backend' }
ClassModel >> remoteSystemDictionary [
	^ self parent remote espellBackend objectSpace systemDictionary
]

{ #category : #'accessing slots' }
ClassModel >> removeSlot: aString [ 
	^ self layout removeSlot: aString
		
]

{ #category : #accessing }
ClassModel >> role [
	^ role ifNil: [ role := template ifNil: [ nil ] ifNotNil: [ template role ] ] 
]

{ #category : #accessing }
ClassModel >> role: aString [ 
	role := aString
]

{ #category : #accessing }
ClassModel >> setLayoutKeepingSlots: anEP2Layout [
	| oldSlots |
	oldSlots := self layout ifNil: [#()] ifNotNil: [self slots].
	self layout: anEP2Layout.
	oldSlots do: [ :slot | self addSlot: slot name index: slot index ]
]

{ #category : #'accessing compiler' }
ClassModel >> sharedPools [
	"compiler compatibility"
	^#()
]

{ #category : #'accessing slots' }
ClassModel >> slotNamed: aString [
	^ (self slots select: [ :slot | slot name = aString ])
		ifEmpty: [ PBSlotDefinitionNotFound new
				key: aString;
				signal ]
		ifNotEmpty: [ :collection | collection anyOne ]
]

{ #category : #'accessing slots' }
ClassModel >> slotNamed: aString ifNone: aBlockClosure [ 
	^ [ self slotNamed: aString ] on: KeyNotFound do: aBlockClosure
]

{ #category : #'accessing slots' }
ClassModel >> slots [
	| allSlots |
	allSlots := OrderedCollection new.
	self slotsDo: [ :each | allSlots add: each].
	^ allSlots asArray
]

{ #category : #'accessing slots' }
ClassModel >> slotsDo: aBlockClosure [ 
	self layout slotsDo: aBlockClosure
]

{ #category : #calypso }
ClassModel >> sourceCodeTemplate [
	"Answer an expression to be edited and evaluated in order to define 
	methods in this class or trait."

	^ 'messageSelectorAndArgumentNames
	"comment stating purpose of message"

	| temporary variable names |
	statements'
]

{ #category : #calypso }
ClassModel >> subclasses [
	^ ((self parent allClasses
		reject: [ :class | class = self ])
		select: [ :class | class superclass = self ]) asOrderedCollection.
]

{ #category : #calypso }
ClassModel >> subclassesDo: aBlockClosure [ 
	self subclasses do: aBlockClosure
]

{ #category : #accessing }
ClassModel >> superclass [
	^ superclass
]

{ #category : #accessing }
ClassModel >> superclass: anEP2MBehavior [
	^ superclass := anEP2MBehavior 
]

{ #category : #calypso }
ClassModel >> tags [
	^ #()
]

{ #category : #calypso }
ClassModel >> tagsForAllMethods [
	"I act as #tagsForMethods but I also takes into account methods comming from traits"

	^ self methods flatCollect: [ :each  | each tags ] as: Set
]

{ #category : #calypso }
ClassModel >> tagsForMethods [
	^ tagsForMethods
]

{ #category : #accessing }
ClassModel >> template [
	^ template 
]

{ #category : #accessing }
ClassModel >> template: aClass [ 
	template := aClass
]

{ #category : #hooks }
ClassModel >> test [
	self template ifNotNil: [ self testVMInstanceVariables. self testFormat ].
	self assert: self layout isNotNil
]

{ #category : #hooks }
ClassModel >> testForWriting [
	self test.
	self assert: self indexInClassTable isNotNil.
]

{ #category : #testing }
ClassModel >> testFormat [
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
ClassModel >> testRemote [
	self remote test
]

{ #category : #testing }
ClassModel >> testRemoteStub [
	self remote asRemoteClass testStub
]

{ #category : #testing }
ClassModel >> testVMInstanceVariables [
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
ClassModel >> theNonMetaClass [
	"compiler compatibility"
	^ self
]

{ #category : #calypso }
ClassModel >> visibleMethods [
	^ self localMethods
]

{ #category : #'accessing slots' }
ClassModel >> writeSlotNamed: aString value: anObject [
	
	(self basicClass slotNamed: aString) write: anObject to: self
]