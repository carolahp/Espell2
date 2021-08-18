"
I add a custom field to instances of ClassModel.

- First I modify the class ClassModel by: 
	- adding an instance variable with the same name as the field.
	- adding two method accessors: getter and setter.
- Each time an instance of ClassModel is initialized the value of its new field is set to the result of >>defaultFieldValue

"
Class {
	#name : #FieldAspect,
	#superclass : #PhAspect,
	#instVars : [
		'modelClass',
		'customFieldValues'
	],
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
FieldAspect class >> buildDemoClassesIn: aLanguageModel [
	" adding classes and methods that use the field implemented "
	self subclassResponsibility 
]

{ #category : #'instance creation' }
FieldAspect class >> demoEntryPoint [ 
	self subclassResponsibility 
]

{ #category : #'instance creation' }
FieldAspect class >> expectedEntryPointResult [
	self subclassResponsibility 
]

{ #category : #'instance creation' }
FieldAspect class >> for: aClassModelClass [
	^ self for: aClassModelClass customValues: #() asDictionary
]

{ #category : #'instance creation' }
FieldAspect class >> for: aClassModelClass customValues: aDictionary [
	^ self basicNew
		modelClass: aClassModelClass; 
		customFieldValues: aDictionary;
		initialize;
		yourself.
]

{ #category : #'instance creation' }
FieldAspect class >> new [
	self error: 'use >>for:'
]

{ #category : #advices }
FieldAspect >> adviceBindingOf [
	^ PhAdvice new
		pointcut: self pcBindingOf;
		advice: [ :context | 
			| model varName |
			model := context receiver.
			varName := (context arguments at: 1) asSymbol.
			(model innerBindingOf: varName)
				ifNil: [ model environment bindingOf: varName ] ];
		type: #around
]

{ #category : #advices }
FieldAspect >> adviceExtendModelWithMC [
	"extend with monticello, this is only valid for fields read from tonel repository"
	^ PhAdvice new
		pointcut: self pcExtendModelWithMC;
		advice: [ :context | | model mcDef | 
			"setting default value of field"
			model := context receiver.
			mcDef := context arguments at:1.
			self extend: model withMonticello: mcDef
			];
		type: #around
]

{ #category : #advices }
FieldAspect >> adviceFirstClassModels [
	^ PhAdvice new
		pointcut: self pcFirstClassModels;
		advice: [ :context | 
			| nextAdvice |
			nextAdvice := context currentAdvice asOrderedCollection
				select: [ :each | 
					each owner class ~= self class
						and: [ each owner class isKindOf: FieldAspect ] ].
			nextAdvice
				ifNotEmpty: [ context currentAdvice: nextAdvice continueAt: 1 ].
			self firstClassModelRoles asOrderedCollection addAll: context proceed; yourself ];
		type: #around
]

{ #category : #advices }
FieldAspect >> adviceInitializeModel [
	^ PhAdvice new
		pointcut: self pcInitializeModel;
		advice: [ :context | | model value | 
			"setting default value of field"
			model := context receiver.
			value := self fieldValueFor: model.
			model
				perform: self fieldName , ':'
				with: value.
			];
		type: #after
]

{ #category : #advices }
FieldAspect >> adviceInnerBindingOf [
	^ PhAdvice new
		pointcut: self pcInnerBindingOf;
		advice: [ :context | 
			| model varName |
			model := context receiver.
			varName := (context arguments at: 1) asSymbol.
			(self innerBindingOf: varName in: model)
				ifNil: [ | next |
					next := context currentAdvice asOrderedCollection
						select: [ :each | 
							each owner class ~= self class
								and: [ each owner class isKindOf: FieldAspect ] ].
					next ifNotEmpty: [ context currentAdvice: next continueAt: 1 ].
					context proceed ] ];
		type: #around
]

{ #category : #advices }
FieldAspect >> adviceInstallModel [
	^ PhAdvice new
		pointcut: self pcInstallModel;
		advice: [ :context | | fieldValue model |
			model := context receiver.
			fieldValue := model perform: self fieldName.
			model remote 
				perform: self fieldName,':'
				with: (fieldValue asRemoteObjectInObjectSpace: model objectSpace)
			 ];
		type: #after
]

{ #category : #advices }
FieldAspect >> adviceSetCustomFieldValue [
	^ PhAdvice new
		pointcut: self pcTransformModel;
		advice: [ :context | 
			| model |
			model := context receiver.
			self customFieldValues
				at: model name asSymbol
				ifPresent: [ :val | model perform: self fieldName , ':' with: val ] ];
		type: #after
]

{ #category : #'class modifiers' }
FieldAspect >> classModifier [
	^ PhClassModifier new
		on: (PhPointcut receivers: modelClass name selectors: #any asParser);
		addNewInstanceVar: self fieldName;
		addNewInstanceMethod: self fieldMethodGetter;
		addNewInstanceMethod: self fieldMethodSetter;
		yourself
]

{ #category : #accessing }
FieldAspect >> customFieldValues [
	^ customFieldValues 
]

{ #category : #accessing }
FieldAspect >> customFieldValues: aCollection [
	customFieldValues := aCollection asDictionary
]

{ #category : #'model build' }
FieldAspect >> extend: aClassModel withMonticello: anEP2MCClassDefinition [ 
	"do nothing by default. Rewrite only for fields read from tonel repository, e.g. Metaclass"
]

{ #category : #accessing }
FieldAspect >> fieldMethodGetter [
	| var |
	var := self fieldName.
	^ var, ' 
	^ ' , var
]

{ #category : #accessing }
FieldAspect >> fieldMethodSetter [
	| var |
	var := self fieldName.
	^ var, ': anObject
	', var, ' := anObject'.
]

{ #category : #accessing }
FieldAspect >> fieldName [
	self subclassResponsibility 
]

{ #category : #accessing }
FieldAspect >> fieldValueFor: aClassModel [ 
	self subclassResponsibility 
]

{ #category : #accessing }
FieldAspect >> firstClassModelRoles [
	self subclassResponsibility 
]

{ #category : #initialization }
FieldAspect >> initialize [
	super initialize.
	self
		addClassModifier: self classModifier;
		add: self adviceInitializeModel;
		add: self adviceSetCustomFieldValue;
		add: self adviceInstallModel;
		add: self adviceBindingOf;
		add: self adviceInnerBindingOf;
		add: self adviceFirstClassModels 
		
]

{ #category : #binding }
FieldAspect >> innerBindingOf: aSymbol in: aClassModel [
	self subclassResponsibility 
]

{ #category : #'install-uninstall' }
FieldAspect >> install [
	self assert: (modelClass hasInstVarNamed: self fieldName) not.
	super install.
	self assert: (modelClass hasInstVarNamed: self fieldName)
]

{ #category : #accessing }
FieldAspect >> modelClass [
	^ modelClass
]

{ #category : #accessing }
FieldAspect >> modelClass: aModelClass [
	modelClass := aModelClass
]

{ #category : #pointcuts }
FieldAspect >> pcBindingOf [
	^ PhPointcut new
		receivers: self modelClass name;
		selectors: 'bindingOf:';
		context: #('receiver' 'arguments')
]

{ #category : #pointcuts }
FieldAspect >> pcExtendModelWithMC [
	^ PhPointcut new
		receivers: self modelClass name;
		selectors: 'extendWithMonticelloCustom:';
		context: #('receiver' 'arguments')
]

{ #category : #pointcuts }
FieldAspect >> pcFirstClassModels [
	^ PhPointcut new
		receivers: self modelClass class name;
		selectors: 'customFirstClassModels';
		context: #('advice')
]

{ #category : #pointcuts }
FieldAspect >> pcInitializeModel [
	^ PhPointcut new
		receivers: self modelClass name;
		selectors: 'initialize';
		context: #('receiver')
]

{ #category : #pointcuts }
FieldAspect >> pcInnerBindingOf [
	^ PhPointcut new
		receivers: self modelClass name;
		selectors: 'innerBindingOf:';
		context: #('receiver' 'arguments' 'advice')
]

{ #category : #pointcuts }
FieldAspect >> pcInstallModel [
	^ PhPointcut new
		receivers: self modelClass name;
		selectors: 'installCustom';
		context: #('receiver')
]

{ #category : #pointcuts }
FieldAspect >> pcTransformModel [
	^ PhPointcut new
		receivers: self modelClass name;
		selectors: 'transform';
		context: #('receiver')
]

{ #category : #'model build' }
FieldAspect >> transformLanguage: aLanguageModel [
	self transformLanguageBasic: aLanguageModel.
	self transformLanguageCustom: aLanguageModel
]

{ #category : #'model build' }
FieldAspect >> transformLanguageBasic: aLanguageModel [
	(aLanguageModel classWithRole: self modelClass role)
		addLocalMethodFromSource: self fieldMethodGetter
			selector: self fieldName;
		addLocalMethodFromSource: self fieldMethodSetter
			selector: self fieldName , ':'.
	self class buildDemoClassesIn: aLanguageModel
]

{ #category : #'model build' }
FieldAspect >> transformLanguageCustom: aLanguageModel [
	self subclassResponsibility 
]

{ #category : #'install-uninstall' }
FieldAspect >> uninstall [
	Transcript show: 'Uninstalling ',self class name,' Aspect!';cr.
	
	super uninstall.
	
	self assert: (modelClass hasInstVarNamed: self fieldName) not
]
