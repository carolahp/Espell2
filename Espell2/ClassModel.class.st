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
		'indexInClassTable',
		'index2InClassTable',
		'indexInSpecialObjectsArray',
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
ClassModel class >> allClassModelInstVarNames [
	| allInstVars firstIndex |
	"returns all inst vars of class-models according to the metamodel, starting from superclass"
	allInstVars := self allInstVarNames.
	firstIndex := allInstVars indexOf: 'superclass'.
	^ allInstVars copyFrom: firstIndex to: allInstVars size
]

{ #category : #metamodel }
ClassModel class >> methodModel [
	^ MethodModel
]

{ #category : #calypso }
ClassModel >> >> aString [ 
	^ self methodDict at: aString
]

{ #category : #testing }
ClassModel >> acceptsNewSlots [
	^ self layout acceptsNewSlots 
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

{ #category : #'accessing slots' }
ClassModel >> addSlot: aString index: anInteger [  
	self layout addSlot: aString index: anInteger
]

{ #category : #adding }
ClassModel >> addSlotRecursivelyWherePossible: slotName [
	| insert required |
	self
		recursivellyDo: [ :class | 
			insert := class acceptsNewSlots.
			class allSubclasses
				do: [ :subclass | 
					insert := insert and: subclass acceptsNewSlots.
					required := subclass template
						ifNil: [ #() ]
						ifNotNil: [ subclass template modelAllInstVarNames ].
					insert := insert and: (required endsWith: class allSlots) ].
			insert
				ifTrue: [ class slotNamed: slotName ifAbsent: [ class addSlot: slotName ] ] ]
		to: [ :c | c subclasses ]
]

{ #category : #slots }
ClassModel >> addSlotRefactoringSubclasses: slotName [
	self allSubclasses
		do: [ :c | 
			(c slots anySatisfy: [ :s | s name = slotName ])
				ifTrue: [ c removeSlot: slotName ] ].
	self addSlot: slotName.
	self allSubclasses do: #test
]

{ #category : #'accessing instance variables' }
ClassModel >> allInstVarNames [
	^ (self allSlots select: #isInstanceVariableSlot) collect: #name
]

{ #category : #querying }
ClassModel >> allMethods [
	| methods |
	methods := self localMethods asOrderedCollection.
	self allSuperclasses
		do: [ :class | 
			methods
				addAll:
					(class localMethods asOrderedCollection
						reject:
							[ :method | methods anySatisfy: [ :each | each selector = method selector ] ]) ].
	^ methods
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

{ #category : #'accessing superclasses' }
ClassModel >> allSuperclasses [
	"Answer an OrderedCollection of the receiver's and the receiver's  
	ancestor's superclasses. The first element is the receiver's immediate  
	superclass, followed by its superclass; the last element is Object."

	| temp |
	^ self superclass == nil
		ifTrue: [ OrderedCollection new ]
		ifFalse: [ self superclass = self
				ifTrue: [ self
						error: 'circular references are forbidden in inheritance hierarchy' ].
			temp := self superclass allSuperclasses.
			temp addFirst: self superclass.
			temp ]
]

{ #category : #monticello }
ClassModel >> asMCDefinition [
	^ (MCClassDefinitionEspell
		name: self name
		superclassName: (self superclass ifNil: [ 'nil' ] ifNotNil: [ :aSuperclass | aSuperclass name ])
		traitComposition: ''
		classTraitComposition: ''
		category: self package name
		instVarNames: self instVarNames
		classVarNames: ''
		poolDictionaryNames: ''
		classInstVarNames: ''
		type: self mcType
		comment: self comment
		commentStamp: '')
		metaclass: self metaclass name;
		yourself
]

{ #category : #'accessing backend' }
ClassModel >> backend [
	^ self parent backend 
]

{ #category : #accessing }
ClassModel >> basicClass [
	^ self metaclass
]

{ #category : #binding }
ClassModel >> binding [

	^ self environment bindingOf: self name
]

{ #category : #binding }
ClassModel >> bindingOf: aSymbol [

	self subclassResponsibility 
]

{ #category : #calypso }
ClassModel >> calypsoEnvironmentType [
	^ClyClass
]

{ #category : #calypso }
ClassModel >> category [
	^ self package name
]

{ #category : #testing }
ClassModel >> classIsMeta [
	"tonel compatibility"
	^ false
]

{ #category : #'accessing backend' }
ClassModel >> classLoader [
	^ self parent classLoader
]

{ #category : #calypso }
ClassModel >> classSide [
	^ self metaclass
]

{ #category : #accessing }
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

{ #category : #'accessing backend' }
ClassModel >> compiler [

	^ self class compiler
]

{ #category : #'accessing format' }
ClassModel >> defaultMethodDictionary [
	^ IdentityDictionary new 
]

{ #category : #'default values' }
ClassModel >> defaultSuperclass [
	^ self parent classWithRole: #ProtoObject
]

{ #category : #testing }
ClassModel >> definesSlot: slotName [ 
	^ self layout definesSlot: slotName
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

{ #category : #destroy }
ClassModel >> destroy [ 
	super destroy.
	index2InClassTable := nil.
	indexInClassTable := nil.
	indexInSpecialObjectsArray := nil.
	layout ifNotNil: [ 
		layout destroy.
		layout := nil.
	] .
	methodDict ifNotNil: [ 
		methodDict valuesDo: [ :method | method destroy ].
		methodDict := nil.
	].
	superclass := nil.
	tagsForMethods := nil.
	template := nil
	
]

{ #category : #calypso }
ClassModel >> ensureLocalMethodNamed: aSymbol [
	
	^ self localMethodNamed: aSymbol ifAbsent: [ 
		| newMethod |
		newMethod := self methodModel named: aSymbol asSymbol parent: self.
		newMethod parent: self.
		newMethod selector: aSymbol.
		self methodDict at: aSymbol put: newMethod.
		newMethod].
]

{ #category : #'accessing remote backend' }
ClassModel >> ensureRemote [
	^ (self remote
		ifNil:
			[ " I have not been installed yet."
			self installStub.
			self remote ]) asRemoteClass
]

{ #category : #accessing }
ClassModel >> environment [ 
	^ self parent 
]

{ #category : #transforming }
ClassModel >> extendWithMonticello: aMCClassDefinition [
	"An existent class is extended with a definition read from Monticello.
	This procedure may corrupt the class if the Tonel definition is incorrect, that's why we need to test all classes after they have been modified"

	| mcDef instVarsDefs packageDef newLayoutClass newLayout |
	mcDef := aMCClassDefinition.

	"superclass"
	self
		superclass:
			(mcDef superclassName = #nil
				ifTrue: [ nil ]
				ifFalse: [ self parent ensureClassNamed: mcDef superclassName ]).
	"layout"
	newLayoutClass := mcDef espell2LayoutType.
	newLayout := self role
		ifNotNil: [ self assert: self template layoutClass = self layout class.
			"fail if tonel sets a wrong type"
			self
				assert:
					((self layout class = newLayoutClass
						or: [ self layout class inheritsFrom: newLayoutClass ])
						or: [ self layout class == EP2EmptyLayout and: newLayoutClass == EP2FixedLayout ]).
			"keep my old layout since it is more specialized"
			self layout ]
		ifNil: [ newLayoutClass on: self ].
	self setLayoutKeepingSlots: newLayout.
	"instance variables"
	instVarsDefs := (mcDef variables
		select: [ :var | var class type = #instance ])
		reject: [ :var | (self allInstVarNames indexOf: var name) > 0 ].
	instVarsDefs do: [ :each | self addSlotRefactoringSubclasses: each name ].
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
	^ self
]

{ #category : #hooks }
ClassModel >> extendWithMonticelloCustom: aEP2MCClassDefinition [
	"Specify how Class attributes read from Tonel files are loaded into this class model. 
	Access attributes by sending a message whose selector is the attribute name.
	e.g. in Tonel: 
		Point { 
			#name: #Point,
			#myAttribute: #hello
		 } 
		access myAttribute sending:
			aMCClassDefinition myAttribute
	No need to implement custom getters and setters in EP2MCClassDefinition"
	self subclassResponsibility 
]

{ #category : #'accessing format' }
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

{ #category : #install }
ClassModel >> hookInstall [
	| remoteMethodDict remoteSuperclass |
	self halt.
	
	self remoteIsInstalled
		ifFalse: [ self installStub ].
	self remote isStub
		ifFalse: [ "class is fully loaded" ^ self remote ].
	"we install an empty methodDict, it will be filled later"
	remoteMethodDict := EP2RemoteMethodDictionary	newWithBackend: self parent remote espellBackend.
	remoteMethodDict test.
	remoteSuperclass := self superclass
		ifNil: [ nil ]
		ifNotNil: [ self superclass ensureRemote ].
	self remote
		methodDictionary: remoteMethodDict;
		superclass: remoteSuperclass;
		format: self format.
	self remoteSystemDictionary at: self name put: self remote.
	self basicClass hookInstall.
	self indexInClassTable: self remote indexInClassTable.
	^ self remote
]

{ #category : #calypso }
ClassModel >> includesMethodsAffectedBy: aMethodRemoved [ 

	^aMethodRemoved affectsMethodsDefinedInPackage: self
]

{ #category : #'accessing methods' }
ClassModel >> includesSelector: aString [ 
	^ self methodDict anySatisfy: [ :method | method selector = aString ]
]

{ #category : #'accessing format' }
ClassModel >> indexInClassTable [
	^ indexInClassTable
]

{ #category : #'accessing format' }
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
		superclass: (self parent classByRoleOrName: localClass superclass name ifAbsent: [ self defaultSuperclass ]);
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
	self initializeWithTemplateGeneric: aTemplateClass.
	self initializeWithTemplateCustom: aTemplateClass.
	self test.
	^ self
		
]

{ #category : #initialization }
ClassModel >> initializeWithTemplateCustom: aTemplateClass [.
	self subclassResponsibility 
]

{ #category : #initialization }
ClassModel >> initializeWithTemplateGeneric: aTemplateClass [
	| superclassModel superTemplates superTemplate templates |

	indexInClassTable := template indexInClassTable.
	index2InClassTable := template index2InClassTable.
	indexInSpecialObjectsArray := template indexInSpecialObjectsArray.
	
	"ProtoObject superclass is nil"
	(self role = #ProtoObject) 
		ifTrue: [self superclass: nil.
			^ self].
	"For other templates, we calculate the superclass"
	templates := EP2Remote allSubclasses
		add: EP2Remote;
		yourself.
	
	superTemplates := aTemplateClass allSuperclasses
		select: [ :each | 
			(templates includes: each)
				and: [ each role isNotNil ] ].
			
	superTemplate := superTemplates at: 1 ifAbsent: [ nil ].
	
	superclassModel := superTemplate
		ifNil: [ self parent classWithRole: #ProtoObject ]
		ifNotNil: [ self parent classWithRole: superTemplate role ].

	"this happens when a class has more than one role"
	(superclassModel isNotNil and: [ superclassModel name = self name ])
		ifTrue:
			[ self error: 'The language model contains a clas with multiple roles' ].
	self superclass: superclassModel.
	^ self
]

{ #category : #hooks }
ClassModel >> innerBindingOf: aSymbol [ 
	"Answer the binding of some variable resolved in the scope of the receiver, or one of its superclass
	but do not look up binding in receiver's environment.
	Use #bindingOf: for looking up the variable binding in a full scope, including receiver's environment"
	
	self subclassResponsibility 
]

{ #category : #'accessing format' }
ClassModel >> instSize [
	^ (self layout allSlots select: #isInstanceVariableSlot) size
]

{ #category : #'accessing format' }
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

{ #category : #install }
ClassModel >> install [
	self installBasic.
	self installCustom.
	self assert: self indexInClassTable = self remote indexInClassTable

]

{ #category : #install }
ClassModel >> installBasic [
	| remoteMethodDict remoteSuperclass |
	self remoteIsInstalled
		ifFalse: [ self installStub ].
	self remote isStub
		ifFalse: [ "class is fully loaded" ^ self remote ].
	"we install an empty methodDict, it will be filled later"
	remoteMethodDict := EP2RemoteMethodDictionary	newWithBackend: self parent remote espellBackend.
	remoteMethodDict test.
	remoteSuperclass := self superclass
		ifNil: [ nil ]
		ifNotNil: [ self superclass ensureRemote ].
	self remote
		methodDictionary: remoteMethodDict;
		superclass: remoteSuperclass;
		format: self format.
	self register.
	^ self remote
]

{ #category : #install }
ClassModel >> installCustom [
	self subclassResponsibility 
]

{ #category : #'api - stubs creation' }
ClassModel >> installMetacircularStub [
	"I install a class stub that is instance of itself"
	| theNewMetaclass metaclassIndex |
	
	self deprecated: 'Use LanguageModel >> installMulticlassStubs:'.
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

{ #category : #install }
ClassModel >> installMethods [
	(self localMethods select: #isInstallable)
		do: [ :method | | remoteMethod | 
			remoteMethod := method install.
			self remote methodDictionary at: remoteMethod selector put: remoteMethod ]
]

{ #category : #'api - stubs creation' }
ClassModel >> installStub [
	" I install the stub of my corresponding class in the kernel.
	I depend on the implementation of installStubCustom "

	self remoteIsInstalled
		ifTrue: [ ^ self remote ].
	(self = (self parent classWithRole: #Metaclass))
		ifTrue: [ self
				error:
					'Use LanguageModel >> installMulticlassStubs to install required classes' ].
	indexInClassTable
		ifNil: [ indexInClassTable := self classLoader newClassIndex ].
		
	self metaclass installStub.
	self installStubBasic.
	self testStub.
	^ self remote
]

{ #category : #'api - stubs creation' }
ClassModel >> installStubBasic [
	" I install the stub of my corresponding class in the kernel "
	self remote: (self classLoader
								createStubForClassNamed: self name
								metaclassIndex: self metaclass indexInClassTable
								newClassIndex: self indexInClassTable).
	self classLoader
						registerClass: self remote
						named: self name
						fullyLoaded: false .
	^ self remote
]

{ #category : #hooks }
ClassModel >> installStubCustom [
	"Using method from protocol 'api-stubs creation' create your own stub and return it"
	self deprecated: 'Use first Language >> installMulticlassStubs: to create the first stubs. Use >>installStub to load classes after stub creation'.
	self subclassResponsibility
]

{ #category : #accessing }
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

{ #category : #'testing layout' }
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

{ #category : #'testing layout' }
ClassModel >> isEphemeronClass [
	^ self layout isEphemeronLayout 
]

{ #category : #'testing layout' }
ClassModel >> isImmediate [
	^ self parent immediateClassRoles contains: [:rol | rol = self role ]
]

{ #category : #'testing layout' }
ClassModel >> isImmediateClass [
	^ self layout isImmediateLayout
]

{ #category : #calypso }
ClassModel >> isInstanceSide [
	^ true
]

{ #category : #accessing }
ClassModel >> isMeta [
	"compiler compatibility"
	^ false
]

{ #category : #'testing layout' }
ClassModel >> isMetaclass [
	"languages don't have metaclasses by default"
	^ false
]

{ #category : #'testing layout' }
ClassModel >> isNilObject [
	^ false
]

{ #category : #calypso }
ClassModel >> isObsolete [
	^ false
]

{ #category : #'testing layout' }
ClassModel >> isPointers [
	
	^ self isBits not
]

{ #category : #calypso }
ClassModel >> isRootInEnvironment [
	^ self superclass == nil
]

{ #category : #'testing layout' }
ClassModel >> isVariable [
	^ self layout isVariableLayout
]

{ #category : #'testing layout' }
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

{ #category : #'accessing format' }
ClassModel >> layout [
	^ layout
]

{ #category : #'accessing format' }
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
						self parent markMaybeAccessedBehaviorsAsAccessed. 
						"We load the class in the environment so it is available for inspection 
						during the simulated execution of code"
						self ensureRemote.
						^ method ].
			lookupClass := lookupClass superclass].
	"The method was not found, so we remove the maybeAccessed property from all behaviors"
	self parent removeMaybeAccessedPropertyFromAllBehaviors.
	^ nil
]

{ #category : #marking }
ClassModel >> markMethodAsAccessed: aMethod [ 
	"We ask the class to mark the method instead of asking the method itself to do it, for handling the case in which aMethod is a compiled method coming from DASTBlock or BlockClosure" 
	([self methodNamed: aMethod selector] on: PBMethodDefinitionNotFound do: [nil])
		ifNil: [ Transcript show: 'selector ', aMethod selector, 'not found';cr. ]
		ifNotNil: [ :method | method markAsAccessed ] 
]

{ #category : #monticello }
ClassModel >> mcType [
	^ self layout mcType
]

{ #category : #calypso }
ClassModel >> metaLevelScope [
	^self isInstanceSide ifTrue: [ ClyInstanceSideScope ] ifFalse: [ self halt."ClyClassSideScope" ]
]

{ #category : #accessing }
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
	"^ self writeSlotNamed: #methodDict value: aDictionary"
	methodDict := aDictionary 
]

{ #category : #'metamodel-accessing' }
ClassModel >> methodModel [
	^ self class methodModel
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

{ #category : #'accessing backend' }
ClassModel >> name: aName [
	(self parent isNotNil and: [ self name ~= aName ])
		ifTrue: [ self parent
				ifNotNil: [ :lang | 
					lang behaviors
						removeKey: self name;
						at: aName put: self.
					lang classRoles at: self role put: aName ] ].
	super name: aName
]

{ #category : #'api - stubs creation' }
ClassModel >> newStubWithFormat: anInteger [
	" Only valid for metaclasses. 
	I create a new class stub in the kernel by instantiating myself "
	| newClass |
	self deprecated: 'Use LanguageModel >> installMulticlassStubs:'.
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

{ #category : #'accessing backend' }
ClassModel >> objectSpace [
	^ self parent objectSpace
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
	^ RBParser
]

{ #category : #printing }
ClassModel >> printOn: aStream [
	aStream 
		nextPutAll: '"';
		nextPutAll: self name asString;
		nextPutAll: '"'
]

{ #category : #printing }
ClassModel >> printSubclasses [
	^ self printSubclassesWithFormat: [ :c | c name ]
]

{ #category : #printing }
ClassModel >> printSubclassesOn: aStream format: aBlock [
	self printSubclassesOn: aStream format: aBlock indentation: 0
]

{ #category : #printing }
ClassModel >> printSubclassesOn: aStream format: aBlock indentation: aNumber [
	1 to: aNumber do: [ :i | aStream nextPutAll: '  ' ].
	aStream nextPutAll: (aBlock value: self) asString; cr.
	self subclassesDo: [:c | c printSubclassesOn: aStream format: aBlock indentation: aNumber + 1 ]
]

{ #category : #printing }
ClassModel >> printSubclassesWithFormat: aBlock [
	^ String streamContents: [:s | self printSubclassesOn: s format: aBlock]
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

{ #category : #'recursive descent' }
ClassModel >> recursivellyDo: doBlock to: nextClassesBlock [ 
	
	doBlock value: self.
	(nextClassesBlock value: self) do: [ :c | c recursivellyDo: doBlock to: nextClassesBlock  ]
]

{ #category : #hooks }
ClassModel >> register [ 
	self remoteSystemDictionary at: self name put: self remote.
	self registerCustom
]

{ #category : #hooks }
ClassModel >> registerCustom [
	self subclassResponsibility 
]

{ #category : #'accessing remote backend' }
ClassModel >> remote [
	remote ifNil: [ ^nil ].
	^ remote isNilObject 
		ifTrue: [ remote asRemoteNil ]
		ifFalse: [ remote asRemoteClass ]
]

{ #category : #'accessing remote backend' }
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

{ #category : #calypso }
ClassModel >> removeLocalMethod: aMethodModel [ 

	(aMethodModel package = self package)
		ifFalse: [ 
			self error: 'extension methods are not supported'
			"aMethodModel package removeExtensionMethod:  aMethodModel" ].
		
	self methodDict removeKey: aMethodModel selector.
	self announcer methodRemoved: aMethodModel

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

{ #category : #transforming }
ClassModel >> setLayoutKeepingSlots: anEP2Layout [
	| oldSlots |
	oldSlots := self layout ifNil: [ #() ] ifNotNil: [ self slots ].
	self layout: anEP2Layout.
	oldSlots do: [ :slot | self addSlot: slot name index: slot index ]
]

{ #category : #accessing }
ClassModel >> sharedPools [
	"compiler compatibility"
	^#()
]

{ #category : #'accessing slots' }
ClassModel >> slotNamed: aString [
	^ (self allSlots select: [ :slot | slot name = aString ])
		ifEmpty: [ PBSlotDefinitionNotFound new
				key: aString;
				signal ]
		ifNotEmpty: [ :collection | collection anyOne ]
]

{ #category : #slots }
ClassModel >> slotNamed: aString ifAbsent: aBlockClosure [ 
	^ self layout slotNamed: aString ifAbsent: aBlockClosure 
]

{ #category : #slots }
ClassModel >> slotNamed: aString ifAbsent: absentBlock ifPresent: presentBlock [ 
	^ self layout slotNamed: aString ifAbsent: absentBlock ifPresent: presentBlock 
]

{ #category : #'accessing slots' }
ClassModel >> slotNamed: aString ifNone: aBlockClosure [ 
	^ [ self slotNamed: aString ] on: KeyNotFound do: aBlockClosure
]

{ #category : #slots }
ClassModel >> slotNamed: aString ifPresent: aBlockClosure [ 
	^ self layout slotNamed: aString ifPresent: aBlockClosure 

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

{ #category : #'accessing format' }
ClassModel >> template [
	^ template 
]

{ #category : #'accessing format' }
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

{ #category : #hooks }
ClassModel >> testFull [
	self test.
	"no circularities in inheritance chain (improve)"
	self assert: self superclass ~= self.
	"all metaclasses inherit from metaclass"
	
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
ClassModel >> testStub [
	self assert: self remote isNotNil.
	self assert: self remote basicClass = self metaclass remote.
	self assert: self remote indexInClassTable = self indexInClassTable.
	self remote testStub
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

{ #category : #accessing }
ClassModel >> theNonMetaClass [
	"compiler compatibility"
	^ self
]

{ #category : #'tonel compatibility' }
ClassModel >> tonelInstanceSide [
	^ self
]

{ #category : #calypso }
ClassModel >> users [
	^ #() 
]

{ #category : #calypso }
ClassModel >> visibleMethods [
	^ self localMethods
]

{ #category : #'accessing slots' }
ClassModel >> writeSlotNamed: aString value: anObject [
	
	(self basicClass slotNamed: aString) write: anObject to: self
]
