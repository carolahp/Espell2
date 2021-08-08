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
FieldAspect >> adviceInitializeFieldValue [
	^ PhAdvice new
		pointcut: self pcInitializeClass;
		advice: [ :context | | model | 
			"setting default value of field"
			model := context receiver.
			model
				perform: self fieldName , ':'
				with: self defaultFieldValue.
			];
		type: #after
]

{ #category : #advices }
FieldAspect >> adviceInnerBindingOf [
	self subclassResponsibility 
]

{ #category : #advices }
FieldAspect >> adviceInstallFieldValue [
	^ PhAdvice new
		pointcut: self pcInstallClass;
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
		pointcut: self pcTransformClass;
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

{ #category : #accessing }
FieldAspect >> defaultFieldValue [
	self subclassResponsibility 
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

{ #category : #initialization }
FieldAspect >> initialize [
	super initialize.
	self
		addClassModifier: self classModifier;
		add: self adviceInitializeFieldValue;
		add: self adviceSetCustomFieldValue;
		add: self adviceInstallFieldValue;
		add: self adviceBindingOf;
		add: self adviceInnerBindingOf 
		
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
FieldAspect >> pcInitializeClass [
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
FieldAspect >> pcInstallClass [
	^ PhPointcut new
		receivers: self modelClass name;
		selectors: 'installCustom';
		context: #('receiver')
]

{ #category : #pointcuts }
FieldAspect >> pcTransformClass [
	^ PhPointcut new
		receivers: self modelClass name;
		selectors: 'transform';
		context: #('receiver')
]

{ #category : #'install-uninstall' }
FieldAspect >> uninstall [
	Transcript show: 'Uninstalling ClassVar Aspect!';cr.
	
	super uninstall.
	
	self assert: (modelClass hasInstVarNamed: self fieldName) not
]
