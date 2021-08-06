Class {
	#name : #FieldAspect,
	#superclass : #PhAspect,
	#instVars : [
		'modelClass'
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

{ #category : #constants }
FieldAspect >> adviceInitializeClass [
	^ PhAdvice new
		pointcut:
			(PhPointcut new
				receivers: modelClass name;
				selectors: 'initialize';
				context: #(#receiver));
		advice: [ :context | 
			Transcript
				show: 'initializing classVars dict!';
				cr.
			"setting default value of field"
			context receiver
				perform: self fieldName , ':'
				with: self defaultFieldValue.
			"adding acessor method to the class model whose role 'metaclass' or 'class'' "
			context receiver role = modelClass role
				ifTrue: [ context receiver
						addLocalMethodFromSource: self fieldGetter
						selector: self fieldName ] ];
		type: #after
]

{ #category : #initialization }
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

{ #category : #constants }
FieldAspect >> defaultFieldValue [
	self subclassResponsibility 
]

{ #category : #constants }
FieldAspect >> fieldGetter [
	| var |
	var := self fieldName.
	^ var, ' 
	^ ' , var
]

{ #category : #constants }
FieldAspect >> fieldName [
	self subclassResponsibility 
]

{ #category : #constants }
FieldAspect >> fieldSetter [
	| var |
	var := self fieldName.
	^ var, ': anObject
	', var, ' := anObject'.
]

{ #category : #initialization }
FieldAspect >> initialize [
	super initialize.
	Transcript
		show: 'initializing ClassVar Aspect!';
		cr.
	self addClassModifier: self classModifier.
	self add: self adviceInitializeClass
]

{ #category : #'install-uninstall' }
FieldAspect >> install [
	self assert: (modelClass hasInstVarNamed: self fieldName) not.
	
	Transcript show: 'Installing ClassVar Aspect!';cr.
	super install.
	self assert: (modelClass hasInstVarNamed: self fieldName)
]

{ #category : #accessing }
FieldAspect >> modelClass: aModelClass [
	modelClass := aModelClass
]

{ #category : #'install-uninstall' }
FieldAspect >> uninstall [
	Transcript show: 'Uninstalling ClassVar Aspect!';cr.
	
	super uninstall.
	
	self assert: (modelClass hasInstVarNamed: self fieldName) not
]
