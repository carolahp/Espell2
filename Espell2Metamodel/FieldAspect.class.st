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
		'pcInitialize',
		'pcInstall'
	],
	#category : #Espell2Metamodel
}

{ #category : #'instance creation' }
FieldAspect class >> for: aClassModelClass [
	^ self basicNew 
		modelClass: aClassModelClass; 
		initialize;
		yourself.
]

{ #category : #'instance creation' }
FieldAspect class >> new [
	self error: 'use >>for:'
]

{ #category : #advices }
FieldAspect >> adviceInitializeFieldValue [
	^ PhAdvice new
		pointcut: self pcInitialize;
		advice: [ :context | 
			"setting default value of field"
			context receiver
				perform: self fieldName , ':'
				with: self defaultFieldValue.
			"adding acessor method to the class model whose role is 'metaclass' or 'class'' "
			"context receiver role = modelClass role
				ifTrue: [ context receiver
						addLocalMethodFromSource: self fieldGetter
						selector: self fieldName ]" ];
		type: #after
]

{ #category : #advices }
FieldAspect >> adviceInstallFieldValue [
	^ PhAdvice new
		pointcut: self pcInstall;
		advice: [ :context | | fieldValue model |
			model := context receiver.
			fieldValue := model perform: self fieldName.
			model remote 
				perform: self fieldName,':'
				with: (fieldValue asRemoteObjectInObjectSpace: model objectSpace)
			 ];
		type: #after
]

{ #category : #'class modifiers' }
FieldAspect >> classModifier [
	| getter setter ivar |
	ivar := self fieldName.
	getter := self fieldGetter.
	setter := self fieldSetter.
	
	^ PhClassModifier new
		on:
			(PhPointcut receivers: modelClass name selectors: #any asParser);
		addNewInstanceVar: ivar;
		addNewInstanceMethod: getter;
		addNewInstanceMethod: setter;
		yourself
]

{ #category : #accessing }
FieldAspect >> defaultFieldValue [
	self subclassResponsibility 
]

{ #category : #accessing }
FieldAspect >> fieldGetter [
	| var |
	var := self fieldName.
	^ var, ' 
	^ ' , var
]

{ #category : #accessing }
FieldAspect >> fieldName [
	self subclassResponsibility 
]

{ #category : #accessing }
FieldAspect >> fieldSetter [
	| var |
	var := self fieldName.
	^ var, ': anObject
	', var, ' := anObject'.
]

{ #category : #initialization }
FieldAspect >> initialize [
	super initialize.
	self
		addClassModifier: self classModifier;
		add: self adviceInitializeFieldValue;
		add: self adviceInstallFieldValue 
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
FieldAspect >> pcInitialize [
	^ pcInitialize
		ifNil: [ pcInitialize := PhPointcut new
				receivers: self modelClass name;
				selectors: 'initialize';
				context: #('receiver') ]
]

{ #category : #pointcuts }
FieldAspect >> pcInstall [
	^ pcInstall
		ifNil: [ pcInstall := PhPointcut new
				receivers: self modelClass name;
				selectors: 'installCustom';
				context: #('receiver') ]
]

{ #category : #'install-uninstall' }
FieldAspect >> uninstall [
	Transcript show: 'Uninstalling ClassVar Aspect!';cr.
	
	super uninstall.
	
	self assert: (modelClass hasInstVarNamed: self fieldName) not
]
